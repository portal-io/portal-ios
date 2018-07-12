//
//  WVRInAppPurchaseManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 苹果内购支付

#import "WVRInAppPurchaseManager.h"

#import "WVRSQLiteManager.h"
#import "SQMD5Tool.h"
#import "WVRPayHeader.h"

#import "WVRPayModel.h"
#import "WVROrderModel.h"
#import "WVRPayCreateOrder.h"
#import "WVRAppInPurchaseResultUseCase.h"
#import "WVRAppInPurchaseResultModel.h"

#import "WVRPayCallbackLoadingView.h"
#import "YYModel.h"

#define kIOSPurchaseType @"40582FD9679C057B"

NSString * const IAPStorePurchasedSuccessedNotification = @"IAPStorePurchasedSuccessedNotification";

@interface WVRInAppPurchaseManager () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) WVRInAppPurchaseModel *purchaseModel;
@property (nonatomic, weak) WVRPayModel *payModel;

@property (atomic, strong) NSMutableArray<WVRInAppPurchaseModel *> *purchaseModels;

@property (nonatomic, copy) BuyProductCompletionHandler completionHandler;

@property (nonatomic, strong) WVRPayCallbackLoadingView * gCallbackLoadingV;

@property (nonatomic, strong) WVRPayCreateOrder * gCreateOrder;

@property (nonatomic, strong) WVRAppInPurchaseResultUseCase *checkResultUC;

@end


@implementation WVRInAppPurchaseManager
@synthesize products = _products;

+ (instancetype)sharedInstance {
    static WVRInAppPurchaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _purchaseModels = [NSMutableArray array];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        self.gCallbackLoadingV = (WVRPayCallbackLoadingView *)VIEW_WITH_NIB(NSStringFromClass([WVRPayCallbackLoadingView class]));
        self.gCallbackLoadingV.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

#pragma mark - helpless func for a singleton object

- (void)dealloc {
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - External func

// MARK: - step 1
- (void)buyWithPurchaseModel:(WVRPayModel *)model
           completionHandler:(BuyProductCompletionHandler)completionHandler {
    
//    self.purchaseModel = model;
    self.payModel = model;
    self.purchaseModel = [self payModelConvertToPurchaseModel:model];
    
    [self.purchaseModels addObject:self.purchaseModel];
    self.completionHandler = completionHandler;
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self.gCallbackLoadingV];
    [self createOrderForInAppPurchase];
}

- (WVRInAppPurchaseModel *)payModelConvertToPurchaseModel:(WVRPayModel *)payModel {
    
    WVRInAppPurchaseModel * model = [[WVRInAppPurchaseModel alloc] init];
    
    model.goodsNo = payModel.goodsCode;
    model.price = payModel.goodsPrice;
    model.goodsType = payModel.goodsType;
    
    model.relatedCode = payModel.relatedCode;
    model.relatedType = payModel.relatedType;
    
    return model;
}

#pragma mark - pravite func

// MARK: - step 3
- (void)requestForProductsForModel:(WVRInAppPurchaseModel *)model {
    
    NSSet *productIdentifiers = [NSSet setWithObject:model.iosProductCode];
    
    if ([SKPaymentQueue canMakePayments] == NO) {
#if (kAppEnvironmentTest == 1)
        SQToastInKeyWindow(@"user don't allow payment");
#endif
        return;
    }
    
//    if (self.products) {
//
//        SKProduct *product = [self validProductExist:model.iosProductCode];
//        if (nil != product) {
//
//            NSLog(@"Buying %@...", product.productIdentifier);
//
//            SKPayment *payment = [SKPayment paymentWithProduct:product];
//            [[SKPaymentQueue defaultQueue] addPayment:payment];
//
//            [self.gCallbackLoadingV updateStatusMsg:kInAppPurchaseing];
//
//        } else {
//#if (kAppEnvironmentTest == 1)
//            SQToastInKeyWindow(@"productIdentifier does not exist.");
//#endif
//        }
//    } else {
//
//    }
    
    // 先去请求商品列表，再购买 (！！！这里需要每次都请求，否则可能会有缓存问题导致后续购买失败)
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    
    productRequest.orderNo = model.orderNo;
    productRequest.productId = model.iosProductCode;
    productRequest.delegate = self;
    
    [productRequest start];
}

- (void)restoreCompletedTransactions {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// MARK: - step 2
- (void)createOrderForInAppPurchase {
    
    if (!self.gCreateOrder) {
        self.gCreateOrder = [[WVRPayCreateOrder alloc] init];
        @weakify(self);
        [self.gCreateOrder.successSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self createrOrderSuccess:x];
        }];
        [self.gCreateOrder.failSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self createOrderFail:x];
        }];
        [self.gCreateOrder.isHaveOrderSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self isHaveOrder];
        }];
        [self.gCreateOrder.payStatusSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.gCallbackLoadingV updateStatusMsg:x];
        }];
    }
    [self.gCreateOrder createOrder:self.payModel];
}

- (void)isHaveOrder {
    
    DDLogError(@"内购支付异常状态： %@", kIsHaveOrder);
    [self.gCallbackLoadingV removeFromSuperview];
    SQToastInKeyWindow(kIsHaveOrder);
    
    if (self.completionHandler) {
        NSError *err = [NSError errorWithDomain:kIsHaveOrder code:400 userInfo:nil];
        self.completionHandler(err);
        self.completionHandler = nil;
    }
}

- (void)createrOrderSuccess:(WVROrderModel *)orderModel {
    
    self.purchaseModel.orderNo = orderModel.orderNo;
    self.purchaseModel.iosProductCode = orderModel.iosProductCode;
    
    [self requestForProductsForModel:self.purchaseModel];
}

// 支付流程中有接口出现失败
- (void)createOrderFail:(NSString *)errMsg {
    DDLogError(@"内购支付异常状态： %@", kCreateFail);
    
    [self.gCallbackLoadingV removeFromSuperview];
    SQToastInKeyWindow(kCreateFail);
    
    if (self.completionHandler) {
        NSError *err = [NSError errorWithDomain:errMsg code:400 userInfo:nil];
        self.completionHandler(err);
        self.completionHandler = nil;
    }
}

- (void)requestForAppInPurchaseResultWithOrderNo:(NSString *)orderNo iosTradeNo:(NSString *)iosTradeNo phoneNo:(NSString *)phoneNo block:(void (^)(BOOL success, NSError *error))block {
    
    if (!self.checkResultUC) {
        self.checkResultUC = [[WVRAppInPurchaseResultUseCase alloc] init];
        
        [[self.checkResultUC buildUseCase] subscribeNext:^(id  _Nullable x) {
            WVRAppInPurchaseResultModel *model = x;
            if (model.code == 200) {
                if (block) {
                    block(YES, nil);
                }
            } else {
                NSString *msg = [NSString stringWithFormat:@"%@", model.msg];
                NSError *err = [NSError errorWithDomain:msg code:model.code userInfo:nil];
                if (block) {
                    block(NO, err);
                }
            }
        }];
        [[self.checkResultUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            NSError *err = [NSError errorWithDomain:@"fail" code:400 userInfo:x];
            if (block) {
                block(NO, err);
            }
        }];
    }
    
    self.checkResultUC.orderNo = orderNo;
    self.checkResultUC.iosTradeNo = iosTradeNo;
    self.checkResultUC.phoneNo = phoneNo;
    
    [[self.checkResultUC getRequestCmd] execute:nil];
}

- (SKProduct *)validProductExist:(NSString *)productIdentifier {
    SKProduct *product = nil;
    
    for (SKProduct *tempProduct in self.products) {
        if ([tempProduct.productIdentifier isEqualToString:productIdentifier]) {
            product = tempProduct;
        }
    }
    return product;
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    if (self.completionHandler) {
        
        self.completionHandler(transaction.error);
        self.completionHandler = nil;
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    SQToastInKeyWindow(kFailCallback);
    [self.gCallbackLoadingV removeFromSuperview];
}

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {
    
    if (nil == _purchaseModel.orderNo) { return; }
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    DDLogInfo(@"Receipt: %@", encodeStr);
    
    // 先将本地获取到的结果写入数据库，服务端返回成功后再删除
    _purchaseModel.receipt = encodeStr;
    [[WVRSQLiteManager sharedManager] insertIAPOrder:[_purchaseModel yy_modelToJSONObject]];
    
    kWeakSelf(self);
    [self requestForAppInPurchaseResultWithOrderNo:_purchaseModel.orderNo iosTradeNo:encodeStr phoneNo:[WVRUserModel sharedInstance].mobileNumber block:^(BOOL success, NSError *error) {
        
        if (NO == success) {
            NSLog(@"验证失败");
            
            if (weakself.completionHandler) {
                weakself.completionHandler(error);
                weakself.completionHandler = nil;
            }
            [weakself handlePurchaseFailedResult:error];
        } else {
            NSLog(@"验证成功");
            
            if (weakself.completionHandler) {
                weakself.completionHandler(nil);
                weakself.completionHandler = nil;
            }
            [weakself handlePurchaseSuccessResult];
        }
        
        [self.gCallbackLoadingV removeFromSuperview];
    }];
}

- (void)handlePurchaseSuccessResult {
    
    [[WVRSQLiteManager sharedManager] removeIAPOrder:self.purchaseModel.orderNo];
    [self.purchaseModels removeObject:self.purchaseModel];
    self.purchaseModel = nil;
}

- (void)handlePurchaseFailedResult:(NSError *)error {
    
    NSDictionary *dict = error.userInfo;
    
    if (nil == dict) {
        
        SQToastInKeyWindow(kNetError);
    } else {
        int code = [dict[@"code"] intValue];
        int subCode = [dict[@"subCode"] intValue];
        
        switch (code) {
            case 400: {
                if (subCode != 23) {
                    
                    [[WVRSQLiteManager sharedManager] removeIAPOrder:self.purchaseModel.orderNo];
                    break;
                }
                // 走到401的逻辑
            }
            case 401:
                // alert for remind user
                
                break;
            
            case 500:
                // try again later
                
                break;
            
            default:
                break;
        }
    }
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    
    NSLog(@"Invalid product id: %@" , response.invalidProductIdentifiers);
    
    NSArray<SKProduct *> *skProducts = response.products;
    _products = skProducts;
    
    DDLogInfo(@"付费产品数量: %d个", (int)[skProducts count]);
    
    SKProduct *product = nil;
    for (SKProduct *pro in skProducts) {
        
        DDLogInfo(@"%@", pro.productIdentifier);
        if ([pro.productIdentifier isEqualToString:request.productId]) {
            product = pro;
            DDLogInfo(@"productIdentifier 匹配成功");
            break;
        }
    }
    
    if (nil != product) {
        DDLogInfo(@"发送购买请求");
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        [self.gCallbackLoadingV updateStatusMsg:kInAppPurchaseing];
        
    } else {
        if (self.completionHandler) {
            NSError *err = [NSError errorWithDomain:@"商品编号不匹配" code:400 userInfo:nil];
            self.completionHandler(err);
            self.completionHandler = nil;
        }
#if (kAppEnvironmentTest == 1)
        SQToastInKeyWindow(@"Error: 商品编号不匹配");
#endif
        [self.gCallbackLoadingV removeFromSuperview];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    if (self.completionHandler) {
        self.completionHandler(error);
        self.completionHandler = nil;
    }
#if (kAppEnvironmentTest == 1)
    SQToastInKeyWindow(@"请求商品列表失败");
#endif
    [self.gCallbackLoadingV removeFromSuperview];
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * _Nonnull transaction,
                                               NSUInteger idx,
                                               BOOL * _Nonnull stop) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                self.gCallbackLoadingV.alpha = 0;
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - external func

+ (void)reportLostInAppPurchaseOrders {
    
    NSArray<NSDictionary *> *orders = [[WVRSQLiteManager sharedManager] ordersInIAPOrder];
    
    for (NSDictionary *orderDict in orders) {
        
        WVRInAppPurchaseModel *order = [WVRInAppPurchaseModel yy_modelWithDictionary:orderDict];
        
        [[self sharedInstance] requestForAppInPurchaseResultWithOrderNo:order.orderNo iosTradeNo:order.receipt phoneNo:order.phoneNo block:^(BOOL success, NSError *error) {
            
            // 上报成功或服务器返回数据且错误码不是服务端和网络错误
            if (success || (error.userInfo && error.code < 500)) {
                
                [[WVRSQLiteManager sharedManager] removeIAPOrder:order.orderNo];
            }
        }];
    }
}

- (WVRInAppPurchaseModel *)iapOrderResult:(NSDictionary *)result {
    
    WVRInAppPurchaseModel *model = [WVRInAppPurchaseModel yy_modelWithDictionary:result];
    
    return model;
}

@end


@implementation WVRInAppPurchaseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _uid = [WVRUserModel sharedInstance].accountId;
        _phoneNo = [WVRUserModel sharedInstance].mobileNumber;
    }
    return self;
}

- (void)dealloc {
    
    NSLog(@"WVRInAppPurchaseModel dealloc");
}

@end


static const void *orderNoKey = &orderNoKey;
static const void *productIdKey = &productIdKey;

@implementation SKProductsRequest (Extend)

- (void)setOrderNo:(NSString *)orderNo {
    
    objc_setAssociatedObject(self, orderNoKey, orderNo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)orderNo {
    
    return objc_getAssociatedObject(self, orderNoKey);
}

- (void)setProductId:(NSString *)productId {
    
    objc_setAssociatedObject(self, productIdKey, productId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)productId {
    
    return objc_getAssociatedObject(self, productIdKey);
}

@end


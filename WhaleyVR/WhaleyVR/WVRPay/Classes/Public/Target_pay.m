//
//  Target_program.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_pay.h"

#import "WVRMyTicketVC.h"
#import "WVRPayManager.h"
#import "WVRInAppPurchaseManager.h"

#import "WVRCheckDeviceUseCase.h"
#import "WVRPayReportDeviceUseCase.h"

#import "WVRCheckPayUseCase.h"
#import "WVRCheckGoodsPayedUseCase.h"

@interface Target_pay ()

@property (nonatomic, strong) WVRCheckPayUseCase *checkPayUC;
@property (nonatomic, strong) WVRCheckGoodsPayedUseCase *checkPayListUC;

@property (nonatomic, strong) WVRCheckDeviceUseCase *checkDeviceUC;
@property (nonatomic, strong) WVRPayReportDeviceUseCase *reportDeviceUC;

@end


@implementation Target_pay

- (UIViewController *)Action_nativeFetchMyTicketViewController:(NSDictionary *)params {
    
    WVRMyTicketVC * vc = [[WVRMyTicketVC alloc] init];
    return vc;
}


- (void)Action_nativePayForVideo:(NSDictionary *)params {
    
    WVRItemModel *model = params[@"itemModel"];
    WVRStreamType type = [params[@"streamType"] integerValue];
    RACCommand *cmd = params[@"cmd"];
    
    WVRPayModel * payModel = [WVRPayModel createWithDetailModel:model streamType:type];
    
    [[WVRPayManager shareInstance] showPayAlertViewWithPayModel:payModel viewController:[UIViewController getCurrentVC] resultCallback:^(WVRPayManageResultStatus status) {
        
        NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
        resDict[@"success"] = @(status);    // == WVRPayManageResultStatusSuccess
        resDict[@"msg"] = [WVRPayManager messageForStatus:status];
        [cmd execute:resDict];
    }];
}

- (void)Action_nativePayForWCurrency:(NSDictionary *)params
{
    RACCommand *cmd = params[@"cmd"];
    WVRPayModel *payModel = [[WVRPayModel alloc] init];
    
    payModel.fromType = PayFromTypeApp;
    payModel.goodsCode = params[@"goodsCode"];
    payModel.goodsPrice = [params[@"goodsPrice"] integerValue];
    payModel.goodsName = params[@"goodsName"];
    payModel.originPrice = [params[@"originPrice"] integerValue];
    payModel.prePrice = [params[@"preferPrice"] integerValue];
    payModel.giveWCurrency = [params[@"giveWCurrency"] integerValue];
    payModel.payComeFromType = WVRPayComeFromTypeWCurrency;
    [[WVRPayManager shareInstance] showPayAlertViewWithPayModel:payModel viewController:[UIViewController getCurrentVC] resultCallback:^(WVRPayManageResultStatus status) {
        
        NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
        resDict[@"success"] = @(status);// == WVRPayManageResultStatusSuccess
        resDict[@"msg"] = [WVRPayManager messageForStatus:status];
        [cmd execute:resDict];
    }];
}

- (void)Action_nativeCheckDevice:(NSDictionary *)params {
    
    RACCommand * cmd = params[@"cmd"];
    
    if (!self.checkDeviceUC) {
        
        self.checkDeviceUC = [[WVRCheckDeviceUseCase alloc] init];
        
        [[self.checkDeviceUC buildUseCase] subscribeNext:^(NSNumber *  _Nullable x) {
            if (!x.boolValue) {
                [cmd execute:x];
            }
        }];
        [[self.checkDeviceUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            
        }];
    }
    [[self.checkDeviceUC getRequestCmd] execute:nil];
}

- (void)Action_nativePayReportDevice:(NSDictionary *)params {
    
    RACCommand * cmd = params[@"cmd"];
    
    if (!self.reportDeviceUC) {
        
        self.reportDeviceUC = [[WVRPayReportDeviceUseCase alloc] init];
        
        [[self.reportDeviceUC buildUseCase] subscribeNext:^(NSNumber *  _Nullable x) {
            if (!x.boolValue) {
                [cmd execute:x];
            }
        }];
        [[self.reportDeviceUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            
        }];
    }
    [[self.reportDeviceUC getRequestCmd] execute:nil];
}

- (void)Action_nativeCheckIsPaied:(NSDictionary *)params {
    
    RACCommand * cmd = params[@"cmd"];
    RACCommand * failCmd = params[@"failCmd"];
    
    NSString *goodNo = params[@"goodNo"];
    NSString *goodType = params[@"goodType"];
    
    [self checkIsPaiedForVideo:goodNo goodType:goodType cmd:cmd failCmd:failCmd];
}

- (void)Action_nativeCheckVideosIsPaied:(NSDictionary *)params {
    
    RACCommand * cmd = params[@"cmd"];
    RACCommand * failCmd = params[@"failCmd"];
    
    NSArray *items = params[@"items"];
    
    [self checkIsPaidForVideos:items cmd:cmd failCmd:failCmd];
}

- (void)Action_nativeReportLostInAppPurchaseOrders:(NSDictionary *)params {
    
    [WVRInAppPurchaseManager reportLostInAppPurchaseOrders];
}

#pragma mark - private func

- (void)checkIsPaiedForVideo:(NSString *)goodNo goodType:(NSString *)goodType cmd:(RACCommand *)cmd failCmd:(RACCommand *)failCmd {
    
    if (!goodNo.length || !goodType.length) {
        DDLogError(@"checkIsPaiedForVideo goodNo or goodType error!");
        return;
    }
    if (!self.checkPayUC) {
        self.checkPayUC = [[WVRCheckPayUseCase alloc] init];
        [[self.checkPayUC buildUseCase] subscribeNext:^(id  _Nullable x) {
            
            [cmd execute:x];
        }];
        [[self.checkPayUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            
            [failCmd execute:x];
        }];
    }
    
    self.checkPayUC.goodsType = goodType;
    self.checkPayUC.goodsNo = goodNo;
    
    [[self.checkPayUC checkPayCmd] execute:nil];
}

- (void)checkIsPaidForVideos:(NSArray<NSDictionary *> *)items cmd:(RACCommand *)cmd failCmd:failCmd {
    
    if (![items isKindOfClass:[NSArray class]]) {
        DDLogError(@"checkIsPaidForVideos params error!");
        return;
    }
    
    NSString *goodsNos = @"";
    NSString *goodsTypes = @"";
    
    for (NSDictionary *item in items) {
        NSString *sid = item[@"goodNo"];
        NSString *type = item[@"goodType"];
        
        goodsNos = [[goodsNos stringByAppendingString:sid] stringByAppendingString:@","];
        goodsTypes = [[goodsTypes stringByAppendingString:type] stringByAppendingString:@","];;
    }
    // 删除最后一个逗号
    if ([goodsNos hasSuffix:@","]) { goodsNos = [goodsNos substringToIndex:goodsNos.length - 1]; }
    if ([goodsTypes hasSuffix:@","]) { goodsTypes = [goodsTypes substringToIndex:goodsTypes.length - 1]; }
    
    if (!self.checkPayListUC) {
        self.checkPayListUC = [[WVRCheckGoodsPayedUseCase alloc] init];
        [[self.checkPayListUC buildUseCase] subscribeNext:^(id  _Nullable x) {
            
            [cmd execute:x];
        }];
        [[self.checkPayListUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            
            [failCmd execute:x];
        }];
    }
    
    self.checkPayListUC.goodsTypes = goodsTypes;
    self.checkPayListUC.goodsNos = goodsNos;
    
    [[self.checkPayListUC checkPayCmd] execute:nil];
}

@end

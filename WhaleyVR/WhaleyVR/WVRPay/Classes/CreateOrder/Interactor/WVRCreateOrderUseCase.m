//
//  WVRCreateOrderUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCreateOrderUseCase.h"
#import "WVRApiHttpCreateOrder.h"
#import "WVRErrorViewModel.h"
#import "WVROrderModel.h"
#import "WVRHttpCreateOrderReformer.h"
#import "WVRUserModel.h"

@implementation WVRCreateOrderUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpCreateOrder alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        @strongify(self);
        WVROrderModel * orderModel = [self.requestApi fetchDataWithReformer:[WVRHttpCreateOrderReformer new]];
        return orderModel;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)buildErrorCase {
    
    return [self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }];
}

// WVRUseCaseProtocol delegate
- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[kHttpParam_CreateOrder_uid] = [[WVRUserModel sharedInstance] accountId];
        dict[kHttpParam_CreateOrder_goodsNo] = self.goodCode;
        dict[kHttpParam_CreateOrder_goodsType] = self.goodType;
        dict[kHttpParam_CreateOrder_price] = [NSString stringWithFormat:@"%ld", self.goodPrice];
        dict[kHttpParam_CreateOrder_payMethod] = [self payPlatformName:self.payPlatform];
        
        if (self.payPlatform == WVRPayPlatformAppIn) {
            dict[@"thirdPayType"] = @"ios_pay";
            dict[@"phoneNum"] = [WVRUserModel sharedInstance].mobileNumber;
        }
        
        dict[kHttpParam_CreateOrder_sign] = [self sign];
        
        params = dict;
    }
    return params;
}

- (NSString *)payPlatformName:(WVRPayPlatform)platform {
    
    switch (platform) {
        case WVRPayPlatformWeixin:
            return @"weixin";
            
        case WVRPayPlatformAlipay:
            return @"alipay";
            
        case WVRPayPlatformAppIn:
            return @"appStore";

            // 鲸币支付不需要创建订单
//        case WVRPayPlatformWhaleyCurrency:
//            return @"whaleyCurrency";
            
        default:
            return @"";
    }
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@%ld%@", [[WVRUserModel sharedInstance] accountId], self.goodCode, self.goodType, self.goodPrice, [self payPlatformName:self.payPlatform]];
    
    if (self.payPlatform == WVRPayPlatformAppIn) {
        unSignStr = [unSignStr stringByAppendingString:@"ios_pay"];
        unSignStr = [unSignStr stringByAppendingString:[WVRUserModel sharedInstance].mobileNumber];
    }
    
    unSignStr = [unSignStr stringByAppendingString:[WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)createOrderCmd {
    
    return self.requestApi.requestCmd;
}

@end


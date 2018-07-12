//
//  WVRCurrencyCostUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币消费UseCase

#import "WVRCurrencyCostUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpCurrencyCost.h"

@implementation WVRCurrencyCostUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpCurrencyCost alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value;
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
        
        dict[kHttpParam_currencyCost_uid] = [[WVRUserModel sharedInstance] accountId];
        dict[kHttpParam_currencyCost_nickName] = [[WVRUserModel sharedInstance] username];
        dict[kHttpParam_currencyCost_userHeadUrl] = [[WVRUserModel sharedInstance] loginAvatar];
        dict[kHttpParam_currencyCost_buyType] = self.buyType ?: @"REDUCE_GIFT";
        dict[kHttpParam_currencyCost_bizParams] = self.bizParams;
        dict[kHttpParam_currencyCost_buyParams] = self.buyParams;
        
        dict[kHttpParam_currencyCost_sign] = [self sign:dict];
        
        params = dict;
    }
    return params;
}

- (NSString *)sign:(NSDictionary*)params {
    
//    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@%@", [[WVRUserModel sharedInstance] accountId], @"", @"", [WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [SQMD5Tool encryptByMD5ForValuesWithParams:params md5Suffix:[WVRUserModel CMCPURCHASE_sign_secret]];
    return signStr;
}

- (RACCommand *)checkPayCmd {
    
    return self.requestApi.requestCmd;
}

@end

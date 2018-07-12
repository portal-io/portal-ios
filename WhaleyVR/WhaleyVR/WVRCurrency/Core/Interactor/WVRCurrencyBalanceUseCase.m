//
//  WVRCurrencyBalanceUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币余额UseCase

#import "WVRCurrencyBalanceUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpCurrencyBalance.h"

@implementation WVRCurrencyBalanceUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpCurrencyBalance alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSDictionary *dic = value.content;
        
        // balance为nil 则表示请求出错
        NSString* balance = dic[@"data"];
        /// 用户鲸币余额赋值
        [WVRUserModel sharedInstance].wcBalance = [balance integerValue];
        return balance;
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (manager == self.requestApi) {
        params[@"uid"] = [[WVRUserModel sharedInstance] accountId];
        
        params[@"sign"] = [self sign];
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@", [[WVRUserModel sharedInstance] accountId],[WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)requestCmd {
    
    return self.requestApi.requestCmd;
}

@end

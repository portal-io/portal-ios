//
//  WVRCheckPayUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCheckPayUseCase.h"
#import "WVRApiHttpCheckPay.h"
#import "WVRErrorViewModel.h"

@implementation WVRCheckPayUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpCheckPay alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSDictionary *dic = value.content;
//
        NSString* isPay = dic[@"data"][@"result"];
        
        return isPay;
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
        
        dict[kHttpParam_checkPay_uid] = [[WVRUserModel sharedInstance] accountId];
        dict[kHttpParam_checkPay_goodsNo] = self.goodsNo;
        dict[kHttpParam_checkPay_goodsType] = self.goodsType;
        dict[kHttpParam_checkPay_sign] = [self sign];
        
        params = dict;
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@%@", [[WVRUserModel sharedInstance] accountId], self.goodsNo, self.goodsType, [WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)checkPayCmd {
    
    return self.requestApi.requestCmd;
}

@end

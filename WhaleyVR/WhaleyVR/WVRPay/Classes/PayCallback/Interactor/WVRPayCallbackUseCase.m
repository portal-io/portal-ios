//
//  WVRPayCallbackUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPayCallbackUseCase.h"
#import "WVRApiHttpPayCallback.h"
#import "WVRErrorViewModel.h"
#import "WVRGlobalUtil.h"

@implementation WVRPayCallbackUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpPayCallback alloc] init];
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
        dict[kHttpParam_PayCallback_orderNo] = self.orderNo;
        dict[kHttpParam_PayCallback_payMethod] = self.payMethod;
        dict[kHttpParam_PayCallback_sign] = [self sign];
        
        params = dict;
    }
    return params;
}


- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@", self.orderNo, self.payMethod, [WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)payCallbackCmd {
    
    return self.requestApi.requestCmd;
}

@end

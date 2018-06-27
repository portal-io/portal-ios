//
//  WVRForgotPWUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRForgotPWUseCase.h"
#import "WVRApiHttpForgotPassword.h"
#import "WVRErrorViewModel.h"

@interface WVRForgotPWUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end

@implementation WVRForgotPWUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpForgotPassword alloc] init];
}


-(WVRRefreshTokenUseCase *)gRefreshTokenUC
{
    if (!_gRefreshTokenUC) {
        _gRefreshTokenUC = [[WVRRefreshTokenUseCase alloc] init];
    }
    return _gRefreshTokenUC;
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        NSString * code = value.content[@"code"];
        return [self.gRefreshTokenUC filterTokenValide:code retryCmd:self.getRequestCmd];
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
        params = @{
                   Params_forgotPW_code:self.inputCode,
                   Params_forgotPW_password:self.inputPW,
                   };
    }
    return params;
}

@end

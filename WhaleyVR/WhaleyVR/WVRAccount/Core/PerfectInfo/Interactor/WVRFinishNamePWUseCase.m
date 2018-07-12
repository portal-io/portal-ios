//
//  WVRFinishNamePWUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFinishNamePWUseCase.h"
#import "WVRApiHttpFinishNamePassword.h"
#import "WVRErrorViewModel.h"

@interface WVRFinishNamePWUseCase()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end

@implementation WVRFinishNamePWUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpFinishNamePassword alloc] init];
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
        return [self.gRefreshTokenUC filterTokenValide:code retryCmd:[self getRequestCmd]];
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
                   Params_finishNamePW_nickname:self.nickName,
                   Params_finishNamePW_device_id:[WVRUserModel sharedInstance].deviceId,
                   Params_finishNamePW_accesstoken:[WVRUserModel sharedInstance].sessionId,
                   Params_finishNamePW_password:self.password,
                   };
    }
    return params;
}
@end

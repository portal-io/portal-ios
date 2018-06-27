//
//  WVRModifyPhoneNUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModifyPhoneNUseCase.h"
#import "WVRApiHttpChangePhone.h"
#import "WVRErrorViewModel.h"

@interface WVRModifyPhoneNUseCase()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end

@implementation WVRModifyPhoneNUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpChangePhone alloc] init];
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
                   Params_changePhoneNum_code:self.inputCode,
                   Params_changePhoneNum_ncode:@"86",
                   Params_changePhoneNum_phone:self.inputPhoneNum,
                   Params_changePhoneNum_device_id:[WVRUserModel sharedInstance].deviceId,
                   Params_changePhoneNum_accesstoken:[WVRUserModel sharedInstance].sessionId
                   };
    }
    return params;
}

@end

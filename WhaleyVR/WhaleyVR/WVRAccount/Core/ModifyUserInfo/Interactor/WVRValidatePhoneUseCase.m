//
//  WVRValidatePhoneUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRValidatePhoneUseCase.h"
#import "WVRHttpValidatePhone.h"
#import "WVRErrorViewModel.h"

@interface WVRValidatePhoneUseCase()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end


@implementation WVRValidatePhoneUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRHttpValidatePhone alloc] init];
}

- (WVRRefreshTokenUseCase *)gRefreshTokenUC
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
                   Params_validatePhoneNum_ncode: @"86",
                   Params_validatePhoneNum_phone: self.inputPhoneNum,
                   Params_validatePhoneNum_device_id: [WVRUserModel sharedInstance].deviceId,
                   Params_validatePhoneNum_accesstoken: [WVRUserModel sharedInstance].sessionId
                   };
    }
    return params;
}
@end

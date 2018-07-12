//
//  WVRRegisterUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRegisterUseCase.h"
#import "WVRApiHttpRegister.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpUserModel.h"
#import "WVRModelUserInfoReformer.h"

@implementation WVRRegisterUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpRegister alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {

        return value;
    }] doNext:^(WVRNetworkingResponse *  _Nullable x) {
        WVRModelUserInfo * userInfo = [self.requestApi fetchDataWithReformer:[[WVRModelUserInfoReformer alloc] init]];
        [WVRUserModel sharedInstance].sessionId = userInfo.accesstoken;
        if (userInfo.username)
            [WVRUserModel sharedInstance].username = userInfo.username;
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
                   sms_register_device_id:[WVRUserModel sharedInstance].deviceId,
                   sms_register_mobile:self.mobile,
                   sms_register_from:@"whaleyVR",
                   sms_register_code:self.code,
                   sms_register_ncode:@"86",
                   sms_register_lthird_id:self.thirdId.length>0 ? self.thirdId:@""
                   };
    }
    return params;
}

@end

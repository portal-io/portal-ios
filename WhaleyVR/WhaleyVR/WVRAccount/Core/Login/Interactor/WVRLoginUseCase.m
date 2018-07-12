//
//  LoginUseCase.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/8/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLoginUseCase.h"
#import "WVRApiHttpLogin.h"
#import "WVRModelUserInfoReformer.h"
#import "WVRErrorViewModel.h"

@interface WVRLoginUseCase ()

@end

@implementation WVRLoginUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpLogin alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        if (![value.content[@"code"] isEqualToString:@"000"]) {
            return value.content[@"msg"];
        }
        self.modelUserInfo = [self.requestApi fetchDataWithReformer:[[WVRModelUserInfoReformer alloc] init]];
        
        if (self.modelUserInfo.username)
            [WVRUserModel sharedInstance].username = self.modelUserInfo.username;
        if (self.modelUserInfo.heliosid || self.modelUserInfo.account_id)
            [WVRUserModel sharedInstance].accountId = self.modelUserInfo.heliosid.length > 0 ? self.modelUserInfo.heliosid : self.modelUserInfo.account_id;
        if (self.modelUserInfo.accesstoken)
            [WVRUserModel sharedInstance].sessionId = self.modelUserInfo.accesstoken;
        if (self.modelUserInfo.expiretime)
            [WVRUserModel sharedInstance].expiration_time = self.modelUserInfo.expiretime;
        if (self.modelUserInfo.refreshtoken)
            [WVRUserModel sharedInstance].refreshtoken = self.modelUserInfo.refreshtoken;
        if (self.modelUserInfo.mobile)
            [WVRUserModel sharedInstance].mobileNumber = self.modelUserInfo.mobile;
        if (self.modelUserInfo.avatar)
            [WVRUserModel sharedInstance].loginAvatar = self.modelUserInfo.avatar;
        [WVRUserModel sharedInstance].isLogined = YES;
        [WVRUserModel sharedInstance].firstLogin = YES;
        return self.modelUserInfo;
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
                   kWVRAPIParamsProgram_account_login_username:self.username,
                   kWVRAPIParamsProgram_account_password:self.password,
                   kWVRAPIParamsProgram_account_from:@"whaleyVR"
                   };
    }
    return params;
}

@end

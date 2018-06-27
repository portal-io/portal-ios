//
//  WVRGetPhoneCodeTokenUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGetPhoneCodeTokenUseCase.h"
#import "WVRApiHttpSmsToken.h"
#import "WVRErrorViewModel.h"

@implementation WVRGetPhoneCodeTokenUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpSmsToken alloc] init];
}

- (RACSignal *)buildUseCase {
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
//        @property (nonatomic) NSString * sms_token;
//        @property (nonatomic) NSString * expiration_time;
//        @property (nonatomic) NSString * now_time;
        NSDictionary * result = value.content[@"data"];
        @strongify(self);
        self.smsToken = result[@"sms_token"];
        return result;
    }] doNext:^(id _Nullable x) {
        
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
                   Params_smsToken_device_id:[WVRUserModel sharedInstance].deviceId
                   };
    }
    return params;
}

@end

//
//  WVRSendPhoneCodeUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSendPhoneCodeUseCase.h"
#import "WVRApiHttpSmsCode.h"
#import "WVRErrorViewModel.h"

@interface WVRSendPhoneCodeUseCase ()

@end
@implementation WVRSendPhoneCodeUseCase

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpSmsCode alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value;
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
                   sms_login_device_id:[WVRUserModel sharedInstance].deviceId,
                   sms_login_mobile:self.mobile,
                   sms_login_ncode:@"86",
                   sms_login_captcha:self.inputCaptcha.length>0? self.inputCaptcha:@"",
                   sms_login_sms_token:self.smsToken
                   };
    }
    return params;
}

@end

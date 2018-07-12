//
//  WVRUpdatePhoneUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUpdatePhoneSMSUseCase.h"
#import "WVRHttpUpdatePhoneSMS.h"
#import "WVRErrorViewModel.h"

@interface WVRUpdatePhoneSMSUseCase ()


@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;


@end

@implementation WVRUpdatePhoneSMSUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRHttpUpdatePhoneSMS alloc] init];
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
                   kHttpParams_sms_changePhoneNum_ncode:@"86",
                   kHttpParams_sms_changePhoneNum_mobile:self.inputPhoneNum,
                   kHttpParams_sms_changePhoneNum_device_id:[WVRUserModel sharedInstance].deviceId,
                   kHttpParams_sms_changePhoneNum_sms_token:self.smsToken,
                   kHttpParams_sms_changePhoneNum_captcha:self.inputCaptcha.length>0? self.inputCaptcha:@""
                   };
    }
    return params;
}
@end

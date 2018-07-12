//
//  WVRApiHttpSmsCode.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpSmsCode.h"
#import "WVRNetworkingAccountService.h"

NSString * const sms_login_device_id = @"device_id";
NSString * const sms_login_sms_token = @"sms_token";
NSString * const sms_login_mobile = @"mobile";
NSString * const sms_login_ncode = @"ncode";
NSString * const sms_login_captcha = @"captcha";

@interface WVRApiHttpSmsCode () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpSmsCode

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/sms/login-code.do";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end

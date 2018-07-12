//
//  WVRApiHttpForgotPasswordSMSCode.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpForgotPasswordSMSCode.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_forgotPWSMSCode_account = @"account";

@interface WVRApiHttpForgotPasswordSMSCode () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpForgotPasswordSMSCode

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"forgot/sms-captcha.do";
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

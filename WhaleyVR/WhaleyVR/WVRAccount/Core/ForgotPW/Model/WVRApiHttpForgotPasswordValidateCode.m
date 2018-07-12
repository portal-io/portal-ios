//
//  WVRApiHttpForgotPasswordValidateCode.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpForgotPasswordValidateCode.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_forgotPW_validate_code = @"code";

@interface WVRApiHttpForgotPasswordValidateCode () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpForgotPasswordValidateCode

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"forgot/validate-captcha.do";
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

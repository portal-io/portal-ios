//
//  WVRApiHttpFinishNamePassword.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpFinishNamePassword.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_finishNamePW_nickname = @"nickname";
NSString * const Params_finishNamePW_password = @"password";
NSString * const Params_finishNamePW_device_id = @"device_id";
NSString * const Params_finishNamePW_accesstoken = @"accesstoken";

@interface WVRApiHttpFinishNamePassword () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpFinishNamePassword

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/user/nickname-and-pwd.do";
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

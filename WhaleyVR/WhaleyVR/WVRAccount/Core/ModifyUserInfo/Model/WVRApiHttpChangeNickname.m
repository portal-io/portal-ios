//
//  WVRApiHttpChangeNickname.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpChangeNickname.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_changeNickName_device_id = @"device_id";
NSString * const Params_changeNickName_accesstoken = @"accesstoken";
NSString * const Params_changeNickName_nickname = @"nickname";

@interface WVRApiHttpChangeNickname () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpChangeNickname

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/user/update-user-nickname.do";
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

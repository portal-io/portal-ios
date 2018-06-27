//
//  WVRApiHttpUnBindThirdParty.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpUnBindThirdParty.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_thirdPartyUNBind_origin = @"origin";
NSString * const Params_thirdPartyUNBind_device_id = @"device_id";
NSString * const Params_thirdPartyUNBind_accesstoken = @"accesstoken";

@interface WVRApiHttpUnBindThirdParty () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpUnBindThirdParty

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"/unify/user/unbind.do";
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

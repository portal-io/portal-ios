//
//  WVRApiHttpThirdPartyLogin.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpThirdPartyLogin.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_thirdPartyLogin_origin = @"origin";
NSString * const Params_thirdPartyLogin_device_id = @"device_id";
NSString * const Params_thirdPartyLogin_open_id = @"open_id";
NSString * const Params_thirdPartyLogin_unionid = @"unionid";
NSString * const Params_thirdPartyLogin_nickname = @"nickname";
NSString * const Params_thirdPartyLogin_avatar = @"avatar";
NSString * const Params_thirdPartyLogin_location = @"location";
NSString * const Params_thirdPartyLogin_from = @"from";
NSString * const Params_thirdPartyLogin_gender = @"gender";

@interface WVRApiHttpThirdPartyLogin () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpThirdPartyLogin

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"/unify/login/third.do";
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

//
//  WVRApiHttpBindThirdPary.m
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpBindThirdPary.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_thirdPartyBind_origin = @"origin";
NSString * const Params_thirdPartyBind_device_id = @"device_id";
NSString * const Params_thirdPartyBind_open_id = @"open_id";
NSString * const Params_thirdPartyBind_unionid = @"unionid";
NSString * const Params_thirdPartyBind_nickname = @"nickname";
NSString * const Params_thirdPartyBind_avatar = @"avatar";
NSString * const Params_thirdPartyBind_location = @"location";
NSString * const Params_thirdPartyBind_accesstoken = @"accesstoken";
NSString * const Params_thirdPartyBind_gender = @"gender";

@interface WVRApiHttpBindThirdPary () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpBindThirdPary

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"/unify/user/bind.do";
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

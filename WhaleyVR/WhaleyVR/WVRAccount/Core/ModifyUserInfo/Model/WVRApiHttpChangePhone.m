//
//  WVRApiHttpChangePhone.m
//  WhaleyVR
//
//  Created by XIN on 21/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpChangePhone.h"
#import "WVRNetworkingAccountService.h"

NSString * const Params_changePhoneNum_device_id = @"device_id";
NSString * const Params_changePhoneNum_accesstoken = @"accesstoken";
NSString * const Params_changePhoneNum_phone = @"phone";
NSString * const Params_changePhoneNum_code = @"code";
NSString * const Params_changePhoneNum_ncode = @"ncode";

@interface WVRApiHttpChangePhone () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpChangePhone

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/user/update-phone.do";
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

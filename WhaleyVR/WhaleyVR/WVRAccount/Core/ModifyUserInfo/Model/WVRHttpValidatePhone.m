//
//  WVRHttpValidatePhone.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpValidatePhone.h"
#import "WVRNetworkingAccountService.h"

@interface WVRHttpValidatePhone ()

@end

@implementation WVRHttpValidatePhone

NSString * const Params_validatePhoneNum_device_id = @"device_id";
NSString * const Params_validatePhoneNum_accesstoken = @"accesstoken";
NSString * const Params_validatePhoneNum_phone = @"phone";
NSString * const Params_validatePhoneNum_ncode = @"ncode";

- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/user/validate-phone.do";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}


@end

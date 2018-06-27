//
//  WVRHttpUpdatePhoneSMS.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpUpdatePhoneSMS.h"
#import "WVRNetworkingAccountService.h"

NSString * const kHttpParams_sms_changePhoneNum_device_id = @"device_id";
NSString * const kHttpParams_sms_changePhoneNum_sms_token = @"sms_token";
NSString * const kHttpParams_sms_changePhoneNum_mobile = @"mobile";
NSString * const kHttpParams_sms_changePhoneNum_ncode = @"ncode";
NSString * const kHttpParams_sms_changePhoneNum_captcha = @"captcha";

@implementation WVRHttpUpdatePhoneSMS
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/sms/update-phone-code.do";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}


@end

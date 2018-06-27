//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpRegister.h"
#import "WVRNetworkingAccountService.h"
#import "WVRModelUserInfo.h"
#import "WVRModelUserInfoReformer.h"
//#import "WVRModelErrorInfo.h"
//#import "WVRModelErrorInfoReformer.h"

NSString * const sms_register_mobile = @"mobile";
NSString * const sms_register_device_id = @"device_id";
NSString * const sms_register_code = @"code";
NSString * const sms_register_from = @"from";
NSString * const sms_register_ncode = @"ncode";
NSString * const sms_register_lthird_id = @"third_id";

@interface WVRApiHttpRegister ()

@end

@implementation WVRApiHttpRegister

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"/unify/login/shortcut.do";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}

//#pragma mark - WVRAPIManagerCallBackDelegate
//
//- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
//    WVRModelUserInfo *modelUserInfo = [self fetchDataWithReformer:[[WVRModelUserInfoReformer alloc] init]];
//    self.successedBlock(modelUserInfo);
//}
//
//- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
//    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
//    self.failedBlock(errorInfo);
//}

@end

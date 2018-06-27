//
//  WVRApiHttpLogin.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpLogin.h"
#import "WVRNetworkingAccountService.h"
#import "WVRModelUserInfo.h"
#import "WVRModelUserInfoReformer.h"


NSString * const kWVRAPIParamsProgram_account_login_username = @"username" ;
NSString * const kWVRAPIParamsProgram_account_password = @"password";
NSString * const kWVRAPIParamsProgram_account_from = @"from";
NSString * const kWVRAPIParamsProgram_account_device_id = @"device_id";
NSString * const kWVRAPIParamsProgram_account_third_id = @"third_id";

@interface WVRApiHttpLogin () <WVRAPIManagerValidator>

@end

@implementation WVRApiHttpLogin

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"unify/login/direct.do";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypePost;
}

//#pragma mark - WVRAPIManagerValidator
//- (BOOL)isCorrectWithCallBackData:(NSDictionary *)data {
//    return [data[@"code"] isEqualToString:@"000"];
//}
//
//- (BOOL)isCorrectWithParamsData:(NSDictionary *)data {
//    return YES;
//}
@end

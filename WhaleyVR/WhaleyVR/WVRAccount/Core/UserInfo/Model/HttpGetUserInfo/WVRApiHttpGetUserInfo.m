//
//  WVRHttpUserInfo.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpGetUserInfo.h"
#import "WVRNetworkingAccountService.h"
#import "WVRHttpUserInfoReformer.h"

NSString * const kHttpParams_userInfo_device_id = @"device_id";
NSString * const kHttpParams_userInfo_accesstoken = @"accesstoken";

static NSString *kActionUrl = @"unify/user/getinfo.do";

@interface WVRApiHttpGetUserInfo() <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpGetUserInfo
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    
    return kActionUrl;
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    id model = [self fetchDataWithReformer:[[WVRHttpUserInfoReformer alloc] init]];
    self.successedBlock(model);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end

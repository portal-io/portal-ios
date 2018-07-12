//
//  WVRHttpMyFollowList.m
//  WVRProgram
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.

// 我的关注列表接口

#import "WVRHttpMyFollowList.h"
#import "WVRNetworkingStoreService.h"

static NSString *kActionUrl = @"newVR-service/appservice/cprel/myfollow";

@implementation WVRHttpMyFollowList

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return kActionUrl;
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingStoreService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

@end

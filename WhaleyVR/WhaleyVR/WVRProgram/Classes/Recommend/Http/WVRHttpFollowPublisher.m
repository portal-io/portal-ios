//
//  WVRHttpFollowPublisher.m
//  WVRProgram
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.

// 关注/取消关注接口

#import "WVRHttpFollowPublisher.h"
#import "WVRNetworkingStoreService.h"

static NSString *kActionUrl = @"newVR-service/appservice/cprel/follow";

@implementation WVRHttpFollowPublisher

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

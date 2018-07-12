//
//  WVRApiHttpDramaDetail.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/10.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧详情

#import "WVRApiHttpDramaDetail.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRApiHttpDramaDetail

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-service/dynaprogram/findByCode";
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

@end

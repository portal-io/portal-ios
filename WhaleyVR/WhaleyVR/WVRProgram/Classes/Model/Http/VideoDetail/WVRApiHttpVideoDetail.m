//
//  WVRHttpVideoDetail.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpVideoDetail.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParams_videoDetail_code = @"code";

NSString * const kHttpParams_videoDetail_uid = @"uid";

static NSString *kActionUrl = @"newVR-service/appservice/program/findByCode";

@implementation WVRApiHttpVideoDetail

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return kActionUrl;
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

@end

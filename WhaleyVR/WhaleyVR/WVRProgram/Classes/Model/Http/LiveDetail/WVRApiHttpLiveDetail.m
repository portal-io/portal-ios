//
//  WVRApiHttpLiveDetail.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpLiveDetail.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParams_liveDetail_code = @"code";
NSString * const kHttpParams_liveDetail_uid = @"uid";

static NSString *kActionUrl = @"newVR-service/appservice/liveProgram/findByCode";

@implementation WVRApiHttpLiveDetail


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

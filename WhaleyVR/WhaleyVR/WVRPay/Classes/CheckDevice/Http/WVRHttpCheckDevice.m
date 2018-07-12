//
//  WVRHttpCheckDevice.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpCheckDevice.h"
#import "WVRNetworkingCMSService.h"

static NSString *kActionUrl = @"newVR-report-service/userPlayDevice/query";

@implementation WVRHttpCheckDevice

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return kActionUrl;
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

@end

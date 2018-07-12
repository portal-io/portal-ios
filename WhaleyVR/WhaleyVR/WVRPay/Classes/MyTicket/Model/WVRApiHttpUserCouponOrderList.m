//
//  WVRApiHttpUserCouponOrderList.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpUserCouponOrderList.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRApiHttpUserCouponOrderList

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/order/userCouponOrderList";
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    return params;
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

@end

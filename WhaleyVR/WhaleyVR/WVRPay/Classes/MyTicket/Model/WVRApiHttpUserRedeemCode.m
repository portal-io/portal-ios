//
//  WVRApiHttpUserRedeemCode.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpUserRedeemCode.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRApiHttpUserRedeemCode
#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/redeemCode/listUserUnRedeemed";
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    return params;
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

@end

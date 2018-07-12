//
//  WVRHttpCurrencyBalance.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币余额接口

#import "WVRHttpCurrencyBalance.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRHttpCurrencyBalance

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/whaleyCurrency/userAmount";
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

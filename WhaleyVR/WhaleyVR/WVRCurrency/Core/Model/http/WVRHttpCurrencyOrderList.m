//
//  WVRHttpCurrencyOrderList.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 用户鲸币订单列表接口

#import "WVRHttpCurrencyOrderList.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRHttpCurrencyOrderList

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/order/userWhaleyCurrencyOrderList";
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

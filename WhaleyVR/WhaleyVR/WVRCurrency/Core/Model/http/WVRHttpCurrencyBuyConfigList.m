//
//  WVRHttpCurrencyBuyConfigList.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpCurrencyBuyConfigList.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRHttpCurrencyBuyConfigList
#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/whaleyCurrency/buyConfigList";
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

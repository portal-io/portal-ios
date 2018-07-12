//
//  WVRHttpApiAppInPurchaseResult.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpApiAppInPurchaseResult.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParam_AppInPurchaseResult_OrderNo = @"orderNo";
NSString * const kHttpParam_AppInPurchaseResult_iosTradeNo = @"iosTradeNo";
NSString * const kHttpParam_AppInPurchaseResult_phoneNum = @"phoneNum";


@implementation WVRHttpApiAppInPurchaseResult

- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    return params;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/order/iosPayFinishBack";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

@end

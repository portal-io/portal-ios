//
//  WVRApiHttpExchangeRedeemCode.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpExchangeRedeemCode.h"
#import "WVRNetworkingCMSService.h"

@interface WVRApiHttpExchangeRedeemCode ()

@end


@implementation WVRApiHttpExchangeRedeemCode

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/redeemCode/userDoRedeem";
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

//
//  WVRHttpCurrencyCost.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 鲸币消费接口

#import "WVRHttpCurrencyCost.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParam_currencyCost_uid = @"uid";
NSString * const kHttpParam_currencyCost_nickName = @"nickName";
NSString * const kHttpParam_currencyCost_userHeadUrl = @"userHeadUrl";
NSString * const kHttpParam_currencyCost_buyType = @"buyType";
NSString * const kHttpParam_currencyCost_buyParams = @"buyParams";
NSString * const kHttpParam_currencyCost_bizParams = @"bizParams";
NSString * const kHttpParam_currencyCost_sign = @"sign";

@implementation WVRHttpCurrencyCost

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/whaleyCurrency/userCost";
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

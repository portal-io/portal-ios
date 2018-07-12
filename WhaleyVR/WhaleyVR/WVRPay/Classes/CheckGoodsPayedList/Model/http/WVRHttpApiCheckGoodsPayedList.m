//
//  WVRHttpApiCheckGoodsPayedList.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpApiCheckGoodsPayedList.h"
#import "WVRNetworkingCMSService.h"

@interface WVRHttpApiCheckGoodsPayedList ()

@end

@implementation WVRHttpApiCheckGoodsPayedList

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/order/goodsPayedList";
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

@end

//
//  WVRApiHttpMyTicket.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpMyTicket.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParam_myTicket_uid = @"uid";

NSString * const kHttpParam_myTicket_page = @"page";

NSString * const kHttpParam_myTicket_size = @"size";

NSString * const kHttpParam_myTicket_sign = @"sign";

@interface WVRApiHttpMyTicket ()

@end


@implementation WVRApiHttpMyTicket

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/userCoupon/couponList";
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


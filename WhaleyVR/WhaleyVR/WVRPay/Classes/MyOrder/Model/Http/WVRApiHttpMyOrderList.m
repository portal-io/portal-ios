//
//  WVRApiHttpMyOrderList.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpMyOrderList.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParam_myOrder_uid = @"uid";

NSString * const kHttpParam_myOrder_page = @"page";

NSString * const kHttpParam_myOrder_size = @"size";

NSString * const kHttpParam_myOrder_sign = @"sign";

@implementation WVRApiHttpMyOrderList
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
    
    return @"newVR-report-service/order/orderList";
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

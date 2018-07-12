//
//  WVRApiHttpCheckPay.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpCheckPay.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParam_checkPay_uid = @"uid";
NSString * const kHttpParam_checkPay_goodsNo = @"goodsNo";
NSString * const kHttpParam_checkPay_goodsType = @"goodsType";
NSString * const kHttpParam_checkPay_sign = @"sign";

@implementation WVRApiHttpCheckPay

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/order/goodsPayed";
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

//
//  WVRApiHttpCreateOrder.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpCreateOrder.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRHttpCreateOrderReformer.h"
#import "WVROrderModel.h"

NSString * const kHttpParam_CreateOrder_uid = @"uid";
NSString * const kHttpParam_CreateOrder_goodsNo = @"goodsNo";
NSString * const kHttpParam_CreateOrder_goodsType = @"goodsType";
NSString * const kHttpParam_CreateOrder_price = @"price";
NSString * const kHttpParam_CreateOrder_payMethod = @"payMethod";
NSString * const kHttpParam_CreateOrder_sign = @"sign";

@interface WVRApiHttpCreateOrder () <WVRAPIManager, WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpCreateOrder

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-report-service/order/createNormalOrder";
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

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    WVROrderModel * orderModel = [self fetchDataWithReformer:[WVRHttpCreateOrderReformer new]];
    self.successedBlock(orderModel);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(errorInfo);
}

@end

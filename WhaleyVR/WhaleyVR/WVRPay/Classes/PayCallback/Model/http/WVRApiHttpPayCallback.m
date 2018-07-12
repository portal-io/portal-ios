//
//  WVRApiHttpPayCallback.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpPayCallback.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"

NSString * const kHttpParam_PayCallback_orderNo = @"orderNo";
NSString * const kHttpParam_PayCallback_payMethod = @"payMethod";
NSString * const kHttpParam_PayCallback_sign = @"sign"; //MD5(orderNo+payMethod+key)

@interface WVRApiHttpPayCallback () <WVRAPIManager, WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpPayCallback

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"/newVR-report-service/order/appPayFinishBack";
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
    //    NSArray* data = [self fetchDataWithReformer:[[WVRHistoryModelReformer alloc] init]];
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(errorInfo);
}

@end

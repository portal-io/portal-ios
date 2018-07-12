//
//  WVRAPIHTTPMyFollow.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 我的关注 接口

#import "WVRAPIHTTPMyFollow.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const attention_myfollow_uid  = @"userId";
NSString * const attention_myfollow_size = @"size";
NSString * const attention_myfollow_page = @"page";

@interface WVRAPIHTTPMyFollow() <WVRAPIManager, WVRAPIManagerCallBackDelegate>

@end


@implementation WVRAPIHTTPMyFollow

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"/newVR-service/appservice/userHistory/add";
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

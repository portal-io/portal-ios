//
//  WVRApiHttpBIReport.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpBIReport.h"
#import "WVRNetworkingBIService.h"

NSString * const kWVRAPIParamsBI_logs = @"logs";
NSString * const kWVRAPIParamsBI_ts = @"ts";
NSString * const kWVRAPIParamsBI_md5 = @"md5";
NSString * const kWVRAPIParamsBI_checkVersion = @"checkVersion";

@interface WVRApiHttpBIReport () <WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpBIReport

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName
{
    return @"vrapplog";
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingBIService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypePost;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    // Default MD5 value
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    return resultParams;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end

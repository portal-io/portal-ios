//
//  WVRApiHttpAutoArrange.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpAutoArrange.h"
#import "WVRNetworkingCMSService.h"

NSString * const kWVRAPIParams_AutoArrange_Code = @"code";
NSInteger const kApiHttpPageSize = 10;

@interface WVRApiHttpAutoArrange() <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpAutoArrange
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    return @"newVR-service/appservice/arrangeTree/elements";
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary *pageParams = [NSMutableDictionary dictionaryWithDictionary:params];
    pageParams[@"page"] = @(self.nextPageNumber);
    pageParams[@"size"] = @(kApiHttpPageSize);
    return pageParams;
}

#pragma mark - WVRAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}
@end

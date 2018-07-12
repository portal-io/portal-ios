//
//  WVRApiHttpDanmu.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpFootballList.h"
#import "WVRNetworkingCMSService.h"
#import "NSDictionary+WVRNetworkingMethods.h"
#import "WVRHttpFootballListReformer.h"

@interface WVRHttpFootballList() <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRHttpFootballList
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
    return @"/sport/Data/WelcomeData";
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {

    return params;
}

#pragma mark - WVRAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    id model = [self fetchDataWithReformer:[[WVRHttpFootballListReformer alloc] init]];
    self.successedBlock(model);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}


@end

//
//  WVRHttpApiVideoDetailInfo.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpApiVideoDetailInfo.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRHttpApiVideoDetailInfo

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    return nil;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return self.urlMethodName;
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypePost;
}

@end

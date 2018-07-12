//
//  WVRHttpLaunchImageInfo.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 启动广告图

#import "WVRHttpLaunchImageInfo.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRHttpLaunchImageInfo

// https://vrtest-api.aginomoto.com/newVR-service/appservice/recommendPage/findPageByCode/WelcomePage/ios/3.3.0?v=1

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    NSString *ver = [[kAppVersion componentsSeparatedByString:@"_"] firstObject];
    
    return [NSString stringWithFormat:@"newVR-service/appservice/recommendPage/findPageByCode/WelcomePage/ios/%@?v=1", ver];
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

@end

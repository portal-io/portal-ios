//
//  WVRHttpUploadViewCount.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpUploadViewCount.h"
#import "WVRNetworkingCMSService.h"

@implementation WVRHttpUploadViewCount


#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"newVR-service/appservice/stat/updateBySrcCode";
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

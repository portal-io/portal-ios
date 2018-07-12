//
//  WVRHttpFeedBack.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpFeedBack.h"
#import "WVRNetworkingStoreService.h"

static NSString *kActionUrl = @"client/feedback";

@implementation WVRHttpFeedBack

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return kActionUrl;
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingStoreService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

@end


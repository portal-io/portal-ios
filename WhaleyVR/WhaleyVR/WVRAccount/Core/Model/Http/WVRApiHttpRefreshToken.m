//
//  WVRApiHttpRefreshToken.m
//  WhaleyVR
//
//  Created by XIN on 21/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpRefreshToken.h"
#import "WVRNetworkingAccountService.h"

NSString * const refreshToken_refreshtoken = @"refreshtoken";
NSString * const refreshToken_device_id = @"device_id";
NSString * const refreshToken_accesstoken = @"accesstoken";

@interface WVRApiHttpRefreshToken () <WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpRefreshToken

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    
    return @"unify/login/refresh-token.do";
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingAccountService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    
    self.failedBlock(response);
}

@end

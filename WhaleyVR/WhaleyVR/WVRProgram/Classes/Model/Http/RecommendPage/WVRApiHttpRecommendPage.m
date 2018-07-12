//
//  WVRApiHttpRecommendPage.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRApiHttpRecommendPage.h"
#import "WVRNetworkingCMSService.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

//NSString * const kHttpParams_HaveTV = @"v";

NSString * const kHttpParams_RecommendPage_code = @"code";

@interface WVRApiHttpRecommendPage () <WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpRecommendPage

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - WVRAPIManager

#pragma mark - WVRAPIManager
- (NSString *)methodName {
    
    NSDictionary * params = [self.dataSource paramsForAPI:self];
    NSString * url = [NSString stringWithFormat:@"newVR-service/appservice/recommendPage/findPageByCode/%@/%@/%@", params[kHttpParams_RecommendPage_code], kAPI_PLATFORM, [WVRUserModel kAPI_VERSION]];
    
    return url;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    NSDictionary * dic = @{ @"v" : @"1", @"containArrange":@(YES) };
    return dic;
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end

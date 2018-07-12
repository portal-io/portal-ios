//
//  WVRApiHttpRecommendPageElements.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/17.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRApiHttpRecommendPageElements.h"
#import "WVRNetworkingCMSService.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

NSString * const kHttpParams_RecommendPageElements_code = @"code";
NSString * const kHttpParams_RecommendPageElements_subCode = @"subCode";
NSString * const kHttpParams_RecommendPageElements_pageNum = @"page";
NSString * const kHttpParams_RecommendPageElements_pageSize = @"size";

@implementation WVRApiHttpRecommendPageElements
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - WVRAPIManager

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    NSDictionary * params = [self.dataSource paramsForAPI:self];
    NSString * url = [NSString stringWithFormat:@"newVR-service/appservice/recommendPage/findElementsByCode/%@/%@/%@/%@/%@/%@",params[kHttpParams_RecommendPageElements_code],params[kHttpParams_RecommendPageElements_subCode],kAPI_PLATFORM,[WVRUserModel kAPI_VERSION],params[kHttpParams_RecommendPageElements_pageNum],params[kHttpParams_RecommendPageElements_pageSize]];
    return url;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSDictionary * dic = @{@"v" : @"1",@"containArrange":@(YES)};
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

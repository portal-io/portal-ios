//
//  WVRHttpRPageElementsByCode.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpRPageElements.h"
#import "WVRNetworkingCMSService.h"
#import "WVRHttpRPageElementsReformer.h"

#define kAppTypeRecommendPage  (@"ios")
#define kBusiVersionRecommendPage (@"V.1.2")

NSString * const kHttpParams_RPageElements_code = @"code";
NSString * const kHttpParams_RPageElements_subCode = @"subCode";
NSString * const kHttpParams_RPageElements_pageSize = @"pageSize";
NSString * const kHttpParams_RPageElements_pageNum = @"pageNum";

@interface WVRHttpRPageElements ()

@end


@implementation WVRHttpRPageElements

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    //    NSString * url = [NSString stringWithFormat:@"room/danmaku?%@",[self getParamsStr:self.bodyParams]];
    NSDictionary * params = [self.dataSource paramsForAPI:self];
    NSString * url = [NSString stringWithFormat:@"newVR-service/appservice/recommendPage/findElementsByCode/%@/%@/%@/%@/%@/%@",params[kHttpParams_RPageElements_code],params[kHttpParams_RPageElements_subCode],kAppTypeRecommendPage,[WVRUserModel kAPI_VERSION],params[kHttpParams_RPageElements_pageNum],params[kHttpParams_RPageElements_pageSize]];

    return url;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSDictionary * dic = @{@"v" : @"1",
                           @"containArrange" : @(YES),};
    return dic;
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypeGet;
}

//#pragma mark - WVRAPIManagerCallBackDelegate
//- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
//    self.successedBlock(response.responseData);
//    id result = [self fetchDataWithReformer:[[WVRHttpRPageElementsReformer alloc] init]];
//    self.successedBlock(result);
//}
//
//- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
//    //    self.failedBlock(response);
//    self.failedBlock(response.responseData);
//}

@end

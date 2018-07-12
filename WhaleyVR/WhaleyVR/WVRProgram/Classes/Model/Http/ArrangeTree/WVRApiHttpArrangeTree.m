//
//  WVRApiHttpArrangeTree.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpArrangeTree.h"
#import "WVRNetworkingCMSService.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

NSString * const kHttpParams_ArrangeTree_code = @"code";

@implementation WVRApiHttpArrangeTree
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
    NSString * url = [NSString stringWithFormat:@"newVR-service/appservice/arrangeTree/findTreeNodeCode/%@",params[kHttpParams_ArrangeTree_code]];
    return url;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    return @{@"v":@"1",
             @"containArrange":@(YES)};
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

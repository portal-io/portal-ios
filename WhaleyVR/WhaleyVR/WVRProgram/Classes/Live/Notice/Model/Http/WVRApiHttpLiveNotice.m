//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpLiveNotice.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRHistoryModelReformer.h"
#import "WVRApiSignatureGenerator.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

NSString * const kHttpParams_liveOrder_uid = @"uid";
NSString * const kHttpParams_liveOrder_token = @"token";
NSString * const kHttpParams_liveOrder_device_id = @"device_id";
NSString * const kHttpParams_liveOrder_code = @"code";
NSString * const kHttpParams_liveOrder_action = @"action";

@interface WVRApiHttpLiveNotice () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpLiveNotice

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    NSDictionary * params = [self.dataSource paramsForAPI:self];
    NSString * url = [NSString stringWithFormat:@"newVR-service/appservice/liveorder/%@",params[kHttpParams_liveOrder_action]];
    return url;
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

-(NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary * curParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [curParams removeObjectForKey:kHttpParams_liveOrder_action];
    return curParams;
}

- (WVRAPIManagerRequestType)requestType {
    NSDictionary * params = [self.dataSource paramsForAPI:self];
    NSString * action = params[kHttpParams_liveOrder_action];
    if ([action isEqualToString:@"list"]) {
        return WVRAPIManagerRequestTypeGet;
    }
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    id data = [self fetchDataWithReformer:[[WVRHistoryModelReformer alloc] init]];
    self.successedBlock(data);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
//    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(response);
}

@end

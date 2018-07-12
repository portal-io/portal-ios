//
//  WVRHttpAppEnter.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/22.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpAppEnter2.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParams_enter2_content = @"content";

NSString * const cKey2 = @"e0dfa6491c3e4976b96feb3ad93112dc06e219b08f7f49148c2cf78ea451a3e1468dcd62bdcd435d9ce290290c8bdba68ce17124c6f94ff0a53bbf46110d26ca";
static NSString *kActionUrl = @"newVR-report-service/ad/app/checklog";

@implementation WVRHttpAppEnter2

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        //                self.validator = self;
        //                self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    return kActionUrl;
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    return resultParams;
}

#pragma mark - WVRAPIManagerValidator
- (BOOL)isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

#pragma mark - WVRAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end


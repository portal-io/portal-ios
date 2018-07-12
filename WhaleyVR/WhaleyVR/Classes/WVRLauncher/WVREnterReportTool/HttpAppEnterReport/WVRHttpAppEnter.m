//
//  WVRHttpAppEnter.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/22.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpAppEnter.h"
#import "WVRNetworkingCMSService.h"


NSString * const kHttpParams_enter_content = @"content";

NSString * const cKey = @"5d40190e25c04495bb920abe34d16a98caeb903a56e14b1d8c578f6ae8834c77750d76d4c21545e99abb952fb13603e7c8620099e2e74d3aa6863a4fe091d03f";
static NSString *kActionUrl = @"newVR-report-service/ad/app/firstClick";

@interface WVRHttpAppEnter ()<WVRAPIManagerValidator,WVRAPIManagerCallBackDelegate>

@end
@implementation WVRHttpAppEnter
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


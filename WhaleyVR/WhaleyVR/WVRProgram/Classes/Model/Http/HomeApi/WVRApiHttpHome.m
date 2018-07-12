//
//  WVRApiHttpHome.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpHome.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelRecommendReformer.h"
#import "WVRModelRecommend.h"

@interface WVRApiHttpHome () <WVRAPIManagerValidator, WVRAPIManagerCallBackDelegate>

@end
@implementation WVRApiHttpHome

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    return @"newVR-service/appservice/recommendPage/findPageByCode/recommend_newhome/ios/1.0";
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
    WVRModelRecommend *modelRecommend = [self fetchDataWithReformer:[[WVRModelRecommendReformer alloc] init]];
    self.successedBlock(modelRecommend);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end

//
//  WVRHttpLiveList.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRApiHttpLiveList.h"
#import "WVRNetworkingCMSService.h"

NSString * const kHttpParams_liveList_liveStatus = @"liveStatus";

@implementation WVRApiHttpLiveList

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        //        self.validator = self;
        //        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName
{
    return @"newVR-service/appservice/liveProgram/findByCriteria";
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

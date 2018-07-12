//
//  WVRApiHttpHome.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpMyReservation.h"
#import "WVRNetworkingCMSService.h"
#import "WVRAllChannelReformer.h"
#import "WVRHttpRecommendPageDetailModel.h"

NSString * const kHttpParams_myReserveList_uid = @"uid";
NSString * const kHttpParams_myReserveList_token = @"token";
NSString * const kHttpParams_myReserveList_device_id = @"device_id";



@interface WVRApiHttpMyReservation () <WVRAPIManagerValidator,WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpMyReservation

- (void)dealloc
{
    DDLogInfo(@"");
}

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
    return @"newVR-service/appservice/liveorder/listOrderedByUser";
}

- (NSString *)serviceType
{
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType
{
    return WVRAPIManagerRequestTypeGet;
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
    NSArray *data = [self fetchDataWithReformer:[[WVRAllChannelReformer alloc] init]];
    self.successedBlock(data);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end

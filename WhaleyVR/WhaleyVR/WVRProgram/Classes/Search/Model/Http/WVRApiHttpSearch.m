//
//  WVRApiHttpSearch.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpSearch.h"
#import "WVRNetworkingCMSService.h"
#import "WVRAllChannelReformer.h"
#import "WVRHttpRecommendPageDetailModel.h"

NSString * const kHttpParams_search_keyWord = @"keyWord";
NSString * const kHttpParams_search_type = @"type";
static NSString *kActionUrl = @"newVR-service/appservice/search/bytitle";


@interface WVRApiHttpSearch () <WVRAPIManagerValidator,WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpSearch

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

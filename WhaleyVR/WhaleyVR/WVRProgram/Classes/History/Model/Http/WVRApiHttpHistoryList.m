//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpHistoryList.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRHistoryModelReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const history_list_uid = @"uid";
NSString * const history_list_device_id = @"devideId";
NSString * const history_list_page = @"page";
NSString * const history_list_size = @"size";
NSString * const history_list_dataSource = @"dataSource";
NSString * const history_list_sign = @"sign";

@interface WVRApiHttpHistoryList () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpHistoryList

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
    return @"/newVR-service/appservice/userHistory/pageSearch";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

-(NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary * curParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSLog(@"uid:%@",curParams[history_list_uid]);
    NSString * signStr = [[[[[curParams[history_list_uid]? curParams[history_list_uid]:@"" stringByAppendingString:curParams[history_list_device_id]? curParams[history_list_device_id]:@""] stringByAppendingString:curParams[history_list_page]] stringByAppendingString:curParams[history_list_size]]  stringByAppendingString:curParams[history_list_dataSource]] stringByAppendingString:[WVRUserModel CMCHistory_sign_secret]];
    curParams[history_list_sign] = [WVRApiSignatureGenerator signPostWithApiParamsValues:signStr privateKey:@"" publicKey:[WVRUserModel CMCHistory_sign_secret]];
    NSLog(@"signStr:%@",signStr);
    return curParams;
}

- (WVRAPIManagerRequestType)requestType {
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

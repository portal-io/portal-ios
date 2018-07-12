//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpHistoryDels.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const history_dels_dataSource = @"dataSource";
NSString * const history_dels_uid = @"uid";
NSString * const history_dels_deviceId = @"devideId";
NSString * const history_dels_delIds = @"delIds";
NSString * const history_dels_sign = @"sign";

@interface WVRApiHttpHistoryDels () <WVRAPIManagerCallBackDelegate>

@end


@implementation WVRApiHttpHistoryDels

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
    return @"/newVR-service/appservice/userHistory/delByIds";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

-(NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary * curParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSLog(@"uid:%@",curParams[history_dels_uid]);
    NSString * signStr = [[[[curParams[history_dels_dataSource] stringByAppendingString:curParams[history_dels_uid]? curParams[history_dels_uid]:@""] stringByAppendingString:curParams[history_dels_deviceId]? curParams[history_dels_deviceId]:@"" ] stringByAppendingString:curParams[history_dels_delIds]] stringByAppendingString:[WVRUserModel CMCHistory_sign_secret]];
    curParams[history_dels_sign] = [WVRApiSignatureGenerator signPostWithApiParamsValues:signStr privateKey:@"" publicKey:[WVRUserModel CMCHistory_sign_secret]];
    return curParams;
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
//    id data = [self fetchDataWithReformer:[[WVRHistoryModelReformer alloc] init]];
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(errorInfo);
}

@end

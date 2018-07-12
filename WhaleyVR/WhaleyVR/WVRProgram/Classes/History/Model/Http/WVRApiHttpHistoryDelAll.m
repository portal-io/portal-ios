//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpHistoryDelAll.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const history_delAll_uid = @"uid";
NSString * const history_delAll_deviceId = @"devideId";
NSString * const history_delAll_dataSource = @"dataSource";
NSString * const history_delAll_sign = @"sign" ;

@interface WVRApiHttpHistoryDelAll () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpHistoryDelAll

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
    return @"/newVR-service/appservice/userHistory/del";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

-(NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary * curParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * signStr = [[[curParams[history_delAll_uid]? curParams[history_delAll_uid]:@"" stringByAppendingString:curParams[history_delAll_deviceId]? curParams[history_delAll_deviceId]:@""]  stringByAppendingString:curParams[history_delAll_dataSource]] stringByAppendingString:[WVRUserModel CMCHistory_sign_secret]];
    curParams[history_delAll_sign] = [WVRApiSignatureGenerator signPostWithApiParamsValues:signStr privateKey:@"" publicKey:[WVRUserModel CMCHistory_sign_secret]];
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
//    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(response);
}

@end

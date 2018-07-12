//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpHistoryRecord.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const history_record_uid = @"uid";
NSString * const history_record_device_id = @"devideId";
NSString * const history_record_playTime = @"playTime";
NSString * const history_record_playStatus = @"playStatus";
NSString * const history_record_programCode = @"programCode";
NSString * const history_record_programType = @"programType";
NSString * const history_record_dataSource = @"dataSource";
NSString * const history_record_totalPlayTime = @"totalPlayTime";
NSString * const history_record_sign = @"sign";

@interface WVRApiHttpHistoryRecord () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpHistoryRecord

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName {
    return @"/newVR-service/appservice/userHistory/add";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

-(NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary * curParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSLog(@"uid:%@",curParams[history_record_uid]);
    if (curParams[history_record_playTime]||curParams[history_record_playStatus]||curParams[history_record_programCode]||curParams[history_record_programType]||curParams[history_record_totalPlayTime]) {
        NSString * signStr = [[[[[[[[curParams[history_record_uid]? curParams[history_record_uid]:@"" stringByAppendingString:curParams[history_record_device_id]? curParams[history_record_device_id]:@""] stringByAppendingString:curParams[history_record_playTime]] stringByAppendingString:curParams[history_record_playStatus]] stringByAppendingString:curParams[history_record_programCode]] stringByAppendingString:curParams[history_record_programType]] stringByAppendingString:curParams[history_record_dataSource]] stringByAppendingString:curParams[history_record_totalPlayTime]] stringByAppendingString:[WVRUserModel CMCHistory_sign_secret]];
        curParams[history_record_sign] = [WVRApiSignatureGenerator signPostWithApiParamsValues:signStr privateKey:@"" publicKey:[WVRUserModel CMCHistory_sign_secret]];
        NSLog(@"signStr:%@",signStr);
    }
    
    return curParams;
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypePost;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
//    NSArray* data = [self fetchDataWithReformer:[[WVRHistoryModelReformer alloc] init]];
    self.successedBlock(response);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(errorInfo);
}

@end

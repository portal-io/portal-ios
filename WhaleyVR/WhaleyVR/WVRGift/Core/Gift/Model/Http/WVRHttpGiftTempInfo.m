//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRHttpGiftTempInfo.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

NSString * const kHttpParams_giftTempInfo_Code = @"giftTempCode";
NSString * const kHttpParams_giftTempInfo_pageNum = @"pageNum";
NSString * const kHttpParams_giftTempInfo_pageSize = @"pageSize";



@interface WVRHttpGiftTempInfo () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRHttpGiftTempInfo

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager

- (NSString *)methodName
{
//    NSDictionary * params = [self.dataSource paramsForAPI:self];
//    NSString * url = [NSString stringWithFormat:@"%@/%@/%@",params[kHttpParams_giftTempInfo_Code],params[kHttpParams_giftTempInfo_pageNum],params[kHttpParams_giftTempInfo_pageSize]];
    return @"vr-gift/gift/giftTempInfo";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    return WVRAPIManagerRequestTypeGet;
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

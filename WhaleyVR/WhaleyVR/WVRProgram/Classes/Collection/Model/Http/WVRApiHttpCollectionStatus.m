//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpCollectionStatus.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

NSString * const kHttpParams_collectionStatus_userLoginId = @"userLoginId";
NSString * const kHttpParams_collectionStatus_programCode = @"programCode";



@interface WVRApiHttpCollectionStatus () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpCollectionStatus

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
    NSDictionary * params = [self.dataSource paramsForAPI:self];
    NSString * url = [NSString stringWithFormat:@"newVR-service/userFavorite/sec/one/%@/%@",params[kHttpParams_collectionStatus_userLoginId],params[kHttpParams_collectionStatus_programCode]];
    return url;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSDictionary * dic = @{};
    return dic;
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

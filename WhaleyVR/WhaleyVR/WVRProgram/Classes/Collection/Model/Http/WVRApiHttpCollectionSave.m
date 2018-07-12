//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpCollectionSave.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const kHttpParams_collectionSave_userLoginId = @"userLoginId";
NSString * const kHttpParams_collectionSave_userName = @"userName";
NSString * const kHttpParams_collectionSave_programCode = @"programCode";
NSString * const kHttpParams_collectionSave_programName = @"programName";
NSString * const kHttpParams_collectionSave_videoType = @"videoType";

NSString * const kHttpParams_collectionSave_programType = @"programType";
NSString * const kHttpParams_collectionSave_status = @"status";
NSString * const kHttpParams_collectionSave_duration = @"duration";
NSString * const kHttpParams_collectionSave_picUrl = @"picUrl";


@interface WVRApiHttpCollectionSave () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpCollectionSave

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
    return @"/newVR-service/userFavorite/pri/save";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
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
//    WVRModelErrorInfo *errorInfo = [self fetchDataWithReformer: [[WVRModelErrorInfoReformer alloc] init]];
    self.failedBlock(response);
}

@end

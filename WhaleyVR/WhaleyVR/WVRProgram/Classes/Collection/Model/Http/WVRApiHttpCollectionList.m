//
//  WVRApiHttpRegister.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRApiHttpCollectionList.h"
#import "WVRNetworkingCMSService.h"
#import "WVRModelErrorInfo.h"
#import "WVRModelErrorInfoReformer.h"
#import "WVRHistoryModelReformer.h"
#import "WVRApiSignatureGenerator.h"

NSString * const kHttpParams_collectionGet_userLoginId = @"userLoginId";
NSString * const kHttpParams_collectionGet_page = @"page";
NSString * const kHttpParams_collectionGet_size = @"size";

@interface WVRApiHttpCollectionList () <WVRAPIManagerCallBackDelegate>

@end

@implementation WVRApiHttpCollectionList

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
    return @"/newVR-service/userFavorite/sec/findByCriteria";
}

- (NSString *)serviceType {
    return NSStringFromClass([WVRNetworkingCMSService class]);
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

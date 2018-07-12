//
//  WVRLiveDetailUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveDetailUseCase.h"
#import "WVRApiHttpLiveDetail.h"
#import "WVRLiveDetailReformer.h"
#import "WVRLiveItemModel.h"
#import "WVRErrorViewModel.h"

@implementation WVRLiveDetailUseCase

#pragma mark - WVRUseCaseProtocol

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpLiveDetail alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRLiveItemModel* model = [self.requestApi fetchDataWithReformer:[[WVRLiveDetailReformer alloc] init]];
        return model;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)buildErrorCase {
    
    return [[self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kHttpParams_liveDetail_code] = self.code;
    dict[kHttpParams_liveDetail_uid] = [WVRUserModel sharedInstance].accountId;
    
    return dict;
}

@end

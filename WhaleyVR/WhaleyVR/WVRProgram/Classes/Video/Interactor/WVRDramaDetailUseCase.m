//
//  WVRDramaDetailUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/9.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧详情UseCase

#import "WVRDramaDetailUseCase.h"
#import "WVRApiHttpDramaDetail.h"
#import "WVRErrorViewModel.h"
#import "WVRInteractiveDramaModel.h"

@interface WVRDramaDetailUseCase ()

@end


@implementation WVRDramaDetailUseCase

#pragma mark - WVRUseCaseProtocol

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpDramaDetail alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        @strongify(self);
        WVRInteractiveDramaModel *model = [self.requestApi fetchDataWithReformer:[[WVRDramaDetailDataReformer alloc] init]];
        model.originString = value.contentString;
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
    
    return @{ @"code": self.code,
              @"uid": [WVRUserModel sharedInstance].accountId
              };
}

@end

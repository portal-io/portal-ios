//
//  WVRVideoDetailUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 全景视频/华数3D电影详情接口

#import "WVRVideoDetailUseCase.h"
#import "WVRApiHttpVideoDetail.h"
#import "WVRErrorViewModel.h"
#import "WVRVideoDetailVCModel.h"

@interface WVRVideoDetailUseCase ()

@property (nonatomic, strong) WVRVideoDetailVCModel *detailModel;

@end


@implementation WVRVideoDetailUseCase

#pragma mark - WVRUseCaseProtocol

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpVideoDetail alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        self.detailModel = [self.requestApi fetchDataWithReformer:[[WVRVideoDetailDataReformer alloc] init]];
        return self.detailModel;
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

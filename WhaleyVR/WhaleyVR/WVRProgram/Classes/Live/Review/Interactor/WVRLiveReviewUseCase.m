//
//  WVRHomeTopBarListUseCase.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRLiveReviewUseCase.h"
#import "WVRApiHttpRecommendPageElements.h"
#import "WVRErrorViewModel.h"
#import "WVRRecommendPageElementsReformer.h"
#import "WVRSectionModel.h"

@interface WVRLiveReviewUseCase ()


@end


@implementation WVRLiveReviewUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpRecommendPageElements alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
      WVRSectionModel * result = [self.requestApi fetchDataWithReformer:[[WVRRecommendPageElementsReformer alloc] init]];
        return result;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        return YES;
    }] doNext:^(id  _Nullable x) {
        
    }];
    
}

- (RACSignal *)buildErrorCase {
    return [self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }];
}

// WVRUseCaseProtocol delegate
- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        params = @{
                   kHttpParams_RecommendPageElements_code:self.code,
                   kHttpParams_RecommendPageElements_subCode:self.subCode,
                   kHttpParams_RecommendPageElements_pageNum:@(self.pageNum),
                   kHttpParams_RecommendPageElements_pageSize:@(self.pageSize)
                   };
    }
    return params;
}

@end

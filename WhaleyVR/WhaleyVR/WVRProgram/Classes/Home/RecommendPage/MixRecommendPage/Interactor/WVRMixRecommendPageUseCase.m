//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMixRecommendPageUseCase.h"
#import "WVRApiHttpRecommendPage.h"
#import "WVRRecommendPageReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRSectionModel.h"
#import "WVRRecommendPageModel.h"

@implementation WVRMixRecommendPageUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpRecommendPage alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRRecommendPageModel* result = [self.requestApi fetchDataWithReformer:[[WVRRecommendPageReformer alloc] init]];
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


- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        params = @{
                   kHttpParams_RecommendPage_code:self.code,
                   };
    }
    return params;
}
@end

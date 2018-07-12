//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAutoArrangeUseCase.h"
#import "WVRApiHttpArrangeElements.h"
#import "WVRArrangeElementsReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRSectionModel.h"

@implementation WVRAutoArrangeUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpArrangeElements alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRSectionModel* result = [self.requestApi fetchDataWithReformer:[[WVRArrangeElementsReformer alloc] init]];
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
                   kHttpParams_ArrangeElements_code:self.code,
                   kHttpParams_ArrangeElements_pageNum:@(self.pageNum),
                   kHttpParams_ArrangeElements_pageSize:@(self.pageSize),
                   };
    }
    return params;
}
@end

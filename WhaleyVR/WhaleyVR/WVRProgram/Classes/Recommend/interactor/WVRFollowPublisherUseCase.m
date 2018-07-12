//
//  WVRFollowPublisherUseCase.m
//  WVRProgram
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRFollowPublisherUseCase.h"
#import "WVRHttpFollowPublisher.h"
#import "WVRErrorViewModel.h"

@implementation WVRFollowPublisherUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpFollowPublisher alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        @strongify(self);
        NSArray *result = [self dealWithResponse:value];
        
        return result;
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
    
    return [NSDictionary dictionary];
}

- (NSArray *)dealWithResponse:(WVRNetworkingResponse *)response {
    
    //    NSDictionary *dic = response.content;
    
    NSArray *result = nil;
    
    return result;
}

@end

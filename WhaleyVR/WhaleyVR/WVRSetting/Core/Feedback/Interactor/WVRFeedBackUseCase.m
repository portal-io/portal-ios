//
//  WVRFeedBackUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFeedBackUseCase.h"
#import "WVRHttpFeedBack.h"
#import "WVRErrorViewModel.h"


@implementation WVRFeedBackUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpFeedBack alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value;
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
    
    return self.params;
}

@end

//
//  WVRSearchUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSearchUseCase.h"
#import "WVRApiHttpSearch.h"
#import "WVRSearchReformer.h"
#import "WVRErrorViewModel.h"

@implementation WVRSearchUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpSearch alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        id result = [self.requestApi fetchDataWithReformer:[[WVRSearchReformer alloc] init]];
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
    
    if (self.type) {
        return @{kHttpParams_search_keyWord:self.keyWord,
                 @"v":@"2",
                 kHttpParams_search_type:self.type};
    } else {
        return @{kHttpParams_search_keyWord:self.keyWord,
                 @"v":@"2"
                 };
    }
}

@end

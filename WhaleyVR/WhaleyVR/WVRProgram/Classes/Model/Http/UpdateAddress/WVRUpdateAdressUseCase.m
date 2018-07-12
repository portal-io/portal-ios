//
//  WVRUpdateAdressUseCase.m
//  WVRProgram
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRUpdateAdressUseCase.h"
#import "WVRHttpUpdateAddress.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpAddressModel.h"

@implementation WVRUpdateAdressUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpUpdateAddress alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        WVRHttpAddressModel *resSuccess = [WVRHttpAddressModel yy_modelWithDictionary:value.content];
        
        return resSuccess;
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

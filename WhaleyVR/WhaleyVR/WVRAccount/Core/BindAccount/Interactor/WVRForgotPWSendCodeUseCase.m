//
//  WVRForgotPWSendCodeUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRForgotPWSendCodeUseCase.h"
#import "WVRApiHttpForgotPasswordSMSCode.h"
#import "WVRErrorViewModel.h"

@interface WVRForgotPWSendCodeUseCase ()



@end
@implementation WVRForgotPWSendCodeUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpForgotPasswordSMSCode alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value;
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
                   Params_forgotPWSMSCode_account:self.inputPhoneNum,
                   
                   };
    }
    return params;
}

@end

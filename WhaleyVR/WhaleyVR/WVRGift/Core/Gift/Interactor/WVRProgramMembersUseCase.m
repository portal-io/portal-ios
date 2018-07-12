//
//  WVRProgramMembersUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramMembersUseCase.h"
#import "WVRHttpProgramMember.h"
#import "WVRErrorViewModel.h"
#import "WVRProgramMemberReformer.h"


@implementation WVRProgramMembersUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRHttpProgramMember alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSArray* result = [self.requestApi fetchDataWithReformer:[[WVRProgramMemberReformer alloc] init]];
        return result;
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
    
    NSDictionary * params = @{
                              kHttpParams_programMember_Code : self.code,
                              
                              };
    return params;
}
@end


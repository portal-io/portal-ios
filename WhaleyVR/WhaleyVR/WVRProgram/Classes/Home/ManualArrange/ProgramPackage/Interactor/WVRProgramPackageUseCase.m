//
//  WVRProgramPackageUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramPackageUseCase.h"
#import "WVRHttpProgramPackageReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpProgramPackage.h"
#import "WVRSectionModel.h"

@implementation WVRProgramPackageUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRHttpProgramPackage alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRSectionModel* result = [self.requestApi fetchDataWithReformer:[[WVRHttpProgramPackageReformer alloc] init]];
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

//params[kHttpParam_programPackage_code] = code;
//params[kHttpParam_programPackage_size] = @"100";
//params[kHttpParam_programPackage_page] = @"0";
//params[@"uid"] = [WVRUserModel sharedInstance].accountId;


- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        params = @{
                   kHttpParam_programPackage_code:self.code,
                   kHttpParam_programPackage_page:@"0",
                   kHttpParam_programPackage_size:@"1000",
                   @"uid":[WVRUserModel sharedInstance].accountId
                   };
    }
    return params;
}
@end

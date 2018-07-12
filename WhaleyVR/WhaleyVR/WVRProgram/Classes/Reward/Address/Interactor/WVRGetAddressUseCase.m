//
//  WVRGetAddressUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGetAddressUseCase.h"
#import "WVRApiHttpGetAddress.h"
#import "WVRGetAddressReformer.h"
#import "WVRAddressModel.h"
#import "WVRErrorViewModel.h"

@implementation WVRGetAddressUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpGetAddress alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRAddressModel* result = [self.requestApi fetchDataWithReformer:[[WVRGetAddressReformer alloc] init]];
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
    return @{kHttpParams_getAddress_whaleyuid:[WVRUserModel sharedInstance].accountId};
}
@end

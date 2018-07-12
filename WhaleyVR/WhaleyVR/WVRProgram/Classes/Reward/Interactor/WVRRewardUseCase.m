//
//  WVRGetAddressUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRewardUseCase.h"
#import "WVRApiHttpReward.h"
#import "WVRRewardReformer.h"
#import "WVRAddressModel.h"
#import "WVRErrorViewModel.h"
#import "WVRRewardVCModel.h"

@implementation WVRRewardUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpReward alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRRewardVCModel* result = [self.requestApi fetchDataWithReformer:[[WVRRewardReformer alloc] init]];
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
    return @{kHttpParams_rewardList_whaleyuid:[WVRUserModel sharedInstance].accountId};
}
@end

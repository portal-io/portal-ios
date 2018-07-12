//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveListUseCase.h"
#import "WVRApiHttpLiveList.h"
#import "WVRLiveListReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRLiveItemModel.h"

@implementation WVRLiveListUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpLiveList alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSArray<WVRLiveItemModel*>* result = [self.requestApi fetchDataWithReformer:[[WVRLiveListReformer alloc] init]];
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
    return @{};
}
@end

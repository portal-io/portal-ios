//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelUseCase.h"
#import "WVRApiHttpAllChannel.h"
#import "WVRAllChannelReformer.h"
#import "WVRErrorViewModel.h"

@implementation WVRAllChannelUseCase

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpAllChannel alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        NSArray<WVRItemModel*>* result = [self.requestApi fetchDataWithReformer:[[WVRAllChannelReformer alloc] init]];
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

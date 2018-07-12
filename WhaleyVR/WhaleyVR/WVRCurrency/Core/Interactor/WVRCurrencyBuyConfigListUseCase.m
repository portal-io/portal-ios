//
//  WVRCurrencyBuyConfigListUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyBuyConfigListUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpCurrencyBuyConfigList.h"
#import "WVRCurrencyBuyConfigListReformer.h"

@implementation WVRCurrencyBuyConfigListUseCase
- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpCurrencyBuyConfigList alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        id result = [self.requestApi fetchDataWithReformer:[[WVRCurrencyBuyConfigListReformer alloc] init]];
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    return params;
}

- (RACCommand *)requestCmd {
    
    return self.requestApi.requestCmd;
}
@end

//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHistoryDelAllUseCase.h"
#import "WVRApiHttpHistoryDelAll.h"
#import "WVRAllChannelReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRRefreshTokenUseCase.h"

@interface WVRHistoryDelAllUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end
@implementation WVRHistoryDelAllUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpHistoryDelAll alloc] init];
}

- (WVRRefreshTokenUseCase *)gRefreshTokenUC
{
    if (!_gRefreshTokenUC) {
        _gRefreshTokenUC = [[WVRRefreshTokenUseCase alloc] init];
    }
    return _gRefreshTokenUC;
}


- (RACSignal *)buildUseCase {
    @weakify(self);
    return [[[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        return value;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        NSString * code = value.content[@"code"];
        @strongify(self);
        return [self.gRefreshTokenUC filterTokenValide:code retryCmd:self.getRequestCmd];
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
                              history_delAll_uid : [WVRUserModel sharedInstance].accountId,
                              history_delAll_deviceId : [WVRUserModel sharedInstance].deviceId,
                              history_delAll_dataSource : @"app"
                              };
    return params;
}
@end

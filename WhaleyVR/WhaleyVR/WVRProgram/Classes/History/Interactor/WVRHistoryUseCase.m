//
//  WVRAllChannelUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHistoryUseCase.h"
#import "WVRApiHttpHistoryList.h"
#import "WVRHistoryModelReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRRefreshTokenUseCase.h"

@interface WVRHistoryUseCase ()

@property (nonatomic, strong) WVRRefreshTokenUseCase * gRefreshTokenUC;

@end
@implementation WVRHistoryUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpHistoryList alloc] init];
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
        NSString * code = value.content[@"code"];
        if ([code isEqualToString:@"152"]) {
            return value;
        }
        if ([code isEqualToString:@"401"]) {
            NSLog(@"auth error");
            return value;
        }
        NSArray<WVRItemModel*>* result = [self.requestApi fetchDataWithReformer:[[WVRHistoryModelReformer alloc] init]];
        return result;
    }] filter:^BOOL(WVRNetworkingResponse *  _Nullable value) {
        if (![value isKindOfClass:[WVRNetworkingResponse class]]) {
            return YES;
        }
        NSString * code = value.content[@"code"];
        if ([code isEqualToString:@"401"]) {
            NSLog(@"auth error");
            return NO;
        }
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
                              history_list_uid : [WVRUserModel sharedInstance].accountId,
                              history_list_device_id : [WVRUserModel sharedInstance].deviceId,
                              history_list_page : @"0",
                              history_list_size : @"100",
                              history_list_dataSource : @"app"
                              };
    return params;
}
@end

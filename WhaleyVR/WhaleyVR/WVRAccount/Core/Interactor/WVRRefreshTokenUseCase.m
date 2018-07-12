//
//  WVRRefreshTokenUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRefreshTokenUseCase.h"
#import "WVRApiHttpRefreshToken.h"
#import "WVRErrorViewModel.h"
#import "WVRMediator+AccountActions.h"

@implementation WVRRefreshTokenUseCase

- (BOOL)filterTokenValide:(NSString *)code retryCmd:(RACCommand *)cmd {
    
    if ([code isEqualToString:@"152"]) {
//        @weakify(self);
        [[self buildUseCase] subscribeNext:^(id  _Nullable x) {
            
            [cmd execute:nil];
        }];
        [[self buildErrorCase] subscribeNext:^(id  _Nullable x) {
            
        }];
        [[self getRequestCmd] execute:nil];
        return NO;
    }
    return YES;
}

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpRefreshToken alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSMutableDictionary *result = (NSMutableDictionary *)value.content;
        NSString *code = result[@"code"];
        
        if ([code isEqualToString:@"200"]) {
            
            NSMutableDictionary *data = [result valueForKey:@"data"];
            NSString * accesstoken = [data valueForKey:@"accesstoken"];
            NSString * refreshtoken = [data valueForKey:@"refreshtoken"];
            NSString * expiretime = [data valueForKey:@"expiretime"];
            [WVRUserModel sharedInstance].sessionId = accesstoken;
            [WVRUserModel sharedInstance].refreshtoken = refreshtoken;
            [WVRUserModel sharedInstance].expiration_time = expiretime;
            
        } else {
            DDLogError(@"error: refresh token failed! code = %@, msg = %@", code, result[@"msg"]);
            
            [[WVRMediator sharedInstance] WVRMediator_Logout:nil];
        }
        
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
                   refreshToken_refreshtoken:[WVRUserModel sharedInstance].refreshtoken,
                   refreshToken_device_id:[WVRUserModel sharedInstance].deviceId,
                   refreshToken_accesstoken:[WVRUserModel sharedInstance].sessionId
                   };
    }
    return params;
}

@end

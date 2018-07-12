//
//  WVRCheckDeviceUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCheckDeviceUseCase.h"
#import "WVRHttpCheckDevice.h"
#import "WVRErrorViewModel.h"

@implementation WVRCheckDeviceUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpCheckDevice alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        
        @strongify(self);
        NSNumber *result = [self dealWithResponse:value];
        
        return result;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)buildErrorCase {
    
    return [[self.requestApi.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    
    NSDictionary *params = @{};
    if (manager == self.requestApi) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"uid"] = [WVRUserModel sharedInstance].accountId;
        dict[@"deviceId"] = [WVRUserModel sharedInstance].deviceId;
        dict[@"sign"] = [self sign];
        
        params = dict;
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@", [[WVRUserModel sharedInstance] accountId], [WVRUserModel sharedInstance].deviceId];
    
    unSignStr = [unSignStr stringByAppendingString:[WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (NSNumber *)dealWithResponse:(WVRNetworkingResponse *)response {
    
    NSDictionary *dic = response.content;
    NSString *msg = dic[@"msg"];
    int code = [dic[@"code"] intValue];
    
    BOOL isSign = [dic[@"data"] boolValue];
    
    if (code == 200) {
        
        return @(isSign);
    } else {
        DDLogError(@"%d -- %@", code, msg);
    }
    
    return @(YES);
}

@end

//
//  WVRUserRedeemCodeUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUserRedeemCodeUseCase.h"
#import "WVRApiHttpUserRedeemCode.h"
#import "WVRUnExchangeCodeModel.h"
#import "WVRErrorViewModel.h"
#import "WVRUserRedeemCodeReformer.h"
#import "SQMD5Tool.h"

@implementation WVRUserRedeemCodeUseCase

//            NSDictionary *dict = responseObj;
//            int code = [dict[@"code"] intValue];
//            NSString *msg = [NSString stringWithFormat:@"%@", dict[@"msg"]];
//
//            if (code == 200) {
//
//                NSDictionary *data = dict[@"data"];
//                WVRUnExchangeCodeModel *model = [WVRUnExchangeCodeModel yy_modelWithDictionary:data];
//
//                block(model, nil);
//
//            } else {
//                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
//                block(nil, err);
//            }

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpUserRedeemCode alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRUnExchangeCodeModel *model = [self.requestApi fetchDataWithReformer:[[WVRUserRedeemCodeReformer alloc] init]];
        
        return model;
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
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"uid"] = [WVRUserModel sharedInstance].accountId;
        param[@"phoneNum"] = [WVRUserModel sharedInstance].mobileNumber;
    
        NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
        NSString *str = [NSString stringWithFormat:@"%@%@", param[@"uid"], param[@"phoneNum"]];
        NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
    
        param[@"sign"] = sign;

        params = param;
    }
    return params;
}

- (RACCommand *)checkPayCmd {
    
    return self.requestApi.requestCmd;
}

@end

//
//  WVRAppInPurchaseResultUseCase.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAppInPurchaseResultUseCase.h"
#import "WVRHttpApiAppInPurchaseResult.h"
#import "WVRHttpAppInPurchaseResultReformer.h"
#import "WVRErrorViewModel.h"
#import "WVRPayGoodsType.h"

@implementation WVRAppInPurchaseResultUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpApiAppInPurchaseResult alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        @strongify(self);
        WVRAppInPurchaseResultModel *result = [self.requestApi fetchDataWithReformer:[WVRHttpAppInPurchaseResultReformer new]];
        
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
    
    NSDictionary *param = @{};
    if (manager == self.requestApi) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[kHttpParam_AppInPurchaseResult_OrderNo] = self.orderNo;
        dic[kHttpParam_AppInPurchaseResult_iosTradeNo] = self.iosTradeNo;
        dic[kHttpParam_AppInPurchaseResult_phoneNum] = [[WVRUserModel sharedInstance] mobileNumber];
        dic[@"sign"] = [self sign];
        
        param = dic;
    }
    
    return param;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@", self.orderNo, self.iosTradeNo, [[WVRUserModel sharedInstance] mobileNumber]];
    
    unSignStr = [unSignStr stringByAppendingString:[WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

@end

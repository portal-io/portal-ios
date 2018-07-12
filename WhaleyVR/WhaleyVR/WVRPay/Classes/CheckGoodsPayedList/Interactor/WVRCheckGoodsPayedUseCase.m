//
//  WVRCheckGoodsPayedUseCase.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCheckGoodsPayedUseCase.h"
#import "WVRHttpApiCheckGoodsPayedList.h"
#import "WVRErrorViewModel.h"

@implementation WVRCheckGoodsPayedUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpApiCheckGoodsPayedList alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSDictionary *dic = value.content;
        NSArray *resultList = dic[@"data"];
        
        return resultList;
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
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"uid"] = [[WVRUserModel sharedInstance] accountId];
        dict[@"goodsNos"] = self.goodsNos;
        dict[@"goodsTypes"] = self.goodsTypes;
        dict[@"sign"] = [self sign];
        
        params = dict;
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@%@", [[WVRUserModel sharedInstance] accountId], self.goodsNos, self.goodsTypes, [WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)checkPayCmd {
    
    return self.requestApi.requestCmd;
}

@end

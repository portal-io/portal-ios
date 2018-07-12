//
//  WVRCurrencyOrderListUseCase.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 用户鲸币订单列表UseCase

#import "WVRCurrencyOrderListUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRHttpCurrencyOrderList.h"
#import "WVRCurrencyOrderListModel.h"

@implementation WVRCurrencyOrderListUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRHttpCurrencyOrderList alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        NSDictionary *dic = value.content;
        //
        NSDictionary* data = dic[@"data"];
        WVRCurrencyOrderListModel *model = [WVRCurrencyOrderListModel yy_modelWithDictionary:data];
        
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (manager == self.requestApi) {
        params[@"page"] = [NSString stringWithFormat:@"%d", self.page];
        params[@"size"] = [NSString stringWithFormat:@"%d", self.size];
        params[@"uid"] = [[WVRUserModel sharedInstance] accountId];
        params[@"sign"] = [self sign];
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@%@", [NSString stringWithFormat:@"%d", self.page], [NSString stringWithFormat:@"%d", self.size], [[WVRUserModel sharedInstance] accountId],[WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)requestCmd {
    
    return self.requestApi.requestCmd;
}

@end

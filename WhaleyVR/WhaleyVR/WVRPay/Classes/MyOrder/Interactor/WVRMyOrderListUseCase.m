//
//  WVRMyOrderListUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyOrderListUseCase.h"
#import "WVRApiHttpMyOrderList.h"
#import "WVRMyOrderListReformer.h"
#import "WVRMyOrderItemModel.h"
#import "WVRErrorViewModel.h"

@implementation WVRMyOrderListUseCase
- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpMyOrderList alloc] init];
}

- (RACSignal *)buildUseCase {
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
//        NSDictionary *dic = value.content;
//        int code = [dic[@"code"] intValue];
//        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
//        NSDictionary *resDict = dic[@"data"];
        
        WVRMyOrderListModel *model = [self.requestApi fetchDataWithReformer:[[WVRMyOrderListReformer alloc] init]];
        
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
        params = @{
                   kHttpParam_myOrder_uid:[WVRUserModel sharedInstance].sessionId,
                   kHttpParam_myOrder_page:self.page,
                   kHttpParam_myOrder_size:self.size,
                   kHttpParam_myOrder_sign:[self sign]
                   };
    }
    return params;
}

-(NSString*)sign
{
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@", self.page, self.size, [WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

-(RACCommand *)checkPayCmd
{
    return self.requestApi.requestCmd;
}

@end


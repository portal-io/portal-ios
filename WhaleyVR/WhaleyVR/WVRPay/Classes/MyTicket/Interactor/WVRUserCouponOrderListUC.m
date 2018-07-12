//
//  WVRUserCouponOrderListUC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUserCouponOrderListUC.h"
#import "WVRApiHttpUserCouponOrderList.h"
#import "WVRUserCouponOrderListReformer.h"
#import "WVRUserTicketListModel.h"
#import "WVRErrorViewModel.h"

@implementation WVRUserCouponOrderListUC

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpUserCouponOrderList alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRUserTicketListModel *model = [self.requestApi fetchDataWithReformer:[[WVRUserCouponOrderListReformer alloc] init]];
        
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
                   @"uid": [WVRUserModel sharedInstance].accountId,
                   @"page": self.page,
                   @"size": self.size,
                   @"sign": [self sign],
                   };
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@%@%@", [WVRUserModel sharedInstance].accountId, self.page, self.size, [WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (RACCommand *)checkPayCmd {
    
    return self.requestApi.requestCmd;
}

@end

//
//  WVRExchangeRedeemCodeUC.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRExchangeRedeemCodeUC.h"
#import "WVRApiHttpExchangeRedeemCode.h"
#import "WVRErrorViewModel.h"
#import "WVRMyTicketListModel.h"
#import "WVRHttpExchangeRedeemCodeReformer.h"

@implementation WVRExchangeRedeemCodeUC

- (void)initRequestApi {
    self.requestApi = [[WVRApiHttpExchangeRedeemCode alloc] init];
}

- (RACSignal *)buildUseCase {
    
    @weakify(self);
    return [self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        @strongify(self);
        
        NSDictionary *data = value.content;
        int statusCode = [data[@"code"] intValue];
        
        if (statusCode == 200) {
            
            WVRMyTicketItemModel * model = [self.requestApi fetchDataWithReformer:[WVRHttpExchangeRedeemCodeReformer new]];
            return model;
        } else {
            int subStatusCode = [data[@"subCode"] intValue];
            NSError *err = [self errorWithCode:statusCode subCode:subStatusCode];
            return err;
        }
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
        
        dict[@"uid"] = [WVRUserModel sharedInstance].accountId;
        dict[@"redeemCode"] = self.redeemCode;
        dict[@"sign"] = [self sign];
        
        params = dict;
    }
    return params;
}

- (NSString *)sign {
    
    NSString *unSignStr = [NSString stringWithFormat:@"%@%@", [[WVRUserModel sharedInstance] accountId], self.redeemCode];
    
    unSignStr = [unSignStr stringByAppendingString:[WVRUserModel CMCPURCHASE_sign_secret]];
    
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    return signStr;
}

- (NSError *)errorWithCode:(int)code subCode:(int)subCode {
    
    NSString *msg = kLoadError;
    if (code == 400) {
        
        switch (subCode) {
            case 33:
                msg = @"兑换码错误，请检查输入";
                break;
            case 34:
                msg = @"这个兑换码之前兑换过啦 :p";
                break;
            case 35:
                msg = @"这个兑换码已经被兑换过，如非本人操作请联系客服";
                break;
            case 36:
                msg = @"你已经拥有了同样的观看券了，这个兑换码还可以送给朋友哦 :p";
                break;
            case 37:
            case 44:
                msg = @"该兑换码已经过了有效兑换期 :(";
                break;

            default:
                break;
        }
    }
    NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
    return err;
}

- (RACCommand *)createOrderCmd {
    
    return self.requestApi.requestCmd;
}

@end


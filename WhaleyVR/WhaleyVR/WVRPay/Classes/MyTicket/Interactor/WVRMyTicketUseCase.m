//
//  WVRMyTicketUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyTicketUseCase.h"
#import "WVRApiHttpMyTicket.h"
#import "WVRMyTicketReformer.h"
#import "WVRMyTicketListModel.h"
#import "WVRErrorViewModel.h"

@implementation WVRMyTicketUseCase

- (void)initRequestApi {
    
    self.requestApi = [[WVRApiHttpMyTicket alloc] init];
}

- (RACSignal *)buildUseCase {
    
    return [[self.requestApi.executionSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRMyTicketListModel *model = [self.requestApi fetchDataWithReformer:[[WVRMyTicketReformer alloc] init]];
        
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
                   kHttpParam_myTicket_uid:[WVRUserModel sharedInstance].accountId,
                   kHttpParam_myTicket_page:self.page,
                   kHttpParam_myTicket_size:self.size,
                   kHttpParam_myTicket_sign:[self sign]
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


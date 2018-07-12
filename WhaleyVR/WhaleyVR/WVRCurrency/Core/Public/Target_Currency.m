//
//  Target_program.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_Currency.h"
#import "WVRCurrencyVC.h"
#import "WVRCurrencyBalanceUseCase.h"
#import "WVRCurrencyCostUseCase.h"

@interface Target_Currency ()

@end


@implementation Target_Currency

- (UIViewController *)Action_nativeCurrencyConfigViewController:(NSDictionary *)params
{
    WVRCurrencyVC * vc = [[WVRCurrencyVC alloc] init];
    return vc;
}

- (void)Action_nativeGetUserWCBalance:(NSDictionary *)params
{
    WVRCurrencyBalanceUseCase * balanceUC = [[WVRCurrencyBalanceUseCase alloc] init];
    [[balanceUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        
    }];
    [balanceUC.getRequestCmd execute:nil];
}

- (void)Action_nativeBuyWithWhaleyCurrency:(NSDictionary *)params {
    
    WVRCurrencyCostUseCase * balanceUC = [[WVRCurrencyCostUseCase alloc] init];
    balanceUC.buyParams = params[@"ticketCode"];
    balanceUC.bizParams = params[@"ticketName"];
    balanceUC.buyType = @"REDUCE_COUPON";
    
    RACCommand *cmd = params[@"cmd"];
    
    [[balanceUC buildUseCase] subscribeNext:^(WVRNetworkingResponse * x) {
        
        NSInteger code = [x.content[@"code"] integerValue];
        if (code == 200) {
            
            [cmd execute:@1];
        } else {
            [cmd execute:@0];
            DDLogError(@"Action_nativeBuyWithWhaleyCurrency error: %@", x.contentString);
        }
    }];
    [[balanceUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        [cmd execute:@0];
    }];
    
    [balanceUC.getRequestCmd execute:nil];
}

@end

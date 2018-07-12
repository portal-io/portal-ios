//
//  WVRMediator+Account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+Currency.h"

NSString * const kWVRMediatorTargetCurrency = @"Currency";

NSString * const kWVRMediatorActionNativCurrencyConfigViewController = @"nativeCurrencyConfigViewController";

NSString * const kWVRMediatorActionNativeGetUserWCBalance = @"nativeGetUserWCBalance";

NSString * const kWVRMediatorActionNativeBuyWithWhaleyCurrency = @"nativeBuyWithWhaleyCurrency";

@implementation WVRMediator (Currency)

- (UIViewController *)WVRMediator_CurrencyConfigViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetCurrency
                                                    action:kWVRMediatorActionNativCurrencyConfigViewController
                                                    params:@{}
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

- (void)WVRMediator_GetUserWCBalance
{
    [self performTarget:kWVRMediatorTargetCurrency
                 action:kWVRMediatorActionNativeGetUserWCBalance
                 params:@{}
      shouldCacheTarget:NO
     ];
}

- (void)WVRMediator_BuyWithWhaleyCurrency:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetCurrency
                 action:kWVRMediatorActionNativeBuyWithWhaleyCurrency
                 params:params
      shouldCacheTarget:NO
     ];
}

@end

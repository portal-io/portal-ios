//
//  WVRMediator+Account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+SettingActions.h"

NSString * const kWVRMediatorTargetSetting = @"setting";

NSString * const kWVRMediatorActionNativeFetchSettingViewController = @"nativeFetchSettingViewController";

NSString * const kWVRMediatorActionNativeFetchMineViewController = @"nativeFetchMineViewController";

NSString * const kWVRMediatorActionNativeFetchLocalViewController = @"nativeFetchLocalViewController";

NSString * const kWVRMediatorActionNativeAddDownloadTask = @"nativeAddDownloadTask";

NSString * const kWVRMediatorActionNativeUpdateRewardDot = @"nativeUpdateRewardDot";

@implementation WVRMediator (SettingActions)

- (UIViewController *)WVRMediator_MineViewController {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetSetting
                                                    action:kWVRMediatorActionNativeFetchMineViewController
                                                    params:@{@"key":@"value"}
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

- (UIViewController *)WVRMediator_SettingViewController {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetSetting
                                                    action:kWVRMediatorActionNativeFetchSettingViewController
                                                    params:@{@"key":@"value"}
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

- (UIViewController *)WVRMediator_LocalViewController:(BOOL)needUpdate {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (needUpdate) {
        dict[@"update"] = @(YES);
    }
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetSetting
                                                    action:kWVRMediatorActionNativeFetchLocalViewController
                                                    params:dict
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

- (void)WVRMediator_UpdateRewardDot:(BOOL)show {
    
    NSDictionary *dict = @{ @"show":@(show) };
    
    [self performTarget:kWVRMediatorTargetSetting
                 action:kWVRMediatorActionNativeUpdateRewardDot
                 params:dict
      shouldCacheTarget:NO
     ];
}


- (void)WVRMediator_LocalAddDownloadTask:(NSDictionary*)params
{
    [self performTarget:kWVRMediatorTargetSetting
                                                    action:kWVRMediatorActionNativeAddDownloadTask
                                                    params:params
                                         shouldCacheTarget:NO
                                        ];

}
@end

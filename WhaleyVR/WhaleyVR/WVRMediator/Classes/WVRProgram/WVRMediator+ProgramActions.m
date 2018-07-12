//
//  WVRMediator+Account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+ProgramActions.h"

NSString * const kWVRMediatorTargetProgram = @"program";

NSString * const kWVRMediatorActionNativeFetchHistoryViewController = @"nativeFetchHistoryViewController";

NSString * const kWVRMediatorActionNativeFetchRewardViewController = @"nativeFetchRewardViewController";

NSString * const kWVRMediatorActionNativeFetchCollectionViewController = @"nativeFetchCollectionViewController";

NSString * const kWVRMediatorActionNativePlayerVCLocal = @"nativePlayerVCLocal";

NSString * const kWVRMediatorActionNativeGotoNextVC = @"nativeGotoNextVC";

NSString * const kWVRMediatorActionNativeFetchVideoDetailVC = @"nativeFetchVideoDetailVC";

NSString * const kWVRMediatorActionNativeFetchLiveDetailVC = @"nativeFetchLiveDetailVC";

NSString * const kWVRMediatorActionNativeFetchPlayerVCLive = @"nativeFetchPlayerVCLive";

NSString * const kWVRMediatorActionNativeFetchProgramPackageVC = @"nativeFetchProgramPackageVC";

@implementation WVRMediator (ProgramActions)

- (UIViewController *)WVRMediator_HistoryViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchHistoryViewController
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

- (UIViewController *)WVRMediator_RewardViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchRewardViewController
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

- (UIViewController *)WVRMediator_CollectionViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchCollectionViewController
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

- (UIViewController *)WVRMediator_PlayerVCLocal:(NSDictionary *)params {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativePlayerVCLocal
                                                    params:params
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

- (UIViewController *)WVRMediator_VideoDetailVC:(NSDictionary *)params {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchVideoDetailVC
                                                    params:params
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

- (UIViewController *)WVRMediator_LiveDetailVC:(NSDictionary *)params {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchLiveDetailVC
                                                    params:params
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

- (UIViewController *)WVRMediator_PlayerVCLive:(NSDictionary *)params {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchPlayerVCLive
                                                    params:params
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

- (UIViewController *)WVRMediator_ProgramPackageVC:(NSDictionary *)params {
    
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetProgram
                                                    action:kWVRMediatorActionNativeFetchProgramPackageVC
                                                    params:params
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

- (void)WVRMediator_gotoNextVC:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetProgram
                 action:kWVRMediatorActionNativeGotoNextVC
                 params:params
      shouldCacheTarget:YES
     ];
}

@end

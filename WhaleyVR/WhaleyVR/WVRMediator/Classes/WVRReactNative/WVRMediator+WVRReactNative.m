//
//  WVRMediator+Account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+WVRReactNative.h"

NSString * const kWVRMediatorTargetWVRReactNative = @"reactNative";

NSString * const kWVRMediatorActionNativeReactNativeGoldViewController = @"nativeReactNativeGoldViewController";

NSString * const kWVRMediatorActionNativeReactNativeLiveCompleteVC = @"nativeReactNativeLiveCompleteVC";

@implementation WVRMediator (WVRReactNative)

- (UIViewController *)WVRMediator_WVRReactNativeGoldViewController:(NSDictionary *)params;
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetWVRReactNative
                                                    action:kWVRMediatorActionNativeReactNativeGoldViewController
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

- (UIViewController *)WVRMediator_WVRReactNativeLiveCompleteVC:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetWVRReactNative
                                                    action:kWVRMediatorActionNativeReactNativeLiveCompleteVC
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
@end

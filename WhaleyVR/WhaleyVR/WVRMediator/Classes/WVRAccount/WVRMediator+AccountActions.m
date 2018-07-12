//
//  WVRMediator+Account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator+AccountActions.h"

NSString * const kWVRMediatorTargetAccount = @"account";

NSString * const kWVRMediatorActionNativFetchUserInfoViewController = @"nativeFetchUserInfoViewController";

NSString * const kWVRMediatorActionNativFetchLoginViewController = @"nativeFetchLoginViewController";

NSString * const kWVRMediatorActionNativFetchRegisterViewController = @"nativeFetchRegisterViewController";

NSString * const kWVRMediatorActionNativeGetUserInfo = @"nativeGetUserInfo";

NSString * const kWVRMediatorActionNativeRefreshToken = @"nativeRefreshToken";

NSString * const kWVRMediatorActionNativeCheckAndAlertLogin = @"nativeCheckAndAlertLogin";
NSString * const kWVRMediatorActionNativeCheckAndToLogin = @"nativeCheckAndToLogin";

NSString * const kWVRMediatorActionNativeForceLogout = @"nativeForceLogout";

NSString * const kWVRMediatorActionNativeLogout = @"nativeLogout";

NSString * const kWVRMediatorActionNativePresentImage = @"nativePresentImage";
NSString * const kWVRMediatorActionNativeNoImage = @"nativeNoImage";
NSString * const kWVRMediatorActionShowAlert = @"showAlert";
NSString * const kWVRMediatorActionCell = @"cell";
NSString * const kWVRMediatorActionConfigCell = @"configCell";


@implementation WVRMediator (AccountActions)

- (UIViewController *)WVRMediator_UserInfoViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetAccount
                                                    action:kWVRMediatorActionNativFetchUserInfoViewController
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

- (UIViewController *)WVRMediator_LoginViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetAccount
                                                    action:kWVRMediatorActionNativFetchLoginViewController
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

- (UIViewController *)WVRMediator_RegisterViewController
{
    UIViewController *viewController = [self performTarget:kWVRMediatorTargetAccount
                                                    action:kWVRMediatorActionNativFetchRegisterViewController
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

- (void)WVRMediator_GetUserInfo {
    
    [self performTarget:kWVRMediatorTargetAccount
                 action:kWVRMediatorActionNativeGetUserInfo
                 params:@{@"key":@"value"}
      shouldCacheTarget:NO ];
}

- (BOOL)WVRMediator_RefreshToken:(NSDictionary *)params {
    
    return [[self performTarget:kWVRMediatorTargetAccount
                         action:kWVRMediatorActionNativeRefreshToken
                         params:params
              shouldCacheTarget:NO ] boolValue];
}

- (BOOL)WVRMediator_CheckAndAlertLogin:(NSDictionary *)params {
    
    return [[self performTarget:kWVRMediatorTargetAccount
                         action:kWVRMediatorActionNativeCheckAndAlertLogin
                         params:params
              shouldCacheTarget:NO ] boolValue];
}

- (BOOL)WVRMediator_CheckAndToLogin:(NSDictionary *)params {
    
    return [[self performTarget:kWVRMediatorTargetAccount
                         action:kWVRMediatorActionNativeCheckAndToLogin
                         params:params
              shouldCacheTarget:NO ] boolValue];
}

- (void)WVRMediator_ForceLogout:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetAccount
                 action:kWVRMediatorActionNativeForceLogout
                 params:params
      shouldCacheTarget:NO ];
}

- (void)WVRMediator_Logout:(NSDictionary *)params {
    
    [self performTarget:kWVRMediatorTargetAccount
                 action:kWVRMediatorActionNativeLogout
                 params:params
      shouldCacheTarget:NO ];
}

@end

//
//  Target_account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Target_account : NSObject


- (UIViewController *)Action_nativeFetchLoginViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchRegisterViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchUserInfoViewController:(NSDictionary *)params;

- (void)Action_nativeGetUserInfo:(NSDictionary *)params;

/*
 params = @{ @"cmd":RACCommand(),@"code":@"152" }
 */
- (BOOL)Action_nativeRefreshToken:(NSDictionary *)params;

/**
 检测并提醒用户登录

 @param params @{ @"alertTitle":NSString , @"completeCmd":completeCmd, @"cancelCmd":cancelCmd }
 @return isLogined
 */
- (BOOL)Action_nativeCheckAndAlertLogin:(NSDictionary *)params;

/**
 检测登录，未登录则调起登录界面
 
 @param params  @{ @"completeCmd":completeCmd, @"cancelCmd":cancelCmd }
 @return isLogined
 */
- (BOOL)Action_nativeCheckAndToLogin:(NSDictionary *)params;

/**
 强制登出用户
 
 @param params @{ @"cmd":RACCommand }
 */
- (void)Action_nativeForceLogout:(NSDictionary *)params;

/**
 登出用户
 
 @param params
 */
- (void)Action_nativeLogout:(NSDictionary *)params;
@end

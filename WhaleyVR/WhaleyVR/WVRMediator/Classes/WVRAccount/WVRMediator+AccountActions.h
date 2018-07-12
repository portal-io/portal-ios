//
//  WVRMediator+Account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (AccountActions)

- (UIViewController *)WVRMediator_UserInfoViewController;

- (UIViewController *)WVRMediator_LoginViewController;

- (UIViewController *)WVRMediator_RegisterViewController;

/**
 获取/刷新用户信息
 */
- (void)WVRMediator_GetUserInfo;

/**
 RefreshToken

 @param params @{ @"cmd":RACCommand, @"code":@"152" }
 @return success
 */
- (BOOL)WVRMediator_RefreshToken:(NSDictionary *)params;

/**
 检测并提醒用户登录
 
 @param params @{ @"alertTitle":NSString, @"completeCmd":completeCmd, @"cancelCmd":cancelCmd }
 @return isLogined
 */
- (BOOL)WVRMediator_CheckAndAlertLogin:(NSDictionary *)params;

/**
 检测登录，未登录则调起登录界面

 @param params  @{ @"completeCmd":completeCmd, @"cancelCmd":cancelCmd }
 @return isLogined
 */
- (BOOL)WVRMediator_CheckAndToLogin:(NSDictionary *)params;

/**
 强制登出用户

 @param params @{ @"cmd":RACCommand }
 */
- (void)WVRMediator_ForceLogout:(NSDictionary *)params;

/**
 登出用户
 */
- (void)WVRMediator_Logout:(NSDictionary *)params;

@end

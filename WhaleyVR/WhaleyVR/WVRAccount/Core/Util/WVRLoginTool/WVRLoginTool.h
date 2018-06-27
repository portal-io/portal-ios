//
//  WVRLoginTool.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WVRItemModel;

@interface WVRLoginTool : NSObject

//+ (BOOL)checkLogin NS_DEPRECATED(10_0, 10_11, 2_0, 9_0, "Use -checkAndAlertLogin instead, which always show alert before login");

+ (BOOL)checkAndAlertLogin;

// isLogined 调起登录界面后用户登录行为为NO，检测时已登录为YES
// alert message: 请登录账户
+ (BOOL)checkAndAlertLogin:(void(^)(BOOL isLogined))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock;

/// 提醒登录，自定义提示信息
+ (BOOL)checkAndAlertLogin:(NSString *)alertMsg completeBlock:(void(^)(BOOL isLogined))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock;

+ (void)toGoLogin;


+ (void)toGoLogin:(void(^)(void))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock;

/// 调起登录界面前不弹框提示
+ (BOOL)checkLogin:(void(^)(void))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock;

/// register
+ (void)toGoRegister:(void(^)(void))completeBlock registerCanceledBlock:(void(^)(void))registerCanceledBlock;

/// 强制登出
+ (void)forceLogout:(void(^)(void))completeBlock;

/// 登出并清除用户信息
+ (void)logout;

/// 清除用户信息
+ (void)clearUserInfo;

/// 清除本地缓存头像数据
+ (void)clearLocalAvatar;

@end

//
//  UnityAppController.h
//  WhaleyVR
//
//  Created by Snailvr on 16/7/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRTabBarController.h"

@class WVRItemModel;

@interface UnityAppController : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) WVRTabBarController *tabBarController;

@property (nonatomic, strong) WVRItemModel * gJPushModel;


- (void)displayMainController;

// 界面统一跳转（启动屏，推送通知）
- (void)displayMainController:(WVRItemModel *)lModel;
- (void)displayMainControllerWithBlock:(void(^)(void))block;

- (void)setUpNotLockTimer;
- (void)invalidNotLockTimer;

@end


//
//  WVRTabBarController.h
//  WhaleyVR
//
//  Created by Snailvr on 16/8/31.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 主控制器

#import <UIKit/UIKit.h>

@interface WVRTabBarController : UITabBarController

- (UIViewController *)currentShowVC;
- (UINavigationController *)currentShowNav;

@property (nonatomic, copy) void(^viewDidAppearBlock)(void);

@end

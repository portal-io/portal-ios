//
//  WVRMediator+Launcher.h
//  WVRMediator
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 WhaleyVR. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (Launcher)

/**
 设置极光推送标签
 */
- (void)WVRMediator_SetTagsAlias;

/**
 获取根tabbarController

 @return WVRTabbarController
 */
- (UITabBarController *)WVRMediator_TabbarController;

@end

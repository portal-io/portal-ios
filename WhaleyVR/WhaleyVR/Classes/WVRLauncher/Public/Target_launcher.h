//
//  Target_launcher.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_launcher : NSObject

/**
 设置极光推送标签

 @param params nil
 */
- (void)Action_nativeSetTagsAlias:(NSDictionary *)params;

/**
 获取根tabbarController
 
 @return WVRTabbarController
 */
- (UITabBarController *)Action_nativeTabbarController:(NSDictionary *)params;

@end

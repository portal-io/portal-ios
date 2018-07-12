//
//  WVRMediator+Launcher.m
//  WVRMediator
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 WhaleyVR. All rights reserved.
//

#import "WVRMediator+Launcher.h"

NSString * const kWVRMediatorTargetLauncher = @"launcher";

NSString * const kWVRMediatorActionNativeSetTagsAlias = @"nativeSetTagsAlias";

NSString * const kWVRMediatorActionNativeTabbarController = @"nativeTabbarController";

@implementation WVRMediator (Launcher)

- (void)WVRMediator_SetTagsAlias {
    
    [self performTarget:kWVRMediatorTargetLauncher
                    action:kWVRMediatorActionNativeSetTagsAlias
                 params:@{}
         shouldCacheTarget:NO
            ];
}

- (UITabBarController *)WVRMediator_TabbarController {
    
    return [self performTarget:kWVRMediatorTargetLauncher
                 action:kWVRMediatorActionNativeTabbarController
                 params:@{}
      shouldCacheTarget:NO
     ];
}

@end

//
//  Target_account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_setting.h"
#import "WVRSettingsViewController.h"
#import "WVRMineController.h"
#import "WVRSQLocalController.h"

@implementation Target_setting

- (UIViewController *)Action_nativeFetchMineViewController:(NSDictionary *)params {
    
    WVRMineController * mineVC = [[WVRMineController alloc] init];
    return mineVC;
}

- (UIViewController *)Action_nativeFetchSettingViewController:(NSDictionary *)params {
    
    WVRSettingsViewController * vc = [[WVRSettingsViewController alloc] init];
    
    return vc;
}

- (UIViewController *)Action_nativeFetchLocalViewController:(NSDictionary *)params {
    
    WVRSQLocalController *localVC = [WVRSQLocalController shareInstance];
        
//    if ([params[@"update"] boolValue]) {
//        [localVC updateCachVideoInfo];
//    }
//    
    return localVC;
}

- (void)Action_nativeUpdateRewardDot:(NSDictionary *)params {
    
    BOOL show = [params[@"show"] boolValue];
    
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([tab isKindOfClass:[UITabBarController class]]) {
        printf("WVRError: Action_nativeUpdateRewardDot error");
        return;
    }
    
    UINavigationController *nv = [tab.viewControllers lastObject];
    WVRMineController * vc = nv.viewControllers.firstObject;
    [vc updateRewardDot:show];
}

- (void)Action_nativeAddDownloadTask:(NSDictionary *)params
{
    WVRVideoModel * model = params[@"videoModel"];
    WVRSQLocalController *localVc = [WVRSQLocalController shareInstance];
    [localVc addDownTask:model];
}

@end

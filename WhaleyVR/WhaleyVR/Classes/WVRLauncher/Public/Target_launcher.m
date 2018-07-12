//
//  Target_launcher.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_launcher.h"
#import "UnityAppController+JPush.h"

@implementation Target_launcher

- (void)Action_nativeSetTagsAlias:(NSDictionary *)params {
    
    UnityAppController *app = (UnityAppController *)[UIApplication sharedApplication].delegate;
    
    [app setTagsAlias];
}

- (UITabBarController *)Action_nativeTabbarController:(NSDictionary *)params {
    
    UnityAppController *app = (UnityAppController *)[UIApplication sharedApplication].delegate;
    
    return [app tabBarController];
}

@end

//
//  Target_reactNative.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_reactNative.h"
#import "WVRRNGoldViewController.h"
#import "WVRRNLiveCompleteVC.h"

@implementation Target_reactNative
- (UIViewController *)Action_nativeReactNativeGoldViewController:(NSDictionary *)params {
    
    WVRRNGoldViewController * vc = [[WVRRNGoldViewController alloc] init];
    vc.createArgs = params;
    return vc;
}

- (UIViewController *)Action_nativeReactNativeLiveCompleteVC:(NSDictionary *)params
{
    WVRRNLiveCompleteVC * vc = [[WVRRNLiveCompleteVC alloc] init];
    vc.createArgs = params;
    return vc;
}
@end

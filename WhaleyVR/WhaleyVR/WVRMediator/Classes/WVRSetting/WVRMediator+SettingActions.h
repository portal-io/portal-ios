//
//  WVRMediator+Account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (SettingActions)

/**
 Get MineViewController
 
 @return MineViewController
 */
- (UIViewController *)WVRMediator_MineViewController;

/**
 Get SettingViewController

 @return SettingViewController
 */
- (UIViewController *)WVRMediator_SettingViewController;

/**
 updateRewardDot
 
 */
- (void)WVRMediator_UpdateRewardDot:(BOOL)show;

/**
 Get LocalViewController

 @param needUpdate updateCacheVideoInfo
 @return LocalViewController
 */
- (UIViewController *)WVRMediator_LocalViewController:(BOOL)needUpdate;

/**
 添加下载任务
 
 @param params @{ @"videoModel": WVRVideoModel}
 */

- (void)WVRMediator_LocalAddDownloadTask:(NSDictionary*)params;

@end

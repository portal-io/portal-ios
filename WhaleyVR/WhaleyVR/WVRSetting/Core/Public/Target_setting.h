//
//  Target_account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_setting : NSObject

- (UIViewController *)Action_nativeFetchMineViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchSettingViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchLocalViewController:(NSDictionary *)params;

/**
 中奖小红点状态
 
 @param params @{ @"show":NSNumber }
 */
- (void)Action_nativeUpdateRewardDot:(NSDictionary *)params;

/**
 添加下载任务
 
 @param params @{ @"videoModel": WVRVideoModel}
 */
- (void)Action_nativeAddDownloadTask:(NSDictionary *)params;
@end

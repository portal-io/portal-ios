//
//  WVRMediator+Account.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator.h"

@interface WVRMediator (ProgramActions)

- (UIViewController *)WVRMediator_HistoryViewController;

- (UIViewController *)WVRMediator_RewardViewController;

- (UIViewController *)WVRMediator_CollectionViewController;

/**
 GET The PlayerVC - Local
 
 @param params @{ title, sid, duration, renderType, playURL }
 @return WVRPlayerVCLocal
 */
- (UIViewController *)WVRMediator_PlayerVCLocal:(NSDictionary *)params;

/// params @{ linkArrangeValue:NSString }
- (UIViewController *)WVRMediator_VideoDetailVC:(NSDictionary *)params;

/// params @{ linkArrangeValue:NSString }
- (UIViewController *)WVRMediator_LiveDetailVC:(NSDictionary *)params;

/// params @{ linkArrangeValue:NSString, title:NSString, liveDisplayMode:NSNumber }
- (UIViewController *)WVRMediator_PlayerVCLive:(NSDictionary *)params;

/// params @{ linkArrangeValue:NSString }
- (UIViewController *)WVRMediator_ProgramPackageVC:(NSDictionary *)params;

/**
 调用Program的GotoNextTool

 @param params @{ @"param":NSDictionary, @"nav":UINavigationController }
 */
- (void)WVRMediator_gotoNextVC:(NSDictionary *)params;

@end

//
//  Target_program.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_program : NSObject

- (UIViewController *)Action_nativeFetchHistoryViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchRewardViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchCollectionViewController:(NSDictionary *)params;

- (UIViewController *)Action_nativePlayerVCLocal:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchVideoDetailVC:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchLiveDetailVC:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchPlayerVCLive:(NSDictionary *)params;

- (UIViewController *)Action_nativeFetchProgramPackageVC:(NSDictionary *)params;

- (void)Action_nativeGotoNextVC:(NSDictionary *)params;

@end

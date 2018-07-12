//
//  WVRSQFindGotoVCTool.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRBaseModel.h"

@interface WVRGotoNextTool : NSObject

+ (void)gotoNextVC:(WVRBaseModel *)model nav:(UINavigationController *)nav;

//+ (void)gotoLauncherVC:(WVRLiveShowModel *)model nav:(UINavigationController *)nav;

// 埋点
+ (void)gotoNextVC:(WVRBaseModel *)model module:(NSString *)moduleName nav:(UINavigationController *)nav;

+ (void)jumpToGiftPage;     // for unity

@end

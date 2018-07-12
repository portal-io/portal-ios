//
//  WVRPlayerBIModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRBIManager.h"
@class WVRVideoParamEntity;

@interface WVRPlayerBIModel : NSObject

// BI
@property (nonatomic, assign) long startLoadTime;       // start loading video data
@property (nonatomic, assign) long startPlayTime;       // start play time
@property (nonatomic, assign) long startBufferTime;
@property (nonatomic, assign) long endBufferTime;
@property (nonatomic, assign) long pauseTime;
@property (nonatomic, assign) long resumeTime;
@property (nonatomic, assign) long endPlayTime;

@property (nonatomic, assign) int screenType;             // 全屏：1，半屏：2，banner：3

@property (nonatomic, strong) NSMutableArray *tmpDurations;


+ (void)trackEventForPlayWithAction:(BIActionType)action position:(long)position renderType:(NSString *)renderType defi:(NSString *)defi screenType:(int)screenType ve:(WVRVideoParamEntity *)ve;

+ (void)trackEventForPlayWithAction:(BIActionType)action position:(long)position renderType:(NSString *)renderType defi:(NSString *)defi screenType:(int)screenType ve:(WVRVideoParamEntity *)ve errorCode:(int)errorCode;

+ (void)trackEventForPlayWithAction:(BIActionType)action startPlayDuration:(long)startPlayDuration position:(long)position renderType:(NSString *)renderType defi:(NSString *)defi screenType:(int)screenType ve:(WVRVideoParamEntity *)ve errorCode:(int)errorCode;

@end

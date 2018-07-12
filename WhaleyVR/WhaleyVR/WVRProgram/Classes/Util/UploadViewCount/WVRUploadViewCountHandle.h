//
//  WVRUploadViewCountHandle.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRUploadViewCountHandle : NSObject

/**
 上报浏览次数

 @param srcCode 节目（直播,资讯）code   必填
 @param programType 节目类型，支持 live（直播）, recorded（视频）, webpage（资讯） 必填
 @param videoType 视频格式，支持 2d，3d，vr (资讯类型不必填）
 @param type 上报类型，支持 view（浏览），play（播放），timelong（时长） 必填
 @param sec 观看时长（可选，类型为timelong时才必须有，单位秒）
 @param title 标题（可选，webpage类型必填
 */
+ (void)uploadViewInfoWithCode:(NSString *)srcCode programType:(NSString *)programType videoType:(NSString *)videoType type:(NSString *)type sec:(NSString *)sec title:(NSString *)title;

@end

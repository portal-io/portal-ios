//
//  WVRShareConst.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRShareConst : NSObject

/// 录播全景视频分享URL
+ (NSString *)shareVideoDetailsUrl;

/// 华数电影分享URL
+ (NSString *)share3DMovieDetailsUrl;

/// 专题详情分享URL
+ (NSString *)shareSpecialTopicDetailsUrl;

/// 直播分享URL
+ (NSString *)shareLiveUrl;

/// 专题分享URL
+ (NSString *)shareSpecialTopicUrl;

/// 节目包-合集分享URL
+ (NSString *)shareSpecialProgramPackageUrl;

/// 电视猫分享URL
+ (NSString *)shareSpecialMoreTVUrl;

/// 互动剧分享URL
+ (NSString *)shareInteractionDramaUrl;

+ (NSString *)share2018SpringTopicUrl;
@end

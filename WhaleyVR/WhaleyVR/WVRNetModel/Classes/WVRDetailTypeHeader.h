//
//  WVRDetailTypeHeader.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/26.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRDetailTypeHeader_h
#define WVRDetailTypeHeader_h

/// 蓝精灵后台Program详情类型
typedef NS_ENUM(NSInteger, WVRDetailType) {
    
    WVRDetailTypeVR,
    WVRDetailTypeVRFootball,
    WVRDetailTypeDrama,
    WVRDetailTypeLive,
    WVRDetailTypeLiveFootball,
    WVRDetailTypeWasu3DMovie,
    WVRDetailTypeTVMore2DTV,
    WVRDetailTypeTVMore2DMovie,
};

//全景视频 -VR-
//全景视频足球 -VR-Football
//互动剧 -Drama-
//直播 -Live-
//直播足球 -Live-Football
//华数3D电影 Wasu-3D-Movie
//电视猫2D电视剧 TVMore-2D-TV
//电视猫2D电影 TVMore-2D-Movie

/// 普通录播全景视频
static NSString * const ProgramDetailTypeVR = @"-VR-";

/// 普通录播全景视频足球
static NSString * const ProgramDetailTypeVRFootball = @"-VR-Football";

/// 互动剧
static NSString * const ProgramDetailTypeDrama = @"-Drama-";

/// 直播
static NSString * const ProgramDetailTypeLive = @"-Live-";

/// 直播足球
static NSString * const ProgramDetailTypeLiveFootball = @"-Live-Football";

/// 华数3D电影
static NSString * const ProgramDetailTypeWasu3DMovie = @"Wasu-3D-Movie";

/// 电视猫2D电视剧
static NSString * const ProgramDetailTypeTVMore2DTV = @"TVMore-2D-TV";

/// 电视猫2D电影
static NSString * const ProgramDetailTypeTVMore2DMovie = @"TVMore-2D-Movie";

#endif /* WVRDetailTypeHeader_h */


//wvr_detailType  命名规则：第一个字段代表片源（没有代表默认是微鲸全景视频），第二个字段代表视频类型（programType），第三个字段表示子类型，可以用来细分视频类型。
//
//全景视频 -VR-
//全景视频足球 -VR-Football
//互动剧 -Drama-
//直播 -Live-
//直播足球 -Live-Football
//华数3D电影 Wasu-3D-Movie
//电视猫2DTV TVMore-2D-TV
//电视猫2D电影 TVMore-2D-Movie
//
//
//全景360 VR
//直播 Live
//足球 Football
//华数 Wasu
//电视猫 TVMore
//平面 2D


//
//  WVRNetConst.h
//  WVRNetModel
//
//  Created by Bruce on 2017/9/11.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRNetConst : NSObject

@end


/// 直播状态 枚举

typedef NS_ENUM(NSInteger, WVRLiveStatus) {
    
    WVRLiveStatusNotStart = 0,                  // 直播前
    WVRLiveStatusPlaying,                       // 直播中
    WVRLiveStatusEnd                            // 直播后
};

/// 直播展示横竖屏 枚举

typedef NS_ENUM(NSInteger, WVRLiveDisplayMode) {
    
    WVRLiveDisplayModeVertical,
    WVRLiveDisplayModeHorizontal,
};

/**
 * 推荐元素链接类型
 */

extern NSString * const LINKARRANGETYPE_ARRANGE;                // 自动编排
extern NSString * const LINKARRANGETYPE_PROGRAM;                // 节目
extern NSString * const LINKARRANGETYPE_LIVE;                   // 直播
extern NSString * const LINKARRANGETYPE_H5_OUTER;               // H5外页
extern NSString * const LINKARRANGETYPE_H5_INNER;               // H5内页
extern NSString * const LINKARRANGETYPE_H5_LOCAL;               // H5

extern NSString * const LINKARRANGETYPE_INFORMATION;            // 资讯
extern NSString * const LINKARRANGETYPE_MANUAL_ARRANGE;         // 手动编排（专题）

extern NSString * const LINKARRANGETYPE_CONTENT_PACKAGE;        //节目包_合集
extern NSString * const LINKARRANGETYPE_RECOMMENDPAGE;          // 推荐类型

extern NSString * const LINKARRANGETYPE_MORETVPROGRAM;          // 电视节目

extern NSString * const LINKARRANGETYPE_MOREMOVIEPROGRAM;       // 电视猫电影节目

UIKIT_EXTERN NSString * const LINKARRANGETYPE_DRAMA_PROGRAM ;      // 互动剧跳转类型

extern NSString * const LINKARRANGETYPE_PLAY;                   // 直接播放
extern NSString * const  LINKARRANGETYPE_PLAY_TOPIC;
extern NSString * const LINKARRANGETYPE_SHOW;                   // 秀场类型

extern NSString * const LINKARRANGETYPE_LAUNCH;                 // 跳转入launch

extern NSString * const LINKARRANGETYPE_LIVEORDERLIST;          // 预告列表类型
extern NSString * const LINKARRANGETYPE_SHOWLIST;               // 秀场列表类型

extern NSString * const LINKARRANGETYPE_FOOTBALLLIST ;          // launcher 足球列表类型
extern NSString * const LINKARRANGETYPE_FOOTBALLLIVE;           // launcher 足球 直播

extern NSString * const LINKARRANGETYPE_FOOTBALLHOMEPAGE ;      // launcher 足球首页
extern NSString * const LINKARRANGETYPE_FOOTBALLRECOMMENDPAGE;  // launcher 足球推荐页

UIKIT_EXTERN NSString * const LINKARRANGETYPE_TICKET; //兑换码界面

UIKIT_EXTERN NSString * const LINKARRANGETYPE_REWARD ; //我的奖品界面
/**
 * 推荐类型
 */
extern NSString * const RECOMMENDPAGETYPE_MIX;                  // 混排模式
extern NSString * const RECOMMENDPAGETYPE_TITLE;                // 标题编排
extern NSString * const RECOMMENDPAGETYPE_PAGE;                 // 分页推荐页

/**
 * 节目内容类型
 */
extern NSString *const PROGRAMTYPE_RECORDED;       // 点播
extern NSString *const PROGRAMTYPE_LIVE;           // 直播
extern NSString *const PROGRAMTYPE_MORETV_TV;      // 电视猫电视
extern NSString *const PROGRAMTYPE_MORETV_MOVIE;   // 电视猫电影
extern NSString *const PROGRAMTYPE_ARRANGE;
extern NSString *const PROGRAMTYPE_DRAMA;          // 互动剧
extern NSString *const PROGRAMTYPE_FOOTBALL;       // 足球

extern NSString *const CONTENTTYPE_LIVE_FUN;                     // 直播
extern NSString *const CONTENTTYPE_LIVE_FOOTBALL;                // 直播、足球
extern NSString *const CONTENTTYPE_LIVE_SHOW;                    // 直播、秀场
extern NSString *const CONTENTTYPE_LIVE_CAR;                     // 直播、车展

/**
 * 视频类型
 */
extern NSString *const VIDEO_TYPE_3D;             // 3D电影
extern NSString *const VIDEO_TYPE_VR;             // VR视频
extern NSString *const VIDEO_TYPE_LIVE;           // 直播
extern NSString *const VIDEO_TYPE_MORETV_TV;      // 电视猫电视
extern NSString *const VIDEO_TYPE_MORETV_MOVIE;   // 电视猫电影

/**
 *  跳转类型
 */
extern NSString *const JUMP_TYPE_RECOMMEND;       // 推荐首页
extern NSString *const JUMP_TYPE_CHANNEL_VR;      // 频道-全景视频
extern NSString *const JUMP_TYPE_CHANNEL_3D;      // 频道-3D电影
extern NSString *const JUMP_TYPE_LIVE;            // 直播·预告
extern NSString *const JUMP_TYPE_LIVE_REVIEW;     // 直播回顾

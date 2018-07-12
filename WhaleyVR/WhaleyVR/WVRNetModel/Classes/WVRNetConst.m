//
//  WVRNetConst.m
//  WVRNetModel
//
//  Created by Bruce on 2017/9/11.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRNetConst.h"

@implementation WVRNetConst

@end

/**
 * 推荐元素链接类型
 */

NSString * const LINKARRANGETYPE_ARRANGE = @"linkarrangetype_arrange";                  // 自动编排（二级列表，无站点树）
NSString * const LINKARRANGETYPE_PROGRAM = @"linkarrangetype_program";                  // 节目
NSString * const LINKARRANGETYPE_LIVE = @"linkarrangetype_live";                        // 直播
NSString * const LINKARRANGETYPE_H5_OUTER = @"linkarrangetype_h5_outer";                // H5外页
NSString * const LINKARRANGETYPE_H5_INNER = @"linkarrangetype_h5_inner";                // H5内页
NSString * const LINKARRANGETYPE_H5_LOCAL = @"linkarrangetype_h5_local";

NSString * const LINKARRANGETYPE_INFORMATION = @"linkarrangetype_information";          // 资讯
NSString * const LINKARRANGETYPE_MANUAL_ARRANGE = @"linkarrangetype_manual_arrange";    // 手动编排（专题）

NSString * const LINKARRANGETYPE_CONTENT_PACKAGE = @"linkarrangetype_content_package";  // 节目包（专题）

NSString * const LINKARRANGETYPE_RECOMMENDPAGE = @"linkarrangetype_recommendPage";      // 推荐类型

NSString * const LINKARRANGETYPE_MORETVPROGRAM = @"linkarrangetype_moretvprogram";      // 电视节目
NSString * const LINKARRANGETYPE_MOREMOVIEPROGRAM = @"linkarrangetype_moremovieprogram";  // 电视猫电影节目

NSString * const LINKARRANGETYPE_DRAMA_PROGRAM = @"linkarrangetype_dynamicProgram";     // 互动剧跳转类型

NSString * const LINKARRANGETYPE_PLAY = @"LINKARRANGETYPE_PLAY";                        // 直接播放
NSString * const LINKARRANGETYPE_PLAY_TOPIC = @"LINKARRANGETYPE_PLAY_TOPIC";            // 专题播放

NSString * const LINKARRANGETYPE_SHOW = @"linkarrangetype_show";                        // 秀场类型

NSString * const LINKARRANGETYPE_LAUNCH = @"linkarrangetype_launch";                    // 跳转入launch类型

//直播
NSString * const LINKARRANGETYPE_LIVEORDERLIST = @"linkarrangetype_liveorderList";       // 预告列表类型
NSString * const LINKARRANGETYPE_SHOWLIST = @"linkarrangetype_showList";                 // 秀场列表类型

NSString * const LINKARRANGETYPE_FOOTBALLLIST = @"linkarrangetype_footballList";         // 足球列表类型

NSString * const LINKARRANGETYPE_FOOTBALLLIVE = @"linkarrangetype_footballlive";         // 足球

NSString * const LINKARRANGETYPE_FOOTBALLHOMEPAGE = @"linkarrangetype_footballHomePage";
NSString * const LINKARRANGETYPE_FOOTBALLRECOMMENDPAGE = @"linkarrangetype_footballRecommendPage";

NSString * const LINKARRANGETYPE_TICKET = @"linkarrangetype_change_code";

NSString * const LINKARRANGETYPE_REWARD = @"linkarrangetype_my_reward";


/**
 * 推荐类型
 */
NSString * const RECOMMENDPAGETYPE_MIX = @"recommendPageType_mix";      // 混排模式
NSString * const RECOMMENDPAGETYPE_TITLE = @"recommendPageType_title";  // 标题编排
NSString * const RECOMMENDPAGETYPE_PAGE = @"recommendPageType_page";    // 分页推荐页

/**
 * 视频类型
 */
NSString *const VIDEO_TYPE_3D = @"3d";                  // 3D电影
NSString *const VIDEO_TYPE_VR = @"vr";                  // VR视频
NSString *const VIDEO_TYPE_LIVE = @"live";              // VR直播
NSString *const VIDEO_TYPE_MORETV_TV = @"moretv_tv";    // 电视猫电视
NSString *const VIDEO_TYPE_MORETV_MOVIE = @"moretv_2d"; // 电视猫电影

/**
 * 节目内容类型
 */
NSString *const PROGRAMTYPE_RECORDED = @"recorded";             // 点播
NSString *const PROGRAMTYPE_LIVE = @"live";                     // 直播
NSString *const PROGRAMTYPE_MORETV_TV = @"moretv_tv";           // 电视猫电视
NSString *const PROGRAMTYPE_MORETV_MOVIE = @"moretv_movie";     // 电视猫电影
NSString *const PROGRAMTYPE_ARRANGE = @"arrange";               //
NSString *const PROGRAMTYPE_DRAMA = @"dynamic";                 // 互动剧
NSString *const PROGRAMTYPE_FOOTBALL = @"football";             // 足球

NSString *const CONTENTTYPE_LIVE_FUN = @"live_fun";                     // 直播
NSString *const CONTENTTYPE_LIVE_FOOTBALL = @"live_football";           // 直播、足球
NSString *const CONTENTTYPE_LIVE_SHOW = @"live_show";                   // 直播、秀场
NSString *const CONTENTTYPE_LIVE_CAR = @"live_car";                     // 直播、车展

NSString *const JUMP_TYPE_RECOMMEND = @"shouyetuijian-RecommendPage";       // 推荐首页
NSString *const JUMP_TYPE_CHANNEL_VR = @"vrfaxianye";                       // 频道-全景视频
NSString *const JUMP_TYPE_CHANNEL_3D = @"moviefaxianye";                    // 频道-3D电影
NSString *const JUMP_TYPE_LIVE = @"live_home";                              // 直播·预告
NSString *const JUMP_TYPE_LIVE_REVIEW = @"livereview";                      // 直播回顾

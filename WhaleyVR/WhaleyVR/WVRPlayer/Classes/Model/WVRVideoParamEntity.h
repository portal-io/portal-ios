//
//  WVRVideoParamEntity.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/14.
//  Copyright © 2017年 Snailvr. All rights reserved.

// Player与Program解耦，本类是所有WVRVideoEntity的父类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WhaleyVRPlayer/WVRDataParam.h>
#import "WVRPlayUrlModel.h"
#import "WVRMediaDto.h"
#import "WVRDetailModel.h"
@class WVRVideoBIEntity;

typedef void (^complationBlock)(void);

/// 无机位信息时，默认的机位key
extern NSString *const kDefault_Camera_Stand;

@interface WVRVideoParamEntity : NSObject

/**
 当前视频流类型
 */
@property (assign, nonatomic) WVRStreamType streamType;

@property (nonatomic, strong) WVRDetailModel *detailModel;

/***********  视频起播时需要传递初始化URL（从服务端获取）  ***********/

/**
 普通全景视频、3D华数电影、单链接直播
 */
@property (nonatomic, copy) NSString *needParserURL;

/// 非解析URL对应的清晰度
@property (nonatomic, copy) NSString *needParserURLDefinition;

/**
 视频播放链接数组(播放失败重试机制，电视猫2D电视 录播VR视频)
 */
@property (nonatomic, strong) NSArray<NSString *> *playUrls;

/******************** 初始化附加参数 *******************/

@property (nonatomic, copy) NSString *videoTitle;   // 播放的视频名称
@property (nonatomic, copy) NSString *sid;          // 必传，节目sid

/// == isChargeable,  != isCharged
@property (nonatomic, assign) int isChargeable;     // 是否需要付费，必传
@property (nonatomic, assign) BOOL isCharged;     // 是否需要付费，必传
@property (nonatomic, assign) long price;           // 如果付费必传
@property (nonatomic, assign) long freeTime;        // 如果是付费必传
@property (nonatomic, copy) NSString *relatedCode;  // 点播付费相关，有的话必传

/// 3.1.2新增 是否为足球
@property (nonatomic, assign) BOOL isFootball;

/// 直播清晰度 或 足球机位 链接数组
@property (nonatomic, strong) NSArray<WVRMediaDto *> *mediaDtos;

/// 默认机位
@property (nonatomic, copy) NSString *defaultStandType;

/// 当前播放的足球视频机位
@property (nonatomic, readonly) NSString *currentStandType;

@property (nonatomic, strong) WVRVideoBIEntity *biEntity;

/*************** 公开给外部的一些API、参数 ****************/

#pragma mark - getter

/// 使用二维字典(NSMutableDictionary)存储机位列表，及某个机位对应的清晰度列表
@property (nonatomic, readonly) NSDictionary<NSString *, NSDictionary<NSString *, WVRPlayUrlModel *> *> *parserdUrlModelDict;

/// 当前是否有可切换的清晰度
@property (nonatomic, readonly) BOOL canChangeDefinition;

/// 是否有可播放的链接
@property (nonatomic, readonly) BOOL haveValidUrlModel;

/// 当前机位对应的linkDict
@property (nonatomic, readonly) NSDictionary<NSString *, WVRPlayUrlModel *> *currentLinkDict;

/// 防止第一个链接解析后不能播放，后续解析下一个链接
@property (nonatomic, readonly) BOOL canTryNextPlayUrl;

// 专题页、电视剧视频连播 子类实现
@property (nonatomic, readonly) BOOL canPlayNext;       // 是否还能播放下一个

@property (nonatomic, readonly) WVRPlayUrlModel *curUrlModel;   // 当前播放的链接对应的 playURLModel
@property (nonatomic, copy) NSString *curDefinition;        // 当前清晰度 HD、SD、ST, 直播子类已重写get方法
@property (nonatomic, copy) NSString *renderTypeStr;        // 当前播放链接对应的renderType, 直播子类已重写get方法

@property (nonatomic, copy) NSString * behavior;
@property (nonatomic, copy) NSString * bgPic;

#pragma mark - getter

/// 是否为VIP机位
- (BOOL)isCameraStandVIP;

- (WVRRenderType)renderTypeForFootballCurrentCameraStand;

/// 是否为蘑菇源需要解析
- (BOOL)isNeedParserURL;

- (BOOL)isDefaultVRMode;
- (void)setDefaultVRMode:(BOOL)isVRMode;
- (BOOL)isDefault_SD;
- (void)setDefault_SD:(BOOL)isSD;
- (NSNumber *)defaultbitType;

/// 在1G内存的设备上分屏模式只能播放非4K视频
- (BOOL)canSwitchVR;

/// 连播时下一个视频的标题
- (NSString *)nextPlayVideoTitle;

#pragma mark - external func

/// 播放链接解析
- (void)parserPlayUrl:(complationBlock)complation;

/**
 是否为普通类型视频
 
 @return 非特殊渲染类型
 */
- (BOOL)isCommonRenderTypeVideo;

/// 是否为普通类型视频
+ (BOOL)isCommonVideoForRenderType:(NSString *)renderType;

/// 视频起播URL
- (NSURL *)playUrlForStartPlay;

/// 特定的清晰度对应链接，如果为空时会返回 视频起播URL
- (NSURL *)playUrlForDefinition:(NSString *)definition;

/// 下一个清晰度对应的URL
- (NSURL *)playUrlChangeToNextDefinition;

/// 在没有其他可解析的链接时（playUrls == nil），播放失败后尝试下一个清晰度
- (NSURL *)tryNextDefinitionWhenPlayFaild;

/*******************   *********************/

/**
 连播，播放下一个，请先调用canPlayNext做判断，该操作会改变self并且不可逆
 
 @return 改变过链接的videoEntity对象
 */
- (instancetype)nextVideoEntity;

/**
 电视剧重试链接，请先调用canTryNextPlayUrl做判断，该操作会改变self并且不可逆
 
 @return 改变过链接的videoEntity对象
 */
- (instancetype)nextPlayUrlVE;

/// 能否切换到指定机位
- (BOOL)canChangeToCameraStand:(NSString *)standType;

/**
 切换到指定机位，请先调用canChangeToFootballCameraStand做判断，该操作会改变self并且不可逆
 
 @return 改变过链接的videoEntity对象
 */
- (instancetype)changeCameraStand:(NSString *)standType;

/**
 清晰度类型转枚举
 
 @param defi  ST SD HD
 @return 0 1 2
 */
+ (DefinitionType)definitionToType:(NSString *)defi;


/**
 清晰度类型对应的清晰度按钮title
 
 @param defi ST SD HD
 @return 高清 超清 原画
 */
+ (NSString *)definitionToTitle:(NSString *)def;

+ (WVRRenderType)renderTypeForStreamType:(WVRStreamType)streamType definition:(NSString *)definition renderTypeStr:(NSString *)renderTypeStr;

+ (WVRRenderType)renderTypeForDefinitionStr:(NSString *)definition renderTypeStr:(NSString *)renderTypeStr;

+ (WVRRenderType)renderTypeForRenderTypeStr:(NSString *)renderTypeStr;

#pragma mark - 子类继承方法

/// 仅限子类调用
- (void)setCurUrlModel:(WVRPlayUrlModel *)curUrlModel;

/// 仅限子类调用
- (void)setParserdUrlModelDict:(NSDictionary<NSString *,NSDictionary<NSString *,WVRPlayUrlModel *> *> *)parserdUrlModelDict;

/// 仅限子类，外部谨慎调用
- (NSString *)checkNextDefinition;

/// 仅限子类，外部谨慎调用
- (WVRPlayUrlModel *)playUrlModelForDefinition:(NSString *)defi;

@end


// videoEntity的附加属性
@interface WVRVideoBIEntity : NSObject

@property (nonatomic, copy) NSString *videoTag;     // 普通全景、华数电影
@property (nonatomic, assign) long totalTime;       // 可选，总时长，单位是秒
@property (nonatomic, assign) long playCount;       // 可选，播放次数
@property (nonatomic, assign) float bitrate;        // BI埋点，临时存储变量
@property (nonatomic, assign) BOOL isPlayError;     // 播放器error后会赋值给它

/// 控制跳转足球， 对应model的type字段
@property (nonatomic, copy) NSString * contentType;

/// 互动剧，存储当前节点是否为最后一个剧情
@property (nonatomic, assign) BOOL curIsLastNode;

/// 当前是互动剧起播剧情（其他子节点关联到startNode的情况不算）
@property (nonatomic, assign) BOOL curIsFirstNode;

@end

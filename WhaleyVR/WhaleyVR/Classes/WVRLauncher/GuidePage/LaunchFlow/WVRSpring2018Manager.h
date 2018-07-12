//
//  WVRSpring2018Manager.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 2018新春活动管理类，之后可删除

#import <Foundation/Foundation.h>

#define TAG_SPRINGBTN (201800)
@class WVRSpring2018InfoModel;

@interface WVRSpring2018Manager : NSObject

@property (nonatomic, strong) WVRSpring2018InfoModel *infoModel;

@property (nonatomic, assign) int leftCount;

@property (nonatomic, assign) BOOL isValid;

+ (instancetype)shareInstance;

/// App启动时请求接口获取新春活动信息
+ (void)checkForSpring2018Status;

/// 请求剩余抽奖次数
+ (void)checkForSpringLeftCount;

/// 分享渠道 qq, weixin, weibo
+ (void)reportForSharePlatform:(NSString *)platform block:(void(^)(int count))block;

/// 添加新春活动首页入口
+ (void)addHomePageEntryForSpring2018;

/// 检测2018新春活动是否在有效期
+ (BOOL)checkSpring2018Valid;

@end


@interface WVRSpring2018InfoModel: NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger nowTime;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) NSInteger enableTime;
@property (nonatomic, assign) NSInteger disableTime;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *relCodes;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger status;

@end

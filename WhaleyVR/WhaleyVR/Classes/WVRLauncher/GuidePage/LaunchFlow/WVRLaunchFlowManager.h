//
//  WVRLaunchFlowManager.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/19.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 启动流程管理
// (应用启动阶段)启动-广告位-(应用内展示阶段)强制升级提示-活动海报-推荐升级提示-内容推荐浮层
// 应用启动阶段放在AppDelegate管理，应用内展示阶段由本类来管理

#import <Foundation/Foundation.h>
#import "WVRProgramDefine.h"
#import "WVRRecommendItemModel.h"

@interface WVRLaunchFlowManager : NSObject

@property (nonatomic, strong) NSArray<WVRRecommendItemModel *> *recommendModels;

@property (nonatomic, strong) UIImageView *tmpImageView; 

+ (instancetype)shareInstance;

- (instancetype)init NS_UNAVAILABLE;

/// 通过类型查找数据，如果找不到，就返回一个空Model，防止RAC无法监测变化
- (WVRRecommendItemModel *)findModelByType:(WVRRecommndAreaType)type;

/// 应用启动时调用 初始化获取数据
- (void)buildData;

/// 展示第二阶段（应用内展示阶段）
- (void)shouldShowSecondStage;

/// 展示升级提示
- (void)dealWithUpdateVersion;

/// 处理是否展示 内容推荐浮层
- (void)dealWithContentRecommend;

///// 展示下一步, 最好最后一步时才调用，其他步骤都有独立方法
- (void)shouldShowNextStep;

@end

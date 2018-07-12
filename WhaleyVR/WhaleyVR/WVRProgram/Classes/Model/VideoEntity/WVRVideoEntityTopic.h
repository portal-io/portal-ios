//
//  WVRVideoEntityTopic.h
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 专题、节目包VideoEntity

#import "WVRVideoEntity.h"

@interface WVRVideoEntityTopic : WVRVideoEntity

/**
 专题、节目包 连续播放时参数
 */
@property (nonatomic, weak) NSArray<WVRItemModel *> *detailItemModels;

// 专题页、电视剧视频连播 子类实现
@property (nonatomic, readonly) WVRItemModel *currentItemModel;

@property (nonatomic, copy) NSString *code;         // 连播时必传，节目list中唯一标识

/// Model转为字典后识别类型
@property (nonatomic, assign) BOOL isVideoEntityTopic;

@end

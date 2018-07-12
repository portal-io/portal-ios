//
//  WVRVideoEntityMoreTV.h
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 电视猫电视剧或电影VideoEntity

#import "WVRVideoEntity.h"

@interface WVRVideoEntityMoreTV : WVRVideoEntity

/**
 电视剧 连续播放时参数
 */
@property (nonatomic, weak) NSArray<WVRItemModel *> *detailItemModels;

@property (nonatomic, readonly) BOOL isMoreMovie;

@property (nonatomic, readonly) WVRItemModel *currentItemModel;

@property (nonatomic, copy) NSString *code;         // 连播时必传，节目list中唯一标识

#pragma mark - external func 

/**
 为电视剧找出最佳清晰度链接
 
 @return 最佳清晰度 URL
 */
- (NSURL *)bestDefinitionUrl;


@end

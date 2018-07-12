//
//  WVRSortModel.h
//  WhaleyVR
//
//  Created by Snailvr on 16/7/23.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYModel.h"
@class WVRExtendData;

@interface WVRSortItemModel : NSObject

/// 唯一识别符
@property (copy, nonatomic) NSString  *sid;
/// 标题
@property (copy, nonatomic) NSString  *title;
/// 描述 预留字段
@property (copy, nonatomic) NSString  *desc;
/// 图片链接
@property (copy, nonatomic) NSString  *image;
/// 评分 预留字段
@property (copy, nonatomic) NSString  *score;

@property (nonatomic, copy) NSString *resource_code;

// 3D电影独有字段
@property (copy, nonatomic) NSArray< NSString*> *director;
@property (copy, nonatomic) NSString  *actor;
@property (copy, nonatomic) NSString  *tags;
@property (copy, nonatomic) NSString  *videoType;
@property (copy, nonatomic) NSString  *area;

// 互动剧新增
@property (nonatomic, copy) NSString *programType;
@property (nonatomic, assign) BOOL isDrama;         // 是否为互动剧（为了方便取用添加的属性）

// request

@property (nonatomic, copy) NSString *item_isHd;

@property (nonatomic, copy) NSString *item_year;

@property (nonatomic, strong) NSArray<NSString *> *item_tag;

@property (nonatomic, strong) NSArray *item_director;

@property (nonatomic, copy) NSString *item_subscriptUrl;

@property (nonatomic, copy) NSString *item_subscriptCode;

@property (nonatomic, copy) NSString *link_type;

@property (nonatomic, copy) NSString *item_episodeCount;

@property (nonatomic, copy) NSString *item_duration;

@property (nonatomic, copy) NSString *item_epstitle;

@property (nonatomic, copy) NSString *item_sid;

@property (nonatomic, strong) NSArray *item_cast;

@property (nonatomic, copy) NSString *item_icon_w222;

@property (nonatomic, copy) NSString *item_icon_w100;

@property (nonatomic, copy) NSString *item_episode;

@property (nonatomic, copy) NSString *item_videoType;

@property (nonatomic, copy) NSString *item_icon_w182;

@property (nonatomic, copy) NSString *item_icon1;

@property (nonatomic, copy) NSString *item_icon2;

@property (nonatomic, copy) NSString *item_title;

@property (nonatomic, copy) NSString *item_score;

@property (nonatomic, copy) NSString *item_actor;

@property (nonatomic, copy) NSString *item_type;

@property (nonatomic, strong) WVRExtendData *extendData;

@property (nonatomic, copy) NSString *item_source;

@property (nonatomic, copy) NSString *item_information;

@property (nonatomic, copy) NSString *item_contentType;

@property (nonatomic, copy) NSString *item_area;

@end


@interface WVRExtendData : NSObject

@property (nonatomic, copy) NSString *editor_title;

@property (nonatomic, copy) NSString *editor_poster;

@property (nonatomic, copy) NSString *editor_tag;

@property (nonatomic, copy) NSString *editor_sid;

@end

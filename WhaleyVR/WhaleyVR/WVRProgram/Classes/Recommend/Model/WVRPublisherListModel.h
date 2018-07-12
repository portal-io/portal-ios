//
//  WVRPublisherListModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 发布者更新节目列表

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class WVRPublisherListItemModel, WVRPublisherListStat;

typedef NS_ENUM(NSInteger, PublisherSortType) {
    PublisherSortTypePublishTime,               // 发布时间逆序
    PublisherSortTypePlayCount,                 // 播放次数逆序
};

@interface WVRPublisherListModel : NSObject

@property (nonatomic, assign) long pageNumber;
@property (nonatomic, assign) long totalCount;
@property (nonatomic, assign) long totalPages;
@property (nonatomic, strong) NSArray<WVRPublisherListItemModel *> *programs;

+ (void)requestForPublisherListForCp:(NSString *)cpCode sortType:(PublisherSortType)sortType atPage:(int)page block:(void (^)(WVRPublisherListModel * model, NSError *error))block;

@end


@interface WVRPublisherListItemModel : NSObject

@property (nonatomic, copy) NSString *centerPic;
@property (nonatomic, copy) NSString *relatedCode;
@property (nonatomic, copy) NSString *customUrl;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, copy) NSString *radius;
@property (nonatomic, copy) NSString *tagCode;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *bigPic;
@property (nonatomic, copy) NSString *lunboPic;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *cpCode;
@property (nonatomic, copy) NSString *superscript;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *actors;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *programType;
@property (nonatomic, copy) NSString *smallPic;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) long Id;
@property (nonatomic, assign) long duration;
@property (nonatomic, assign) long publishTime;
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) long updateTime;
@property (nonatomic, assign) long pubStatus;
@property (nonatomic, assign) long isChargeable;
@property (nonatomic, assign) long status;
@property (nonatomic, strong) WVRPublisherListStat *stat;

@end


@interface WVRPublisherListStat : NSObject

@property (nonatomic, assign) long viewCount;
@property (nonatomic, assign) long playSeconds;
@property (nonatomic, assign) long playCount;

@end

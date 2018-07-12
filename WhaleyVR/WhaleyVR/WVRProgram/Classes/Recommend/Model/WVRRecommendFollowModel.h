//
//  WVRRecommendFollowModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 推荐关注

#import <Foundation/Foundation.h>
//#import "WVRRecommendItemModel.h"
#import "WVRPublisherListModel.h"
#import "WVRPublisherDetailModel.h"
@class WVRRecommendFollowItemModel;

@interface WVRRecommendFollowModel : NSObject

@property (nonatomic, strong) WVRRecommendFollowItemModel *headerModel;
@property (nonatomic, strong) NSArray<WVRRecommendFollowItemModel *> *listArray;

+ (void)requestForRecommendFollowList:(void (^)(WVRRecommendFollowModel * model, NSError *error))block;

@end


@interface WVRRecommendFollowItemModel: NSObject

@property (nonatomic, assign) long cpFollow;        // 是否已关注该发布者
@property (nonatomic, assign) long isFavorite;
@property (nonatomic, assign) long updateTime;
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) long publishTime;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *linkArrangeValue;
@property (nonatomic, copy) NSString *linkArrangeType;
@property (nonatomic, copy) NSString *recommendAreaCode;
@property (nonatomic, copy) NSString *secondJumpType;

@property (nonatomic, copy) NSString *picUrl_;            // 映射字段

@property (nonatomic, strong) WVRPublisherModel *cpInfo;

@property (nonatomic, strong) NSArray<WVRPublisherListItemModel *> *cpProgramDtos;

@end

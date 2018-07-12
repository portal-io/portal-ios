//
//  WVRAttentionModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 我的关注Model

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class WVRAttentionStat, WVRAttentionLatestUpdated, WVRAttentionCpList;

@interface WVRAttentionModel: NSObject

@property (nonatomic, assign) NSInteger                             pageNumber;
@property (nonatomic, assign) NSInteger                             totalPages;
@property (nonatomic, assign) NSInteger                             totalCount;
@property (nonatomic, strong) NSArray<WVRAttentionLatestUpdated *> *latestUpdated;
@property (nonatomic, strong) NSArray<WVRAttentionCpList *>        *cpList;

// 我的关注列表
+ (void)requestForMyFollowListForPage:(int)page block:(void (^)(WVRAttentionModel * model, NSError *error))block;

// 关注/取消关注
+ (void)requestForFollow:(NSString *)cpCode status:(int)status block:(APIResponseBlock)block;

@end


@interface WVRAttentionStat: NSObject

@property (nonatomic, copy  ) NSString *videoType;
@property (nonatomic, copy  ) NSString *programType;
@property (nonatomic, copy  ) NSString *srcDisplayName;
@property (nonatomic, copy  ) NSString *srcCode;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger playSeconds;
@property (nonatomic, assign) NSInteger pubStatus;

@end


@interface WVRAttentionLatestUpdated: NSObject

@property (nonatomic, assign) NSInteger               Id;
@property (nonatomic, copy  ) NSString              * name;
@property (nonatomic, copy  ) NSString              * displayName;
@property (nonatomic, copy  ) NSString              * subtitle;
@property (nonatomic, copy  ) NSString              * smallPic;
@property (nonatomic, copy  ) NSString              * cpCode;
@property (nonatomic, copy  ) NSString              * code;
@property (nonatomic, assign) NSInteger               createTime;
@property (nonatomic, assign) NSInteger               publishTime;
@property (nonatomic, strong) WVRAttentionStat      * stat;
@property (nonatomic, copy  ) NSString              * headPic;
@property (nonatomic, assign) NSInteger               updateTime;

@property (nonatomic, copy  ) NSString *videoType;
@property (nonatomic, copy  ) NSString *programType;

@property (nonatomic, readonly) NSString *sid;

@end


@interface WVRAttentionCpList: NSObject

@property (nonatomic, assign) NSInteger               Id;
@property (nonatomic, assign) NSInteger               fansCountFake;
@property (nonatomic, copy  ) NSString              * backgroundPic;
@property (nonatomic, assign) NSInteger               createTime;
@property (nonatomic, copy  ) NSString              * code;
@property (nonatomic, assign) NSInteger               available;
@property (nonatomic, copy  ) NSString              * headPic;
@property (nonatomic, assign) NSInteger               fansCount;
@property (nonatomic, assign) NSInteger               updateTime;
@property (nonatomic, copy  ) NSString              * name;
@property (nonatomic, copy  ) NSString              * info;

@end

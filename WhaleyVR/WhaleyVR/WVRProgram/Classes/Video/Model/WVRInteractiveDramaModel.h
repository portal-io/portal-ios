//
//  WVRInteractiveDramaModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/9.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧详情 Model

#import "WVRItemModel.h"
#import "WVRAPIManagerDataReformer.h"
#import "WVRStatModel.h"
#import "WVRDramaNodeModel.h"
@class WVRDramaContentPrivider;

@interface WVRDramaDetailDataReformer : NSObject <WVRAPIManagerDataReformer>

@end


@interface WVRInteractiveDramaModel : WVRItemModel

@property (nonatomic, copy) NSString *originString;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *curEpisode;
@property (nonatomic, copy) NSString *descriptionStr;

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *language;

@property (nonatomic, strong) WVRStat *stat;

@property (nonatomic, copy) NSString *pubStatus;
@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, copy) NSString *smallPic;
@property (nonatomic, copy) NSString *lunboPic;

@property (nonatomic, copy) NSString *bigPic;
@property (nonatomic, copy) NSString *vipPic;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *superscript;
@property (nonatomic, copy) NSString *tagCode;
@property (nonatomic, copy) NSString *totalEpisode;
@property (nonatomic, copy) NSString *typeName;

#pragma mark - Publisher

@property (nonatomic, strong) WVRDramaContentPrivider *contentProvider;

@property (nonatomic, assign, readonly) int isFollow;
@property (nonatomic, copy, readonly) NSString *cpCode;
@property (nonatomic, assign, readonly) long fansCount;
@property (nonatomic, copy, readonly) NSString *headPic;

#pragma mark - node info

@property (nonatomic, strong) WVRDramaNodeModel *startNode;
@property (nonatomic, strong) NSArray<WVRDramaNodeModel *> *nodes;

- (NSString *)introduction;

@end


@interface WVRDramaContentPrivider : NSObject

@property (nonatomic , copy) NSString         * headPic;
@property (nonatomic , copy) NSString         * cpCode;
@property (nonatomic , copy) NSString         * name;
@property (nonatomic , assign) int              isFollow;
@property (nonatomic , assign) long             fansCount;

@end

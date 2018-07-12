//
//  WVRProgramBIModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRBIManager.h"

typedef NS_ENUM(NSInteger, BIInteractionType) {
    
    BIInteractionTypeGift,
    BIInteractionTypeDanmu,
};

typedef NS_ENUM(NSInteger, BIJumpFromType) {
    
    BIJumpFromTypeHome,
    BIJumpFromTypeTopic,
};

@interface WVRProgramBIModel : NSObject

@property (nonatomic, copy) NSString *currentPageId;
@property (nonatomic, copy) NSString *nextPageId;
@property (nonatomic, copy) NSString *biPageName;
@property (nonatomic, copy) NSString *biPageId;

@property (nonatomic, strong) NSDictionary *otherParams; 

@property (nonatomic, copy) NSString *nextPageCode;
@property (nonatomic, copy) NSString *nextPageName;

@property (nonatomic, copy) NSString *videoFormat;      // 专题没有这个字段，直接不赋值就行
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, assign) int isChargeable;

// MARK: - 互动剧字段
@property (nonatomic, copy) NSString *currentDramaId;       // 当前
@property (nonatomic, copy) NSString *currentDramaTitle;
@property (nonatomic, copy) NSString *dramaId;              // 已选择
@property (nonatomic, copy) NSString *dramaTitle;

/// YES则表示为单个节目或直播，NO表示为节目包、合集、专题
@property (nonatomic, assign) BOOL isProgram;

//+ (void)trackEventForTopicWithAction:(BITopicActionType)action topicId:(NSString *)topicId topicName:(NSString *)topicName videoSid:(NSString *)videoSid videoName:(NSString *)videoName index:(NSInteger)index isChargeable:(BOOL)isChargeable isProgramSet:(BOOL)isProgramSet;

+ (void)trackEventForDetailWithAction:(BIDetailActionType)action sid:(NSString *)sid name:(NSString *)name;

+ (void)recommendTabSelect:(kTabBarIndex)selectedIndex;

/// 浏览页面
+ (void)trackEventForBrowsePage:(WVRProgramBIModel *)biModel;

/// 浏览结束，记录时长
+ (void)trackEventForBrowseEnd:(WVRProgramBIModel *)biModel;

/// 记录节目-专题分享事件
+ (void)trackEventForShare:(WVRProgramBIModel *)biModel;

/// 访问路径相关（点击跳转的时候埋点）
+ (void)trackEventForJump:(WVRProgramBIModel *)biModel;

/// 互动剧选择剧集埋点
+ (void)trackEventForDramaSelect:(WVRProgramBIModel *)biModel;

/// 弹幕|礼物 点击发送埋点
+ (void)trackEventForInteraction:(BIInteractionType)interactionType biModel:(WVRProgramBIModel *)biModel;

/// 广告页面埋点
+ (void)trackEventForAD:(WVRProgramBIModel *)biModel;

@end

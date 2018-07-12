//
//  WVRDramaPlayStrategy.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 策略类，承载互动剧播放逻辑

#import <Foundation/Foundation.h>
#import "WVRInteractiveDramaModel.h"
#import "WVRPlayerHelper.h"
#import "WVRPlayerDramaUIManager.h"

typedef NS_ENUM(NSInteger, kDramaSelectStatus) {
    
    kDramaSelectStatusWaitSelect,       // 等待用户选择
    kDramaSelectStatusPlayDefault,      // 应该播默认剧情
    kDramaSelectStatusNothing,          // 没有后续剧情
};


@protocol WVRDramaPlayStrategyProtocol <NSObject>

/// 播放下一个剧情，isUserSelect 是否为用户选择 NO表示自动播放了默认剧情
- (void)playNextNode:(WVRDramaNodeModel *)node isUserSelect:(BOOL)isUserSelect;

@end


@interface WVRDramaPlayStrategy : NSObject

@property (nonatomic, weak) id<WVRDramaPlayStrategyProtocol> delegate;

@property (nonatomic, weak) WVRInteractiveDramaModel *detailModel;
@property (nonatomic, weak) WVRPlayerHelper *vPlayer;
@property (nonatomic, weak) WVRPlayerDramaUIManager *playerUI;

@property (nonatomic, weak, readonly) WVRDramaNodeModel *currentNode;

@property (nonatomic, weak, readonly) WVRDramaNodeModel *lastNode;

@property (nonatomic, assign, readonly) BOOL curIsLastNode;
@property (nonatomic, assign, readonly) BOOL curIsFirstNode;

/// 历史结点数组，存储用户播放剧情轨迹
@property (nonatomic, strong, readonly) NSMutableArray *nodeTrack;

/// 起播时设置起播Node
- (void)setCurrentNodeForStart:(WVRDramaNodeModel *)node;

/// Unity返回时设置剧情节点播放链
- (void)setNodeTrackArray:(NSArray<NSString *> *)nodeTrack;

///// Unity返回时设置当前播放剧情节点
//- (void)setUnityCurrentNode:(NSString *)nodeCode;

/// syncScrubber调用
- (void)checkTipForSyncScrubber;

/// seekComplate调用
- (void)checkTipForSeek:(long)seekTime;

/// 节点播放结束
- (BOOL)dealWithNodePlayCompletion;

/// 获取接下来的剧情结点 给UIManager
//- (NSMutableDictionary *)getNextNodesInfo;

@end

//
//  WVRSpringBoxView.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 2018新春活动抽奖宝箱

#import <UIKit/UIKit.h>
#import "WVRPlayerViewDelegate.h"
#import "WVRUINotAutoShowProtocol.h"

@protocol WVRSpringBoxViewDelegate <NSObject>

- (void)lotteryForSpring2018Card;

- (void)springBoxTapAction:(NSTimeInterval)time;

@end


@interface WVRSpringBoxView : UIView

@property (nonatomic, weak) id<WVRPlayerViewDelegate> realDelegate;

@property (nonatomic, weak) id<WVRSpringBoxViewDelegate> boxDelegate;

@property (atomic, assign) BOOL isLandscape;

// MARK: - Constraints

/// 显示在父视图左边
- (void)makeConstraintsToLeft;

///// 显示在父视图右边
//- (void)makeConstraintsToRight;

// MARK: - external func

- (void)updateCountDown:(long)time isShow:(BOOL)isShow;

/// 抽卡次数用完
- (void)leftCountUseUp;

/// 未登录时的状态
- (void)refreshUINotLogin;

- (void)boxStopAnimation;

/// 防止控制器切换时动画导致的cpu占用100%的问题
- (void)sleepForControllerChanged;

/// 控制器切换回当前播放器所在Controller
- (void)resumeForControllerChanged;

- (void)setNotAutoShow:(BOOL)notAutoShow;

@end

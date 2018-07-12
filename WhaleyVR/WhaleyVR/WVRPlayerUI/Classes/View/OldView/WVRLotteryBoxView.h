//
//  WVRLotteryBoxView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewDelegate.h"
#import "WVRUINotAutoShowProtocol.h"

@interface WVRLotteryBoxView : UIView<WVRUINotAutoShowProtocol>

@property (nonatomic, weak) id<WVRPlayerViewLiveDelegate> liveDelegate;
@property (nonatomic, weak) id<WVRPlayerViewDelegate> realDelegate;

@property (atomic, assign) BOOL isLandscape;

- (BOOL)closeByUser;

- (void)updateCountDown:(long)time isShow:(BOOL)isShow;

- (void)boxStopAnimation;

- (void)setBoxSwitch:(BOOL)isOpen;

/// 防止控制器切换时动画导致的cpu占用100%的问题
- (void)sleepForControllerChanged;

/// 控制器切换回当前播放器所在Controller
- (void)resumeForControllerChanged;

- (void)setNotAutoShow:(BOOL)notAutoShow;

@end

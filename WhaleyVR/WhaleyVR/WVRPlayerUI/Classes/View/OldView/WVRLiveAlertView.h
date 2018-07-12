//
//  WVRLiveAlertView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/1/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewDelegate.h"

@interface WVRLiveAlertView : UIView

// 点击title，展示基本信息
//+ (instancetype)showWithTitle:(NSString *)title playCount:(long)playCount adress:(NSString *)address intro:(NSString *)intro;

/// 中奖
+ (instancetype)showWithImage:(NSString *)image title:(NSString *)title lotteryTime:(int)time delegate:(id<WVRPlayerViewLiveDelegate>)delegate;

/// 未中奖
+ (instancetype)showWithLotteryTime:(int)time;

/// 播放器控件不自动隐藏
- (BOOL)playerUINotAutoHide;

@property (nonatomic, weak) id<WVRPlayerViewLiveDelegate> liveDelegate;

@end

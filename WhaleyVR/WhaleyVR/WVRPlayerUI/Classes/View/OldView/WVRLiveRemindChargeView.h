//
//  WVRLiveRemindChargeView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 直播播放界面付费提示（无试看）

#import <UIKit/UIKit.h>
#import "YYText.h"

@protocol WVRLiveRemindChargeViewDelegate<NSObject>

- (void)payForVideo;
- (void)goRedeemPage;

@end


@interface WVRLiveRemindChargeView : UIView

@property (nonatomic, weak) id<WVRLiveRemindChargeViewDelegate> viewDelegate;

- (instancetype)initWithPrice:(long)price endTime:(long)endTime isProgramSet:(BOOL)isProgramSet;

/// 播放器控件不自动隐藏
- (BOOL)playerUINotAutoHide;
- (void)updateRemindLabelWithEndTime:(long)endTime;

@end

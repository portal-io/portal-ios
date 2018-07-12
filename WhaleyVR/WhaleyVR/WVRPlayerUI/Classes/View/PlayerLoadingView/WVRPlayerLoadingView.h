//
//  WVRPlayerLoadingView.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/22.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器加载视图，显示网速

#import "WVRPlayViewCell.h"
#import "WVRPlayViewCellProtocol.h"

@interface WVRPlayerLoadingView : WVRPlayViewCell<WVRPlayViewCellProtocol>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 初始化操作，创建后处于隐藏状态，需要时显示时调用startAnimating方法
- (instancetype)initWithContentView:(UIView *)contentView isVRMode:(BOOL)vrMode;

- (void)startAnimating:(BOOL)isVRMode;
- (void)stopAnimating;
- (void)updateNetSpeed:(long)speed;

- (void)switchVR:(BOOL)isVR;

- (void)updateTip:(NSString *)tip;

/// 播放器控件不自动隐藏
- (BOOL)playerUINotAutoHide;

@end

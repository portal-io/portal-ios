//
//  WVRUnityPlayerView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRUnityPlayerBaseView.h"

@interface WVRUnityPlayerView : WVRUnityPlayerBaseView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

// 每次展示Unity界面的时候刷新一下
- (void)reloadSubviews;

// 开始隐藏控件计时
- (void)scheduleHideControls;

- (void)resetForUnityHide;

@end

//
//  WVRUnityPlayerCenterView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRUnityPlayerBaseView.h"

@interface WVRUnityPlayerCenterView : WVRUnityPlayerBaseView

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithViewModel:(WVRUnityPlayerViewModel *)viewModel;

/// 与其他控件隐藏状态相反
- (BOOL)playerUIHideOpposite;

@end

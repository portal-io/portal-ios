//
//  WVRBlurImageView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRBlurImageView : UIImageView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image NS_UNAVAILABLE;

- (instancetype)initWithContainerView:(UIView *)containerView imgUrl:(NSString *)imgUrl;

/// 播放器控件不自动隐藏
- (BOOL)playerUINotAutoHide;

@end

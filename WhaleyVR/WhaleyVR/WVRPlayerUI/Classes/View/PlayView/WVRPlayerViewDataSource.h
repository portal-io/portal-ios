//
//  WVRPlayerViewDataSource.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerBottomViewProtocol.h"
@class WVRPlayerView;

@protocol WVRPlayerViewDataSource <NSObject>

@optional
- (UIView *)topViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)bottomViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)leftViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)rightViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)loadingViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)centerViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)backAnimationViewForPlayerView:(WVRPlayerView *)playerView;

- (UIView *)giftContainerViewForPlayerView:(WVRPlayerView *)playerView;

- (CGFloat)heightForTopView;

- (CGFloat)heightForBottomView;

- (CGFloat)widthForLeftView;

- (CGFloat)widthForRightView;

@end

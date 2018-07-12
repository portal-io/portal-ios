//
//  WVRUnityPlayerView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityPlayerView.h"
#import "WVRUINotAutoShowProtocol.h"
#import "WVRUnityPlayerTopView.h"
#import "WVRUnityPlayerBottomView.h"
#import "WVRUnityPlayerCenterView.h"

#import "WVRUnityPlayerLiveTopView.h"
#import "WVRUnityPlayerLiveBottomView.h"

#import "WVRUnityPlayerLocalBottomView.h"

#import "WVRUnityPlayerTopToast.h"

@interface WVRUnityPlayerView ()<UIGestureRecognizerDelegate, WVRUnityPlayerViewModelDelegate>

@property (nonatomic, weak) UIView *placeHolderView;    // forin循环的时候会用到

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, weak) UIImageView *bgView;

@property (nonatomic, weak) WVRUnityPlayerTopToast *toastView;

@property (nonatomic, strong, readonly) NSMutableArray<UIView *> *hideArray;

/// 播放界面UI是否是隐藏状态
@property (atomic, assign) BOOL subviewsHidden;

@end


@implementation WVRUnityPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self configSelf];
        [self createGesture];
    }
    return self;
}

- (void)configSelf {
    
    [self.viewModel setDelegate:self];
    _hideArray = [NSMutableArray array];
    self.frame = CGRectMake(0, 0, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), MIN(SCREEN_WIDTH, SCREEN_HEIGHT));
}

- (void)createGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _tap = tap;
}

- (void)reloadSubviews {
    
    for (UIView *view in self.subviews) {
        if (view != _bgView) {
            [view removeFromSuperview];
        }
    }
    
    if (!_tap) {
        [self createGesture];
    }
    [[self bgView] setImage:[UIImage imageNamed:@"player_icon_unityCover2"]];
    
    WVRUnityPlayerCenterView *centerV = [[WVRUnityPlayerCenterView alloc] initWithViewModel:self.viewModel];
    [self addSubview:centerV];
    
    if (self.viewModel.streamType == STREAM_VR_LIVE) {
        
        WVRUnityPlayerLiveTopView *topV = [[WVRUnityPlayerLiveTopView alloc] initWithViewModel:self.viewModel];
        [self addSubview:topV];
        
        WVRUnityPlayerLiveBottomView *bottomV = [[WVRUnityPlayerLiveBottomView alloc] initWithViewModel:self.viewModel];
        [self addSubview:bottomV];
        
    } else {
        
        WVRUnityPlayerTopView *topV = [[WVRUnityPlayerTopView alloc] initWithViewModel:self.viewModel];
        [self addSubview:topV];
        
        if (self.viewModel.streamType == STREAM_VR_LOCAL) {
            
            WVRUnityPlayerLocalBottomView *bottomV = [[WVRUnityPlayerLocalBottomView alloc] initWithViewModel:self.viewModel];
            [self addSubview:bottomV];
        } else {
            
            WVRUnityPlayerBottomView *bottomV = [[WVRUnityPlayerBottomView alloc] initWithViewModel:self.viewModel];
            [self addSubview:bottomV];
        }
    }
}

// MARK: - WVRUnityPlayerViewModelDelegate

- (void)showToast {
    
    [self.toastView showToast:self.viewModel];
}

- (void)hideToast {
    
    [self.toastView hideToast:self.viewModel];
}

// MARK: - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (gestureRecognizer == _tap) {
        return (touch.view == self || touch.view == _bgView);
    }
    return YES;
}

#pragma mark - getter

- (BOOL)isContorlsHide {
    
    return _subviewsHidden;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        imgV.image = [UIImage imageNamed:@"player_icon_unityCover2"];
        imgV.userInteractionEnabled = YES;
        
        [imgV addGestureRecognizer:_tap];
        
        [self addSubview:imgV];
        _bgView = imgV;
    }
    return _bgView;
}

- (WVRUnityPlayerTopToast *)toastView {
    if (!_toastView) {
        float gap = fitToWidth(35);
        WVRUnityPlayerTopToast *toast = [[WVRUnityPlayerTopToast alloc] initWithFrame:CGRectMake(gap, 0-gap, self.width - 2*gap, gap)];
        
        [self addSubview:toast];
        _toastView = toast;
    }
    return _toastView;
}

#pragma mark - private func

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)time/60, (int)time%60];
}

// View点击事件
- (void)toggleControls {
    
    NSLog(@"toggleControls");
    [self controlsShowHideAnimation:![self isContorlsHide]];
}

- (void)scheduleHideControls {
    
    if (!self.superview) { return; }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];    // 清空schedule队列
    [self performSelector:@selector(hideControlsFast) withObject:nil afterDelay:kHideToolBarTime];
}

- (void)hideControlsFast {
    
    [self controlsShowHideAnimation:YES];
}

- (void)controlsShowHideAnimation:(BOOL)isHide {
    
    if (isHide) {
        
        _subviewsHidden = YES;
        
        for (UIView *view in self.subviews) {
            
            BOOL notAutoHide = NO;
            if ([view respondsToSelector:@selector(playerUINotAutoHide)]) {
                
                id<WVRUINotAutoShowProtocol> cur = (id<WVRUINotAutoShowProtocol>)view;
                notAutoHide = [cur playerUINotAutoHide];
                
            } else if ([view respondsToSelector:@selector(playerUIHideOpposite)]) {
                
                id<WVRUINotAutoShowProtocol> cur = (id<WVRUINotAutoShowProtocol>)view;
                BOOL opposite = [cur playerUIHideOpposite];
                if (opposite) {
                    view.hidden = NO;
                    [_hideArray addObject:view];
                    continue;
                }
            }
            
            if (view.hidden == NO && !notAutoHide && view != _bgView) {
                view.hidden = YES;
                [_hideArray addObject:view];
            }
        }
        
        [_bgView setImage:[UIImage imageNamed:@"player_icon_unityCover1"]];
        
    } else {
        
        _subviewsHidden = NO;
        NSArray * curHideArray = [_hideArray copy];
        for (UIView *view in curHideArray) {
            
            BOOL notAutoShow = NO;
            if ([view respondsToSelector:@selector(playerUINotAutoShow)]) {
                
                id<WVRUINotAutoShowProtocol> cur = (id<WVRUINotAutoShowProtocol>)view;
                notAutoShow = [cur playerUINotAutoShow];
                
            } else if ([view respondsToSelector:@selector(playerUIHideOpposite)]) {
                
                id<WVRUINotAutoShowProtocol> cur = (id<WVRUINotAutoShowProtocol>)view;
                BOOL opposite = [cur playerUIHideOpposite];
                if (opposite) {
                    view.hidden = YES;
                    [_hideArray removeObject:view];
                    continue;
                }
            }
            
            if (notAutoShow || view == _bgView) {
                continue;
            }
            view.hidden = NO;
            [_hideArray removeObject:view];
        }
        
        [_bgView setImage:[UIImage imageNamed:@"player_icon_unityCover2"]];
        
        [self scheduleHideControls];
    }
}

- (void)resetForUnityHide {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _subviewsHidden = NO;
    [self removeGestureRecognizer:_tap];
    _tap = nil;
    [self removeFromSuperview];
}

@end

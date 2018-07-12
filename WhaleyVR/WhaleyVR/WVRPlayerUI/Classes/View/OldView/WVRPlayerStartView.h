//
//  WVRPlayerStartView.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/26.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器起播界面，有背景图，显示本界面的时候不允许切换单双屏

#import <UIKit/UIKit.h>
#import "WVRPlayerViewHeader.h"

@protocol WVRPlayerStartViewDelegate <NSObject>

- (void)actionRetry;
- (void)actionGotoBuy;
- (void)actionRetryTryAndSee;
/// 重新开始看（从头播放）
- (void)actionRestart;

- (void)backOnClick:(UIButton *)sender;

@optional
/// 专题连播 播放下一个
- (void)actionPlayNext;

@end


@interface WVRPlayerStartView : UIView

@property (nonatomic, weak) id<WVRPlayerStartViewDelegate> realDelegate;

@property (nonatomic, assign) BOOL gHidenBackgroundImage;

@property (nonatomic, assign) BOOL gHidenVRBackBtn;

- (instancetype)initWithTitleText:(NSString *)title containerView:(UIView *)container;

/// 分屏模式下 播放结束后重新播放
- (instancetype)initWithContainerView:(UIView *)container;

/// 手机模式下 播放结束后重新播放
- (instancetype)initForRestartWithTitleText:(NSString *)title containerView:(UIView *)container;

/// 手机模式下 专题连播提示
- (instancetype)initForTopicWithTitleText:(NSString *)title nextTitle:(NSString *)nextTitle containerView:(UIView *)container;

- (void)onErrorWithMsg:(NSString *)msg code:(NSInteger)code;

- (void)dismiss;

- (BOOL)isLoading;

//- (void)checkAnimation;                       // 此方法只是给横屏模式动画无效使用
- (void)resetStatus:(NSString *)title;        // 针对电视剧，第一集播放错误，直接点击其他剧集

/// 免费试看结束后引导付费
- (void)resetStatusToPaymentWithTrail:(BOOL)canTrail price:(NSString *)price;

- (void)viewWillRotationToVertical;

/// 播放器控件不自动隐藏
- (BOOL)playerUINotAutoHide;

- (void)hidenbackBtn:(BOOL)isHiden;

@end

//
//  WVRPlayerView.h
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewDelegate.h"
#import "YYText.h"
#import "WVRPlayerLoadingView.h"
#import "WVRPlayViewViewModel.h"

typedef NS_ENUM(NSInteger, WVRPlayerViewStyle) {
    
    WVRPlayerViewStyleHalfScreen,       // 详情页半屏播放
    WVRPlayerViewStyleLandscape,        // 普通模式全屏播放
    WVRPlayerViewStyleLive,             // 直播竖屏全屏
//    WVRPlayerViewStyleLiveTrailer,      // 直播预告，无界面，预留
};

#import "WVRPlayerViewDataSource.h"
#import "WVRPlayerViewProtocol.h"
#import "WVRUINotAutoShowProtocol.h"


@interface WVRPlayerView : UIView<WVRPlayerViewProtocol, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id<WVRPlayerViewDataSource> dataSource;

@property (nonatomic, strong, readonly) WVRPlayViewViewModel * gViewModel;

//@property (nonatomic, assign) BOOL isFootball;

@property (nonatomic, readonly) WVRPlayerViewStyle  viewStyle;

/// videoInfo 映射自WVRVideoEntity及其子类
@property (nonatomic, strong) NSDictionary  *ve;

@property (nonatomic, readonly) BOOL isVRMode;

@property (nonatomic, assign) CGFloat mOffsetY;

/// 非直播节目 全屏时UI锁定状态
@property (nonatomic, assign) BOOL lockStatus;

// /// 控件自动隐藏的状态
//@property (nonatomic, assign) BOOL hiddenStatus;

@property (nonatomic, weak) id<WVRPlayerViewDelegate> realDelegate;


- (instancetype)initWithFrame:(CGRect)frame style:(WVRPlayerViewStyle)style videoEntity:(NSDictionary *)ve delegate:(id)delegate;

/// 初始化操作之一，可由子类重写
- (void)setDelegate:(id)delegate;
- (void)createGesture;

//MARK: - Player

/**
 播放界面销毁，把动画都停掉
 */
- (void)execDestroy;
- (void)execWaitingPlay;    // 重新开始、播放下一个视频，显示startView

- (void)execError:(NSString *)message code:(NSInteger)code;
- (void)execPreparedWithDuration:(long)duration;
/// 播放中
- (void)execPlaying;
/// 非活跃状态（暂停）
- (void)execSuspend;
/// 卡顿
- (void)execStalled;

- (void)execDownloadSpeedUpdate:(long)speed;

// MARK: - payment
// 点播付费节目免费时间结束，需要提示付费
- (void)execFreeTimeOverToCharge:(long)freeTime duration:(long)duration;
- (void)execPaymentSuccess;

// MARK: - Rotation
- (void)screenRotationCompleteWithStatus:(BOOL)isLandscape;

// MARK: - 子类继承

- (void)drawUI;

/// UI控件隐藏倒计时 此API只为个别UI控件重发时间时重新计时隐藏事件
- (void)scheduleHideControls;
- (void)controlsShowHideAnimation:(BOOL)isHide;
- (void)toggleControls;

- (BOOL)isContorlsHide;

/// 重置分屏状态，变为单屏播放
- (void)resetVRMode;

- (void)shouldShowCameraTipView;

//- (void)setIsLandscape:(BOOL)isLandscape;     // 预留方法，暂不对外开放
- (WVRStreamType)streamType;

//@property (nonatomic, weak) WVRPlayerLoadingView *loadingView;


@end

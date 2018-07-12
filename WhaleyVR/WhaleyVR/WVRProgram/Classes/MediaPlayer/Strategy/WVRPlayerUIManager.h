//
//  WVRPlayerUIManager.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.

// PlayerUI与控制器交互的桥梁，解放控制器

#import <Foundation/Foundation.h>
#import "WVRVideoEntity.h"
#import "WVRItemModel.h"
#import "WVRPlayerView.h"
#import "WVRPlayerHelper.h"
#import "WVRPlayerUIProtocol.h"

#import "WVRPlayerViewHeader.h"
#import "WVRPlayerBottomViewDelegate.h"
#import "WVRPlayerTopViewDelegate.h"

#import "WVRPlayerViewAdapter.h"
#import "WVRPlayBottomCellViewModel.h"
#import "WVRPlayTopCellViewModel.h"
#import "WVRPlayLeftCellViewModel.h"
#import "WVRPlayRightCellViewModel.h"
#import "WVRPlayViewViewModel.h"
#import "WVRPlayLoadingCellViewModel.h"

typedef NS_ENUM(NSInteger, WVRPlayerUIViewStatus) {
    WVRPlayerUIViewStatusHalfVertical,       // 竖向半屏
    WVRPlayerUIViewStatusFullVertical,       // 竖向全屏
    WVRPlayerUIViewStatusFullHorizontal,      // 横向全屏
    WVRPlayerUIViewStatusHalfHorizontal,      // 横向半屏，目前没有这种状态
};

typedef NS_ENUM(NSInteger, WVRPlayerUnityBackDeal) {
    
    WVRPlayerUnityBackDealNothing,      // 无需处理
    WVRPlayerUnityBackDealRotation,     // 旋转至竖屏/横屏
    WVRPlayerUnityBackDealExit,         // 退出界面
};

@protocol WVRPlayerUIManagerDelegate <NSObject>

@required
- (void)actionOnExit;

- (void)actionRetry;        // 此代理在startView里面调用

- (void)changeToVRMode;

//MARK: - pay

- (void)actionGotoBuy;
- (BOOL)isCharged;
- (BOOL)actionCheckLogin;

//MARK: - player

- (void)actionPlay:(BOOL)isRepeat;
- (void)actionPause;
- (void)actionResume;

@optional

- (void)actionSetControlsVisible:(BOOL)isControlsVisible;

- (void)rotaionAnimations:(BOOL)isLandspace;

/// 播放结束后重头开始播放
- (void)actionRestart;

/// 专题连播 播放下一个
- (void)actionPlayNext;

@end


@protocol WVRPlayerUIManagerGoUnityDelegate <NSObject>

- (void)rotationForBackFormUnity;

@end


@interface WVRPlayerUIManager : NSObject<WVRPlayerViewDelegate, WVRPlayerUIManagerProtocol, WVRPlayerTopViewDelegate, WVRPlayerBottomViewDelegate>

/// 当前播放器的控制器或者播放器持有者
@property (nonatomic, weak) id<WVRPlayerUIManagerDelegate> uiDelegate;

/// 当前播放器的数据存储对象
@property (nonatomic, weak) WVRVideoEntity *videoEntity;

/// 当前播放视频的详情数据
@property (nonatomic, weak) WVRItemModel *detailBaseModel;

/// 当前播放器的主要交互控件
@property (nonatomic, weak) WVRPlayerView *playerView;

/// 当前播放器单双屏状态
@property (nonatomic, assign) BOOL isNotMonocular;

/// 标记当前界面的横竖屏状态，对外只读
@property (nonatomic, assign) BOOL isLandscape;

/// 跳转到Unity播放器, 只在点击按钮的时候赋值为YES
@property (nonatomic, assign) BOOL isGoUnity;

@property (nonatomic, assign) BOOL isGoUnityFootball;

/// 进入Unity时播放器状态：半屏 全屏 横屏 竖屏
@property (nonatomic, assign) WVRPlayerUIViewStatus tmpPlayerViewStatus;

/// 退出Unity后做什么处理
@property (nonatomic, assign) WVRPlayerUnityBackDeal dealWithUnityBack;

/// 从Unity回来后的播放状态
@property (nonatomic, strong) NSDictionary *unityBackParams;

/****************/
@property (nonatomic, strong) WVRPlayerViewAdapter * gPlayerViewAdapter;

@property (nonatomic, strong) NSMutableDictionary * gPlayAdapterOriginDic;

@property (nonatomic, strong) WVRPlayViewViewModel * gPlayViewViewModel;

@property (nonatomic, strong) WVRPlayTopCellViewModel * gTopCellViewModel;

@property (nonatomic, strong) WVRPlayBottomCellViewModel * gBottomCellViewModel;

@property (nonatomic, strong) WVRPlayLeftCellViewModel * gLeftCellViewModel;

@property (nonatomic, strong) WVRPlayRightCellViewModel * gRightCellViewModel;

@property (nonatomic, strong) WVRPlayLoadingCellViewModel * gLodingCellViewModel;

@property (nonatomic, strong) WVRPlayLoadingCellViewModel * gVRLoadingCellViewModel;

@property (nonatomic, strong) WVRPlayViewCellViewModel * gVRModeBackBtnAnimationViewModel;
/****************/
/// 当前播放过程使用的播放器组件
@property (nonatomic, weak) WVRPlayerHelper *vPlayer;

/**
 业务性较强，容易变更的播放器UI组件
 */
@property (nonatomic, strong) NSMutableArray<id <WVRPlayerUIProtocol>> *components;

/// playerView当前状态
@property (nonatomic, assign) WVRPlayerToolVStatus gPlayViewStatus;

/// 初始化播放器交互UI, live已重写该方法
- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView;

/* 添加业务性较强的UI组件 */
- (void)addComponents;

/* 移除业务性较强的UI组件 */
- (void)removeUIComponents;

/**
 向UI组件传递事件

 @param eventName 事件名称
 @param params 所需参数
 */
- (void)deliveryEventToComponents:(NSString *)eventName params:(NSDictionary *)params;

// MARK: - getter

/// 表示视频正在起播、已失败、已试看结束
- (BOOL)isHaveStartView;

// MARK: - Player

- (void)execDestroy;
- (void)execWaitingPlay;    // 重新开始、播放下一个视频，显示startView
- (void)execUpdateDefiBtnTitle;

- (void)execError:(NSString *)message code:(NSInteger)code;
- (void)execPreparedWithDuration:(long)duration;

- (void)execPlaying;

/// 暂停（非活跃状态）
- (void)execSuspend;

- (void)execResume;

- (void)execPause;
/// 卡顿
- (void)execStalled;
- (void)execCompletion;
- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration;
- (void)execDownloadSpeedUpdate:(long)speed;

- (void)execUpdateCountdown;

- (void)execSleepForControllerChanged;
- (void)execResumeForControllerChanged;

- (void)resetVRMode;

// MARK: - payment
// 点播付费节目免费时间结束，需要提示付费
- (void)execFreeTimeOverToCharge:(long)freeTime;
- (void)execPaymentSuccess;

- (void)execupdateLoadingTip:(NSString *)tip;

- (void)execCheckStartViewAnimation;

- (void)tryOtherDefinitionForPlayFailed;

// MARK: - 子类继承

- (NSString *)definitionToTitle:(NSString *)defi;

- (NSString *)parserStreamtypeForFullBottomCellNibName;
- (NSString *)parserStreamtypeForFullTopCellNibName;

/// 播放器当前横竖屏状态 在viewDidAppear之后调用
- (WVRPlayerUIViewStatus)playerUIViewStatus;

@end


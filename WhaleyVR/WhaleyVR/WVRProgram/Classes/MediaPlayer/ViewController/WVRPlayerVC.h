//
//  WVRPlayerVC.h
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/18.
//  Copyright © 2016年 Snailvr. All rights reserved.
//
// 全屏播放控制器基类，请勿直接使用
// 目前支持全屏播放的类型有：点播VR全景视频、直播全景视频、本地缓存全景视频

#import <UIKit/UIKit.h>
#import "WVRBaseViewController.h"
#import "WVRVideoDetailVCModel.h"
//#import "WVRLiveDetailModel.h"
#import "WVRPlayerHelper.h"

#import "WVRPlayerUIManager.h"
#import "WVRPlayerViewHeader.h"

@class WVRVideoEntity;

@interface WVRPlayerVC : WVRBaseViewController<WVRPlayerUIManagerDelegate, WVRPlayerHelperDelegate>

@property (nonatomic, assign) BOOL isDestroy;

@property (nonatomic, assign) WVRPlayerToolVStatus gPlayViewstatus;

/// use for from other page
@property (nonatomic, assign) long curPosition;

/// use for from unity play
@property (nonatomic, copy) NSString *curDefinition;

#pragma mark - 子类公共属性

/// set get 方法会被子类重写
@property (nonatomic, strong) WVRVideoEntity *videoEntity;

@property (nonatomic, strong) WVRItemModel *detailBaseModel;

@property (nonatomic, assign) BOOL isCharged;                // 已付费

@property (nonatomic, strong) WVRPlayerHelper *vPlayer;
//@property (nonatomic, weak  ) WVRPlayerView   *wPlayerView;

@property (nonatomic, strong, readonly) WVRPlayerUIManager *playerUI;

@property (nonatomic, assign) long syncScrubberNum;

@property (nonatomic, assign) BOOL isFootball;

@property (nonatomic, assign) BOOL notDealFromLogin;

@property (nonatomic, strong) NSDictionary *unityBackParam;

#pragma mark - 暴露给子类的API

/// 初始化播放器数据
- (void)buildInitData;

- (void)createLayoutView;
- (void)registerObserverEvent;

- (void)syncScrubber;

/// onlyDealWithPaid 只有在结果为已支付的状态时才执行后续操作
- (void)requestForPaied:(BOOL)onlyDealWithPaid;

- (void)dealWithDetailData:(WVRItemModel *)model;
- (void)checkFreeTime;
- (void)dealWithPaymentOver;

- (void)controlOnPause;
- (void)controlOnResume;

- (void)changeToVRMode;

- (void)dismissViewController;

- (void)startTimer;
- (void)stopTimer;

- (void)readyToPlay;

- (void)appDidEnterBackground:(NSNotification *)notification;
- (void)appWillEnterForeground:(NSNotification *)notification;

- (void)parserBaseData:(WVRItemModel*)model;

- (void)installAfterViewLoadForbanner;

- (void)dealForParserErrorWithError:(NSString *)err code:(int)code;

- (void)setPlayerStatusForDisappear;

@end

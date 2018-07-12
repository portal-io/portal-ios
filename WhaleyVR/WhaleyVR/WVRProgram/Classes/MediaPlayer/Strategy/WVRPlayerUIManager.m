//
//  WVRPlayerUIManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.

// PlayerUI与控制器交互的桥梁，解放控制器
// 时间交互，UI点击事件埋点

#import "WVRPlayerUIManager.h"
#import "WVRPlayerViewDelegate.h"
#import <Masonry/Masonry.h>

#import "WVRPlayerViewFullS.h"
#import "WVRPlayerViewDetail.h"

#import "WVRPlayerStartView.h"

@interface WVRPlayerUIManager() {
    
    long _videoDuration;
    NSDictionary *_veDict;
}

@end


@implementation WVRPlayerUIManager

- (instancetype)init {//init方法中不要初始化一些和数据相关的事项，想videoEntiy这参数此时是空的（规定一些步骤来初始化 ）
    self = [super init];
    if (self) {
        [self setComponents:[NSMutableArray array]];
        
    }
    return self;
}

- (void)installAfterSetParams
{
    @weakify(self);
    [RACObserve(self, isNotMonocular) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.isNotMonocular) {
            self.gVRLoadingCellViewModel.vrStatus = WVRPlayerToolVStatusVR;
            self.gLodingCellViewModel.vrStatus = WVRPlayerToolVStatusVR;
        } else {
            self.gVRLoadingCellViewModel.vrStatus = WVRPlayerToolVStatusNotVR;
            self.gLodingCellViewModel.vrStatus = WVRPlayerToolVStatusNotVR;
        }
    }];
}

/// 详情数据返回后更新组件，子类可重写该方法
- (void)updateAfterSetParams {
    
    [self addComponents];
}

- (WVRPlayViewViewModel *)gPlayViewViewModel
{
    if (!_gPlayViewViewModel) {
        _gPlayViewViewModel = [[WVRPlayViewViewModel alloc] init];
//        @weakify(self);
        [RACObserve(_gPlayViewViewModel, viewIsHiden) subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
            [self updatePlayViewHidenStatus:_gPlayViewViewModel.viewIsHiden];
        }];
    }
    return _gPlayViewViewModel;
}

- (WVRPlayerViewAdapter *)gPlayerViewAdapter
{
    if (!_gPlayerViewAdapter) {
        _gPlayerViewAdapter = [[WVRPlayerViewAdapter alloc] init];
        [_gPlayerViewAdapter loadData:self.gPlayAdapterOriginDic];
    }
    return _gPlayerViewAdapter;
}

- (NSMutableDictionary *)gPlayAdapterOriginDic
{
    if (!_gPlayAdapterOriginDic) {
        _gPlayAdapterOriginDic = [[NSMutableDictionary alloc] init];
        _gPlayAdapterOriginDic[kTOP_PLAYVIEW] = self.gTopCellViewModel;
        _gPlayAdapterOriginDic[kBOTTOM_PLAYVIEW] = self.gBottomCellViewModel;
        _gPlayAdapterOriginDic[kLEFT_PLAYVIEW] = self.gLeftCellViewModel;
        _gPlayAdapterOriginDic[kRIGHT_PLAYVIEW] = self.gRightCellViewModel;
        _gPlayAdapterOriginDic[kLOADING_PLAYVIEW] = self.gLodingCellViewModel;
        _gPlayAdapterOriginDic[kCHANGETOVRMODE_ANIMATION_PLAYVIEW] = self.gVRModeBackBtnAnimationViewModel;
        
    }
    return _gPlayAdapterOriginDic;
}

- (WVRPlayLoadingCellViewModel *)gVRLoadingCellViewModel
{
    if (!_gVRLoadingCellViewModel) {
        _gVRLoadingCellViewModel = [[WVRPlayLoadingCellViewModel alloc] init];
        _gVRLoadingCellViewModel.cellNibName = @"WVRPlayVRCenterViewCell";
        _gVRLoadingCellViewModel.vrStatus = WVRPlayerToolVStatusNotVR;
        _gVRLoadingCellViewModel.delegate = self;
        _gVRLoadingCellViewModel.playStatus = WVRPlayerToolVStatusPreparing;
        _gVRLoadingCellViewModel.gTitle = self.videoEntity.videoTitle;
        @weakify(self);
        [RACObserve([self videoEntity], videoTitle) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            _gVRLoadingCellViewModel.gTitle = [self videoEntity].videoTitle;
        }];
        [RACObserve([self videoEntity], isChargeable) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([self videoEntity].isChargeable==1) {
                _gVRLoadingCellViewModel.gPayStatus = WVRPlayerToolVStatusNeedPay;
            }else{
                _gVRLoadingCellViewModel.gPayStatus = WVRPlayerToolVStatusFree;
            }
        }];
    }
    return _gVRLoadingCellViewModel;
}

- (WVRPlayLoadingCellViewModel *)gLodingCellViewModel
{
    if (!_gLodingCellViewModel) {
        _gLodingCellViewModel = [[WVRPlayLoadingCellViewModel alloc] init];
        _gLodingCellViewModel.cellNibName = @"WVRPlayerLoadingView";
        _gLodingCellViewModel.delegate = self;
        _gLodingCellViewModel.gHidenBack = YES;
        _gLodingCellViewModel.gHidenVRBackBtn = YES;
        
        _gLodingCellViewModel.playStatus = WVRPlayerToolVStatusPreparing;//preparing状态startView才会出现
        _gLodingCellViewModel.gTitle = self.videoEntity.videoTitle;
        @weakify(self);
        [RACObserve([self videoEntity], videoTitle) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            _gLodingCellViewModel.gTitle = [self videoEntity].videoTitle;
        }];
        [RACObserve([self videoEntity], isChargeable) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([self videoEntity].isChargeable==1) {
                _gLodingCellViewModel.gPayStatus = WVRPlayerToolVStatusNeedPay;
            }else{
                _gLodingCellViewModel.gPayStatus = WVRPlayerToolVStatusFree;
            }
        }];
    }
    return _gLodingCellViewModel;
}

- (WVRPlayViewCellViewModel *)gVRModeBackBtnAnimationViewModel
{
    if (!_gVRModeBackBtnAnimationViewModel) {
        _gVRModeBackBtnAnimationViewModel = [[WVRPlayViewCellViewModel alloc] init];
        _gVRModeBackBtnAnimationViewModel.cellNibName = @"WVRPlayVRModeBackBtnAnimationView";
        _gVRModeBackBtnAnimationViewModel.height = HEIGHT_TOP_VIEW_DEFAULT;
        _gVRModeBackBtnAnimationViewModel.animationStatus = WVRPlayerToolVStatusAnimationComplete;
        @weakify(self);
        [RACObserve(_gVRModeBackBtnAnimationViewModel, animationStatus) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateAnimationStatus:_gVRModeBackBtnAnimationViewModel.animationStatus];
        }];
    }
    return _gVRModeBackBtnAnimationViewModel;
}

- (void)dealloc {
    
    [self.playerView execDestroy];
    [self removeUIComponents];
}

// live 已经重写该方法
- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView {
    
    BOOL isFullScreen = [self.uiDelegate isKindOfClass:NSClassFromString(@"WVRPlayerVC")];
    
    WVRPlayerViewStyle style = isFullScreen ? WVRPlayerViewStyleLandscape : WVRPlayerViewStyleHalfScreen;
    float height = containerView.height;
    float width = containerView.width;
    CGRect rect = CGRectMake(0, 0, MAX(width, height), MIN(width, height));
    
    NSDictionary *veDict = [[self videoEntity] yy_modelToJSONObject];
    WVRPlayerView *view = nil;
    if (isFullScreen) {
        view = [[WVRPlayerViewFullS alloc] initWithFrame:rect style:style videoEntity:veDict delegate:self];
    } else {
        view = [[WVRPlayerViewDetail alloc] initWithFrame:rect style:style videoEntity:veDict delegate:self];
    }
    
    [containerView addSubview:view];
    self.playerView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(view.superview);
    }];
    
    return view;
}

- (void)addComponents {
    [self removeUIComponents];      // 防止重复添加组件
    
}

- (void)removeUIComponents {
    for (id<WVRPlayerUIProtocol> component in self.components) {
        [component removeController];
    }
    [self.components removeAllObjects];
}

- (void)deliveryEventToComponents:(NSString *)eventName params:(NSDictionary *)params {

    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] init];
    event.name = eventName;
    event.params = params;

    for (id<WVRPlayerUIProtocol> controller in self.components) {
        WVRPlayerUIEventCallBack *callBack = [controller dealWithEvent:event];
        if (callBack.isIntercept) {
            break;
        }
    }
}

- (void)setPlayerView:(WVRPlayerView *)playerView {
    _playerView = playerView;
    
    playerView.realDelegate = self;
}

#pragma mark - WVRPlayerUIManagerProtocol

- (void)updatePayStatus:(WVRPlayerToolVStatus)status
{
    self.gVRLoadingCellViewModel.gPayStatus = status;
    self.gLodingCellViewModel.gPayStatus = status;
    self.gTopCellViewModel.gPayStatus = status;
    self.gLeftCellViewModel.gPayStatus = status;
    self.gRightCellViewModel.gPayStatus = status;
    self.gBottomCellViewModel.gPayStatus = status;
}

- (void)updateVRStatus:(WVRPlayerToolVStatus)status
{
    self.gVRLoadingCellViewModel.vrStatus = status;
    self.gLodingCellViewModel.vrStatus = status;
}

- (void)updatePlayStatus:(WVRPlayerToolVStatus)status
{
    self.gPlayViewStatus = status;
    self.gVRLoadingCellViewModel.playStatus = status;
    self.gLodingCellViewModel.playStatus = status;
    self.gPlayViewViewModel.playStatus = status;
    self.gTopCellViewModel.playStatus = status;
    self.gBottomCellViewModel.playStatus = status;
    self.gLeftCellViewModel.playStatus = status;
    self.gRightCellViewModel.playStatus = status;
}

/// 协议方法，本类请勿调用
- (WVRPlayerUIEventCallBack *)dealWithEvent:(WVRPlayerUIEvent *)event {
    
    WVRPlayerUIEventCallBack *callback = nil;
    
    SEL sel = NSSelectorFromString([event.name stringByAppendingString:@":"]);
    
    switch (event.receivers) {
        case PlayerUIEventReceiverComponent:
            // 事件分发，无需回调
            [self deliveryEventToComponents:event.name params:event.params];
            break;
        case PlayerUIEventReceiverManager:
            if ([self respondsToSelector:sel]) {
                callback = [self performSelector:sel withObject:event.params];
            }
            break;
        case PlayerUIEventReceiverVC:
            if ([self.uiDelegate respondsToSelector:sel]) {
                callback = [self.uiDelegate performSelector:sel withObject:event.params];
            }
            break;
        default:
            break;
    }
    
    return callback;
}

- (NSString *)parserStreamtypeForFullBottomCellNibName
{
    NSString * cellNibName = nil;
    cellNibName = [self recordProgramCellNibName];
    return cellNibName;
}

- (NSString *)recordProgramCellNibName
{
    NSString * cellNibName = @"WVRPlayerFullSBottomView";
    switch (self.videoEntity.streamType) {
        case STREAM_VR_VOD:
            if (self.videoEntity.isFootball) {
                
                cellNibName = @"WVRPlayerFullSFootBallBottomView";
            } else {
                cellNibName = @"WVRPlayerFullSBottomView";
            }
            break;
        case STREAM_2D_TV:
            cellNibName = @"WVRPlayerFullSBottomView2DTV";
            break;
        case STREAM_3D_WASU:
            cellNibName = @"WVRPlayerFullSBottomView3DWasu";
            break;
        case STREAM_VR_LOCAL:
            cellNibName = @"WVRPlayerFullSBottomViewLocal";
            break;
        case STREAM_VR_LIVE:
            // live单独处理
            break;
    }
    return cellNibName;
}

- (NSString *)parserStreamtypeForFullTopCellNibName
{
    NSString * cellNibName = @"WVRPlayerTopView";
    
    return cellNibName;
}

#pragma mark - WVRPlayerViewDelegate

- (BOOL)isOnError {
    
    return [self.vPlayer isPlayError];
}

- (BOOL)isPrepared {
    
    return [self.vPlayer isPrepared];
}

- (BOOL)isWaitingForPlay {
    
    if (!self.vPlayer.isValid) {
        return YES;
    }
    if (![self.vPlayer isOnPrepared]) {
        return YES;
    }
    if ([self.vPlayer isComplete]) {
        return YES;
    }
    if ([self.vPlayer isPlayError]) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)actionGetVideoInfo:(BOOL)needRefresh {
    
    if (needRefresh || !_veDict) {
        
        _veDict = [self.videoEntity yy_modelToJSONObject];
    }
    
    return _veDict;
}

- (BOOL)currentVideoIsDefaultVRMode {
    
    return [self.videoEntity isDefaultVRMode];
}

- (BOOL)currentIsDefaultSD {
    
    return [self.videoEntity isDefault_SD];
}

- (NSString *)definitionToTitle:(NSString *)defi {
    
    return [WVRVideoEntity definitionToTitle:defi];
}

- (DefinitionType)definitionToType:(NSString *)defi {
    
    return [WVRVideoEntity definitionToType:defi];
}

// live中已重写，目前除了直播，其他视频还没有在全屏播放器页支付的需求（20170711）
- (void)actionGotoBuy {
    
//    [self.uiDelegate actionPause];
//    [self updatePayStatus:WVRPlayerToolVStatusWatingPay];
    [self.uiDelegate actionGotoBuy];
}

- (void)execResume {
    
    if (self.vPlayer.isValid) {
        
        [self.vPlayer start];
//        [self.playerView execPlaying];
        [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
        [self.uiDelegate actionResume];
        
        [self deliveryEventToComponents:@"playerui_execPlaying" params:nil];
    }
}

- (void)execPause {
    
    if (self.vPlayer.isValid) {
        
        [self.vPlayer stop];
    }
//    [self.playerView execSuspend];        // 此处为主动暂停操作，应该和卡顿事件分开处理
    [self updatePlayStatus:WVRPlayerToolVStatusPause];
    [self.uiDelegate actionPause];
}

- (BOOL)isPlaying {
    
    return [_vPlayer isPlaying];
}

- (void)actionOrientationReset {
    
    [WVRTrackEventMapping trackingVideoPlay:@"center"];
    
    [_vPlayer orientationReset];
    [self.playerView scheduleHideControls];
}

- (void)resetActionSwitchVR {
    
    [self.vPlayer setMonocular:YES];
    self.gPlayAdapterOriginDic[kLOADING_PLAYVIEW] = self.gLodingCellViewModel;
    [self updateVRStatus:WVRPlayerToolVStatusNotVR];
    self.isNotMonocular = NO;
}

- (BOOL)actionSwitchVR {
    
    BOOL success = [self actionSwitchVR:self.isNotMonocular];
    
    return success;
}

- (BOOL)actionSwitchVR:(BOOL)isMonocular {
    
#if (kAppEnvironmentLauncher == 0)
    SQToastInKeyWindow(@"非Unity环境无法切换到分屏模式");
    return NO;
#endif
    
    // bug 11543 加载时应该不能跳转
    if (!self.vPlayer.isOnPrepared) {
        return NO;
    }
    
    BOOL success = YES;
    
    // fixbug 11600
    if (![self.videoEntity canSwitchVR]) {
        SQToastInKeyWindow(@"手机性能无法支持4K分屏");
        return NO;
    }
    
    if (self.playerView.width <= MIN(SCREEN_WIDTH, SCREEN_HEIGHT)) {
        if (self.playerView.height <= self.playerView.width) {
            self.tmpPlayerViewStatus = WVRPlayerUIViewStatusHalfVertical;
        } else {
            self.tmpPlayerViewStatus = WVRPlayerUIViewStatusFullVertical;
        }
    } else {
        
        self.tmpPlayerViewStatus = WVRPlayerUIViewStatusFullHorizontal;
    }
    
    NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.vPlayer destroyForUnity];
        DDLogInfo(@"actionSwitchVR: %@", self.uiDelegate);
    });
    // 重置Unity返回时传的参数
    self.unityBackParams = nil;
    
    // banner不需要转屏
    if (![NSStringFromClass([self.uiDelegate class]) hasPrefix:@"WVRPlayerBanner"]) {
        
        [self changeViewFrameForFull];
    }
    
    if (success) {
        
        [WVRTrackEventMapping trackingVideoPlay:@"monocular"];
        
//        [self.videoEntity setDefaultVRMode:isMonocular];
    }
    
    return success;
}

- (void)actionSeekToTime:(float)scale {
    
    if (_videoDuration <= 0) { return; }                 // 未获取到视频总时长，不支持seek
    if (![self.vPlayer isPrepared]) { return; }          // 还未起播，不支持seek
    
    long time = _videoDuration * scale;
    [self.vPlayer seekTo:time];
    
    [self.playerView execStalled];
    [self.playerView scheduleHideControls];
}

// 是否为播放结束后再次播放
//- (void)actionPlay:(BOOL)isRepeat {
//
//    [self.uiDelegate actionPlay:isRepeat];
//    [self updatePlayStatus:WVRPlayerToolVStatusPreparing];
//}

- (NSString *)actionChangeDefinition {
    
    if (![self.vPlayer isPrepared]) { return nil; }
    
    if (!self.videoEntity.canChangeDefinition || self.videoEntity.isFootball) {
        
        SQToastInKeyWindow(kToastNoChangeDefinition);
        
        return nil;     // [self definitionToTitle:self.videoEntity.curDefinition];
    }
    
    [WVRTrackEventMapping trackingVideoPlay:@"renderType"];
    
    self.vPlayer.dataParam.url = [self.videoEntity playUrlChangeToNextDefinition];
    self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:self.videoEntity.curDefinition renderTypeStr:self.videoEntity.curUrlModel.renderType];
    
    if (self.videoEntity.streamType != STREAM_VR_LIVE) {
        long position = [_vPlayer getCurrentPosition];
        self.vPlayer.dataParam.position = (labs(position - _vPlayer.getDuration) <= 1000) ? 0 : position;
    }
    
    [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
    
    [self.playerView execStalled];
    [self.playerView scheduleHideControls];
    
    return [self definitionToTitle:self.videoEntity.curDefinition];
}

- (void)tryOtherDefinitionForPlayFailed {
    
    if (!self.videoEntity.haveValidUrlModel || self.videoEntity.isFootball) {
        
        return;
    }
    
    [WVRTrackEventMapping trackingVideoPlay:@"renderType"];
    
    self.vPlayer.dataParam.url = [self.videoEntity tryNextDefinitionWhenPlayFaild];
    self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:self.videoEntity.curDefinition renderTypeStr:self.videoEntity.curUrlModel.renderType];
    
    if (self.videoEntity.streamType != STREAM_VR_LIVE) {
        long position = [_vPlayer getCurrentPosition];
        self.vPlayer.dataParam.position = (labs(position - _vPlayer.getDuration) <= 1000) ? 0 : position;
    }
    
    [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
    
    [self.playerView execStalled];
    [self.playerView scheduleHideControls];
}

- (void)actionRetry {
    [self updatePlayStatus:WVRPlayerToolVStatusPreparing];
    [self.uiDelegate actionRetry];
}

- (void)actionRetryTryAndSee {
    [self updatePayStatus:WVRPlayerToolVStatusNeedPay];
    [self.uiDelegate actionRetry];
}

- (void)actionRestart {
    
    [self updatePlayStatus:WVRPlayerToolVStatusPreparing];
    [self.uiDelegate actionRestart];
}

/// 专题连播 播放下一个
- (void)actionPlayNext {
    
    [self updatePayStatus:WVRPlayerToolVStatusPreparing];
    [self.uiDelegate actionPlayNext];
}

- (void)actionPanGustrue:(float)x Y:(float)y {
    
    [self.vPlayer viewTouchesMoved:x Y:y];
}

- (void)actionTouchesBegan {
    
    [self.vPlayer viewTouchesStarted];
}

- (void)actionChangeCameraStand:(NSString *)standType {
    
    if ([self.videoEntity.currentStandType isEqualToString:standType]) { return; }
    
    if (![self.videoEntity canChangeToCameraStand:standType]) { return; }
    
    [self.videoEntity changeCameraStand:standType];
    
    if (!self.videoEntity.isFootball) {
        
        self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForRenderTypeStr:self.videoEntity.curUrlModel.renderType];
    } else {
        
        if ([standType isEqualToString:@"Public"]) {
            
            self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForRenderTypeStr:self.videoEntity.curUrlModel.renderType];
            [self.vPlayer setBottomViewHidden:NO];
        } else {
            
            self.vPlayer.dataParam.renderType = MODE_HALF_SPHERE_VIP;
            [self.vPlayer setBottomViewHidden:YES];
        }
    }
    
    self.vPlayer.dataParam.url = self.videoEntity.curUrlModel.url;
    self.vPlayer.dataParam.position = [self.vPlayer getCurrentPosition];
    
    [self execUpdateDefiBtnTitle];
    
    [[self vPlayer] setParamAndPlay:self.vPlayer.dataParam];
    [[self playerView] execStalled];
}

- (NSArray<NSDictionary<NSString *, NSNumber *> *> *)actionGetCameraStandList {
    
    if (![self.videoEntity haveValidUrlModel]) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:8];
    
    for (NSString *standType in self.videoEntity.parserdUrlModelDict.allKeys) {
        BOOL isSelected = [self.videoEntity.currentStandType isEqualToString:standType];
        
        if (standType.length > 0) {
            NSDictionary *typeDict = @{ standType : @(isSelected) };
            [arr addObject:typeDict];
        }
    }
    return arr;
}

- (BOOL)actionCheckLogin {
    
    return [self.uiDelegate actionCheckLogin];
}

#pragma mark - WVRPlayerBottomViewDelegate

/**
 点击播放-暂停按钮交互事件
 
 @return 当前是否在播放
 */
- (BOOL)playOnClick:(BOOL )isPlay {
    
    if (self.vPlayer.isOnBuffering) { return NO; }
    
    BOOL playerIsPlaying = [self.vPlayer isPlaying];
    BOOL playStatus = NO;
    
    if (self.vPlayer.isComplete) {
        
        [WVRTrackEventMapping trackingVideoPlay:@"replay"];
        
        [self.uiDelegate actionPlay:YES];
        playStatus = NO;
    } else {
        if (!playerIsPlaying) {          // 暂停 -> 播放
            
            [WVRTrackEventMapping trackingVideoPlay:@"resume"];
            [self execResume];
            playStatus = YES;
        } else {                        // 播放 -> 暂停
            
            [WVRTrackEventMapping trackingVideoPlay:@"pause"];
            [self execPause];
            playStatus = NO;
        }
    }
    
    [self.playerView scheduleHideControls];
    
    return playStatus;
}

- (void)launchOnClick:(UIButton *)sender {
    
    // 跳转至launcher
    [self actionSwitchVR];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self.playerView];    // 清空schedule队列
}

- (void)sliderDragEnd:(UISlider *)slider {
    
    [self.playerView scheduleHideControls];
}

- (void)chooseQuality {
    
    NSString * defiTitle = [self actionChangeDefinition];
    if (defiTitle.length == 0) {
        return;
    }
    self.gBottomCellViewModel.defiTitle = defiTitle;
    [self updatePlayStatus:WVRPlayerToolVStatusChangeQuality];
}

#pragma mark - WVRPlayerTopToolVDelegate

- (void)backOnClick:(UIButton *)sender {
    
    if (self.playerView.viewStyle == WVRPlayerViewStyleLandscape) {
        [self.uiDelegate actionOnExit];
    } else if (self.playerView.viewStyle == WVRPlayerViewStyleHalfScreen) {
        if (self.isLandscape) {
            [self forceToOrientationPortrait];
        } else {
            [self.uiDelegate actionOnExit];
        }
    }
    
    [self.playerView scheduleHideControls];
    
    // 直播在liveManager里处理
}

#pragma mark - WVRPlayerRightToolVDelegate

- (void)resetBtnOnClick:(UIButton *)sender {
    
    [WVRTrackEventMapping trackingVideoPlay:@"center"];
    
    [_vPlayer orientationReset];
    [self.playerView scheduleHideControls];
}

#pragma mark - WVRPlayerViewDelegate

- (void)actionSetControlsVisible:(BOOL)isControlsVisible {
    
    if ([self.uiDelegate respondsToSelector:@selector(actionSetControlsVisible:)]) {
        [self.uiDelegate actionSetControlsVisible:isControlsVisible];
    }
}

//MARK: - pay

- (BOOL)isCharged {
    
    return [self.uiDelegate isCharged];
}

- (void)actionBackBtnClick {
    
}


#pragma mark - Events

/// 表示视频正在起播、已失败、已试看结束
- (BOOL)isHaveStartView {
    
    for (UIView *view in self.playerView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"WVRPlayerStartView")]) {
            return YES;
        }
    }
    
    return NO;
}

//MARK: - Player

- (void)execDestroy {
    
    [self.playerView execDestroy];
    [self removeUIComponents];
}

// 重新开始、播放下一个视频，显示startView
- (void)execWaitingPlay {
    
    self.playerView.ve = [self.videoEntity yy_modelToJSONObject];
    
    [self.playerView execWaitingPlay];
    
    NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
    titleDic[@"title"] = self.videoEntity.videoTitle;
    [self deliveryEventToComponents:@"playerui_execWaitingPlay" params:titleDic];
    self.gVRLoadingCellViewModel.gTitle = self.videoEntity.videoTitle;
    self.gLodingCellViewModel.gTitle = self.videoEntity.videoTitle;
    [self updatePlayStatus:WVRPlayerToolVStatusPreparing];
}

- (void)execUpdateDefiBtnTitle {
    
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:[self videoEntity].curDefinition];
}

- (void)execError:(NSString *)message code:(NSInteger)code {
    
    [self.playerView execError:message code:code];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"message"] = message;
    dict[@"code"] = @(code);
    [self deliveryEventToComponents:@"playerui_onError" params:dict];
    self.gLodingCellViewModel.gErrorMsg = message;
    self.gLodingCellViewModel.gErrorCode = code;
    self.gVRLoadingCellViewModel.gErrorMsg = message;
    self.gVRLoadingCellViewModel.gErrorCode = code;
    [self updatePlayStatus:WVRPlayerToolVStatusError];
}

- (void)execPreparedWithDuration:(long)duration {
    
    _videoDuration = duration;
    [self.playerView execPreparedWithDuration:duration];
    
    [self deliveryEventToComponents:@"playerui_PreparedWithDuration" params:@{ @"duration":@(duration) }];
//    [self updatePlayStatus:WVRPlayerToolVStatusPrepared];
    
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:self.videoEntity.curDefinition];
    [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
}

- (void)execPlaying {
    
    [self.playerView execPlaying];
    [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
}

// 非活跃状态
- (void)execSuspend {
    
    [self.playerView execSuspend];
    [self updatePlayStatus:WVRPlayerToolVStatusPause];
}

// 卡顿
- (void)execStalled {
    
    [self.playerView execStalled];
    [self updatePlayStatus:WVRPlayerToolVStatusSliding];
}

- (void)execCompletion {
    
    [WVRTrackEventMapping trackingVideoPlay:@"complete"];
    self.gBottomCellViewModel.bufferPosition = 0;
    self.gBottomCellViewModel.position = 0;
    [self updatePlayStatus:WVRPlayerToolVStatusComplete];
    
    // 专题连播
    if ([self.videoEntity canPlayNext] && [self.uiDelegate isKindOfClass:NSClassFromString(@"WVRPlayerVCTopic")]) {
        
        WVRPlayerStartView *startV = [[WVRPlayerStartView alloc] initForTopicWithTitleText:self.videoEntity.videoTitle nextTitle:[self.videoEntity nextPlayVideoTitle] containerView:self.playerView];
        startV.realDelegate = (id)self;
        
    } else if ([self.videoEntity canPlayNext]) {
        
        // 电视剧连播
        
    } else {
        // bug 11436 视频播放完，应该显示重新播放文案
        WVRPlayerStartView *startV = [[WVRPlayerStartView alloc] initForRestartWithTitleText:self.videoEntity.videoTitle containerView:self.playerView];
        startV.realDelegate = (id)self;
    }
}

- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration {
    
    if (self.vPlayer.isComplete) { return; }
    if (self.videoEntity.streamType == STREAM_VR_LOCAL) { bu = 0; }
    
    _videoDuration = duration;
    // 子类实现，将数据传递给UI
}

- (void)execUpdateCountdown {
    
//    if (self.videoEntity.streamType != STREAM_VR_LIVE && self.videoEntity.streamType != STREAM_VR_LOCAL) {
//        
//        NSDictionary *dict = @{ @"isLandscape": @(_isLandscape), @"viewsShow": @(![self.playerView isContorlsHide]) };
//        [self deliveryEventToComponents:@"playerui_execUpdateCountdown" params:dict];
//    }
}

- (void)execDownloadSpeedUpdate:(long)speed {
    
    NSLog(@"speedLog: %ld", speed);
    
//    [self.playerView execDownloadSpeedUpdate:speed];
    
    self.gLodingCellViewModel.gNetSpeed = speed;
    self.gVRLoadingCellViewModel.gNetSpeed = speed;
}

- (void)execSleepForControllerChanged {
    
    [self deliveryEventToComponents:@"playerui_sleepForControllerChanged" params:nil];
}

- (void)execResumeForControllerChanged {
    
    [self deliveryEventToComponents:@"playerui_resumeForControllerChanged" params:nil];
}

// MARK: - payment
// 点播付费节目免费时间结束，需要提示付费
- (void)execFreeTimeOverToCharge:(long)freeTime {
    
    BOOL canTrail = (freeTime > 0);
    NSString *price = [NSString stringWithFormat:@"%ld", self.detailBaseModel.price];
    [self deliveryEventToComponents:@"playerui_TrailOverToPay" params:@{ @"canTrail":@(canTrail), @"price":price, @"isProgramSet": @([self.detailBaseModel isProgramSet]) }];
    
    [self.playerView execFreeTimeOverToCharge:freeTime duration:_videoDuration];
    self.gVRLoadingCellViewModel.gCanTrail = canTrail;
    self.gLodingCellViewModel.gCanTrail = canTrail;
    self.gVRLoadingCellViewModel.gPrice = price;
    self.gLodingCellViewModel.gPrice = price;
    
    [self updatePayStatus:WVRPlayerToolVStatusWatingPay];
}

- (void)execPaymentSuccess {
    
    [self deliveryEventToComponents:@"playerui_PaymentSuccess" params:nil];
    [self.playerView execPaymentSuccess];
    [self.playerView controlsShowHideAnimation:NO];
    [self updatePayStatus:WVRPlayerToolVStatusPaySuccess];
}

- (void)execupdateLoadingTip:(NSString *)tip {
    self.gLodingCellViewModel.gTipStr = tip;
    self.gVRLoadingCellViewModel.gTipStr = tip;
//    [self.playerView execupdateLoadingTip:tip];
}

- (void)execCheckStartViewAnimation {
    
    [self deliveryEventToComponents:@"playerui_checkStartViewAnimation" params:nil];
}

- (void)resetVRMode {
    
    [self.playerView resetVRMode];
}

#pragma mark - pravite

- (WVRPlayerUIEventCallBack *)playerui_getPlayerView:(NSDictionary *)params {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"playerView"] = [self playerView];
    
    WVRPlayerUIEventCallBack *callback = [[WVRPlayerUIEventCallBack alloc] init];
    callback.params = dict;
    
    return callback;
}

- (WVRPlayerUIEventCallBack *)playerui_actionPause:(NSDictionary *)params {
    
    [self execPause];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_actionResume:(NSDictionary *)params {
    
    [self execResume];
    
    return nil;
}

#pragma mark - screenRotation

// 子类实现
- (void)changeViewFrameForFull {
    [self updateAnimationStatus:WVRPlayerToolVStatusDefault];
    if (self.isNotMonocular) {
        self.gTopCellViewModel.height = HEIGHT_TOP_VRMODE_VIEW_DEFAULT;
        [self updateVRStatus:WVRPlayerToolVStatusVR];
        [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
        [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
        self.gPlayAdapterOriginDic[kLOADING_PLAYVIEW] = self.gVRLoadingCellViewModel;
    } else {
        if (self.videoEntity.streamType == STREAM_VR_LIVE) {
            self.gTopCellViewModel.height = HEIGHT_TOP_VIEW_LIVE;
        } else {
            self.gTopCellViewModel.height = HEIGHT_TOP_VIEW_ADJUST;
        }
        [self updateVRStatus:WVRPlayerToolVStatusNotVR];
        self.gPlayAdapterOriginDic[kLOADING_PLAYVIEW] = self.gLodingCellViewModel;
        self.gPlayAdapterOriginDic[kLEFT_PLAYVIEW] = self.gLeftCellViewModel;
        self.gPlayAdapterOriginDic[kRIGHT_PLAYVIEW] = self.gRightCellViewModel;
    }
    self.gPlayAdapterOriginDic[kTOP_PLAYVIEW] = self.gTopCellViewModel;
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:self.videoEntity.curDefinition];
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
    self.gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
    self.gBottomCellViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
    self.gVRLoadingCellViewModel.gHidenBack = NO;
    self.gLodingCellViewModel.gHidenBack = NO;
}

- (void)updateAnimationStatus:(WVRPlayerToolVStatus)status
{
    self.gVRLoadingCellViewModel.animationStatus = status;
    self.gLodingCellViewModel.animationStatus = status;
    self.gTopCellViewModel.animationStatus = status;
    self.gBottomCellViewModel.animationStatus = status;
    self.gLeftCellViewModel.animationStatus = status;
    self.gRightCellViewModel.animationStatus = status;
}

// 子类实现
- (void)changeViewFrameForSmall {
    
    self.gVRLoadingCellViewModel.gHidenBack = YES;
    self.gLodingCellViewModel.gHidenBack = YES;
}

- (void)forceToOrientationPortrait {
    
    [self forceToOrientationPortrait:nil];
}

- (void)forceToOrientationPortrait:(void(^)(void))completionBlock {
    
    [self forceToOrientationPortraitWithAnimation:nil completion:completionBlock];
}

- (void)forceToOrientationPortraitWithAnimation:(void(^_Nullable)(void))animationBlock completion:(void(^_Nullable)(void))completionBlock {
    
    [self setIsLandscape:NO];
    
    UIViewController * vc = [UIViewController getCurrentVC];
    [vc.view endEditing:YES];
    [WVRAppContext sharedInstance].gStatusBarHidden = NO;
    if ([WVRAppContext sharedInstance].gSupportedInterfaceO != UIInterfaceOrientationMaskPortrait) {
        [WVRAppContext sharedInstance].gShouldAutorotate = YES;
        [WVRAppContext sharedInstance].gSupportedInterfaceO = UIInterfaceOrientationMaskPortrait;
    
        [WVRAppModel changeStatusBarOrientation: UIInterfaceOrientationPortrait];
        [WVRAppModel forceToOrientation:UIInterfaceOrientationPortrait];
    }
    if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [vc prefersStatusBarHidden];
        [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [WVRAppContext sharedInstance].gShouldAutorotate = NO;
    [WVRAppContext sharedInstance].gHomeIndicatorAutoHidden = NO;
    if (@available(iOS 11.0, *)) {
        [vc setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
//    [WVRAppContext sharedInstance].gStatusBarHidden = NO;
    
    [self resetActionSwitchVR];
    [self.playerView reloadData];
//    [self.playerView resetVRMode];      // 转到竖屏时需要关闭分屏模式
    
    NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        if (animationBlock) {
            animationBlock();
        }
    } completion:^(BOOL finished) {
        
        [[self playerView] screenRotationCompleteWithStatus:NO];
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)forceToOrientationMaskLandscapeRight {
    
    [self forceToOrientationMaskLandscapeRight:nil];
}

- (void)forceToOrientationMaskLandscapeRight:(void(^)(void))completionBlock {
    
    [self forceToOrientationMaskLandscapeRightWithAnimation:nil completion:completionBlock];
}

- (void)forceToOrientationMaskLandscapeRightWithAnimation:(void(^_Nullable)(void))animationBlock completion:(void(^_Nullable)(void))completionBlock {
    
    [self setIsLandscape:YES];
    
    UIViewController * vc = [UIViewController getCurrentVC];
    [vc.view endEditing:YES];
    [self invalidNavPanGuesture:YES];       // 转到横屏时关闭导航栏手势返回，记得在viewDidDisappera时判断并打开此功能
    [WVRAppContext sharedInstance].gStatusBarHidden = YES;
    [WVRAppContext sharedInstance].gShouldAutorotate = YES;
    [WVRAppContext sharedInstance].gHomeIndicatorAutoHidden = YES;
    if([WVRAppContext sharedInstance].gSupportedInterfaceO != UIInterfaceOrientationMaskLandscapeRight){
        [WVRAppContext sharedInstance].gSupportedInterfaceO = UIInterfaceOrientationMaskLandscapeRight;
//        [WVRAppModel changeStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
        
        [WVRAppModel forceToOrientation:UIInterfaceOrientationLandscapeRight];
    }
    if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [vc prefersStatusBarHidden];
        [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    if (@available(iOS 11.0, *)) {
        [vc setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
    NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WVRAppContext sharedInstance].gShouldAutorotate = NO;
    });
    
//    [WVRAppContext sharedInstance].gStatusBarHidden = NO;
    [self.playerView reloadData];
    
//    if (self.isMonocular) {
//        [self.gVRModeBackBtnAnimationViewModel.gAnimationCmd execute:nil];
//    } else {
//        [self.gVRModeBackBtnAnimationViewModel.gUpAnimationCmd execute:nil];
//    }
    
    [UIView animateWithDuration:duration animations:^{
        if (animationBlock) {
            animationBlock();
        }
    } completion:^(BOOL finished) {
        
        [[self playerView] screenRotationCompleteWithStatus:YES];
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}

/// 导航栏手势失效 YES 失效，NO 生效
- (void)invalidNavPanGuesture:(BOOL)isInvalid {
    
    UIViewController *vc = [UIViewController getCurrentVC];
    if (![vc.navigationController isKindOfClass:[WVRNavigationController class]]) {
        return;
    }
    
    WVRNavigationController *nav = (WVRNavigationController *)vc.navigationController;
    nav.gestureInValid = isInvalid;
}

- (void)rotationForBackFormUnity {
    
    
}

#pragma mark - Component Event

- (WVRPlayerUIEventCallBack *)playerui_actionRetry:(NSDictionary *)params {
    [self updatePayStatus:WVRPlayerToolVStatusNeedPay];
    [self.uiDelegate actionRetry];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_actionGotoBuy:(NSDictionary *)params {
//    [self updatePayStatus:WVRPlayerToolVStatusWatingPay];
    [self.uiDelegate actionGotoBuy];
    
    return nil;
}

- (void)showStatusBar
{
    [WVRAppContext sharedInstance].gStatusBarHidden = NO;//必须成对调用
    
    UIViewController * vc = [UIViewController getCurrentVC];
    if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [vc prefersStatusBarHidden];
        [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [WVRAppContext sharedInstance].gStatusBarHidden = NO;
}

- (void)updatePlayViewHidenStatus:(BOOL)isHiden
{
    self.gBottomCellViewModel.viewIsHiden = isHiden;
    self.gTopCellViewModel.viewIsHiden = isHiden;
    self.gLeftCellViewModel.viewIsHiden = isHiden;
    self.gRightCellViewModel.viewIsHiden = isHiden;
}

- (WVRPlayerUIViewStatus)playerUIViewStatus {
    
    float width = self.playerView.width;
    float height = self.playerView.height;
    
    float max_length = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    float min_lenght = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    if (width == max_length && height == min_lenght) {
        return WVRPlayerUIViewStatusFullHorizontal;
    }
    if (width == min_lenght && height == max_length) {
        return WVRPlayerUIViewStatusFullVertical;
    }
    if (width <= min_lenght && height <= min_lenght && width >= height) {
        return WVRPlayerUIViewStatusHalfVertical;
    }
    NSAssert(NO, @"判断错误，条件不满足，请检查代码");
    return WVRPlayerUIViewStatusHalfVertical;
}

@end

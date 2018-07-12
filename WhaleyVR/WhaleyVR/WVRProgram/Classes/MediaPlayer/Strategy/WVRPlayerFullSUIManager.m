//
//  WVRPlayerFullSUIManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullSUIManager.h"
#import "WVRPlayerViewFullS.h"
//#import "WVRPlayerStartController.h"
#import "WVRRemindChargeController.h"
#import "WVRSpring2018Manager.h"
#import "WVRSpringBoxController.h"

@interface WVRPlayerFullSUIManager ()<WVRPlayerTopViewDelegate,WVRPlayerBottomViewDelegate, WVRPlayerLeftViewDelegate, WVRPlayRightViewDelegate, WVRSliderDelegate>

@end


@implementation WVRPlayerFullSUIManager
@synthesize gPlayerViewAdapter = _gPlayerViewAdapter;
@synthesize gTopCellViewModel = _gTopCellViewModel;
@synthesize gLeftCellViewModel = _gLeftCellViewModel;
@synthesize gRightCellViewModel = _gRightCellViewModel;
@synthesize gBottomCellViewModel = _gBottomCellViewModel;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setIsLandscape:YES];
    }
    return self;
}

#pragma mark - overwrite func

- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView {
    
    WVRPlayerViewFullS *view = (id)[super createPlayerViewWithContainerView:containerView];
    
    // 初始化
    [view fillData:self.gPlayViewViewModel];
    view.dataSource = self.gPlayerViewAdapter;
    [view reloadData];
//    [self addComponents];     // 放在updateAfterSetParams方法里执行 确认拿到详情页数据后添加
    [self installRAC];
    
    return view;
}

- (void)installRAC {
    
    @weakify(self);
    [RACObserve([self videoEntity], isFootball) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self changeViewFrameForFootball];
    }];
}

- (void)changeViewFrameForFootball {
    [super changeViewFrameForFull];
    self.gBottomCellViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:self.videoEntity.curDefinition];
    self.gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
    [self updateAnimationStatus:WVRPlayerToolVStatusAnimationComplete];
    [[self playerView] reloadData];
}

- (void)addComponents {
    [super addComponents];
    
    [self addRemindChargeController];
    
    if (self.videoEntity.streamType != STREAM_VR_LIVE) {
        
        [self addStartViewController];
        [self addSpring2018Controller];
    }
}

- (void)addStartViewController {
    
//    WVRPlayerStartController *startC = [[WVRPlayerStartController alloc] initWithDelegate:self];
//    
//    NSDictionary *dict = @{ @"parentView":[self playerView], @"videoTitle":self.videoEntity.videoTitle };
//    [startC addControllerWithParams:dict];
//    
//    [self.components addObject:startC];
}

- (void)addRemindChargeController {
    
    WVRRemindChargeController *remindC = [[WVRRemindChargeController alloc] initWithDelegate:self];
    
    NSDictionary *dict = @{ @"parentView":[self playerView], @"ve":self.videoEntity };
    [remindC addControllerWithParams:dict];
    
    [self.components addObject:remindC];
}

- (void)addSpring2018Controller {
    
    if (![WVRSpring2018Manager checkSpring2018Valid]) {
        return;
    }
    
    WVRSpringBoxController *controller = [[WVRSpringBoxController alloc] initWithDelegate:self];
    
    NSDictionary *dict = @{ @"parentView":[self playerView], @"ve":[[self videoEntity] yy_modelToJSONObject] };
    [controller addControllerWithParams:dict];
    
    [self.components addObject:controller];
}

- (void)execFreeTimeOverToCharge:(long)freeTime {
    [super execFreeTimeOverToCharge:freeTime];
    
//    [self updatePlayStatus:WVRPlayerToolVStatusWatingPay];
}

// 重新开始、播放下一个视频，显示startView
- (void)execWaitingPlay {
    [super execWaitingPlay];
    
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
}

//- (void)execCompletion {
//    [super execCompletion];
//
//}

- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration {
    [super execPositionUpdate:posi buffer:bu duration:duration];
    
    self.gBottomCellViewModel.duration = duration>0? duration:self.videoEntity.biEntity.totalTime;
    self.gBottomCellViewModel.bufferPosition = bu;
    self.gBottomCellViewModel.position = posi;
}

#pragma mark - getter

- (WVRPlayerViewAdapter *)gPlayerViewAdapter
{
    if (!_gPlayerViewAdapter) {
        _gPlayerViewAdapter = [[WVRPlayerViewAdapter alloc] init];
        [_gPlayerViewAdapter loadData:self.gPlayAdapterOriginDic];
    }
    return _gPlayerViewAdapter;
}

- (WVRPlayTopCellViewModel *)gTopCellViewModel
{
    if (!_gTopCellViewModel) {
        _gTopCellViewModel = [[WVRPlayTopCellViewModel alloc] init];
        _gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
        _gTopCellViewModel.delegate = self;
        _gTopCellViewModel.title = self.videoEntity.videoTitle;
        _gTopCellViewModel.height = HEIGHT_TOP_VIEW_ADJUST;
    }
    return _gTopCellViewModel;
}

- (WVRPlayBottomCellViewModel *)gBottomCellViewModel
{
    if (!_gBottomCellViewModel) {
        WVRPlayBottomCellViewModel * bottomViewModel = [[WVRPlayBottomCellViewModel alloc] init];
        bottomViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
        bottomViewModel.delegate = self;
        bottomViewModel.height = HEIGHT_BOTTOM_VIEW_ADJUST;
        _gBottomCellViewModel = bottomViewModel;
    }
    
    return _gBottomCellViewModel;
}

- (WVRPlayLeftCellViewModel *)gLeftCellViewModel
{
    if (!_gLeftCellViewModel) {
        _gLeftCellViewModel = [[WVRPlayLeftCellViewModel alloc] init];
        _gLeftCellViewModel.cellNibName = @"WVRPlayerLeftView";
        _gLeftCellViewModel.delegate = self;
        _gLeftCellViewModel.width = WIDTH_LEFT_VIEW_DEFAULT;
    }
    return _gLeftCellViewModel;
}

- (WVRPlayRightCellViewModel *)gRightCellViewModel
{
    if (!_gRightCellViewModel) {
        _gRightCellViewModel = [[WVRPlayRightCellViewModel alloc] init];
        
        _gRightCellViewModel.delegate = self;
        _gRightCellViewModel.width = WIDTH_RIGHT_VIEW_DEFAULT;
    }
    BOOL isVR = (self.videoEntity.streamType == STREAM_VR_VOD || self.videoEntity.streamType == STREAM_VR_LOCAL);
    _gRightCellViewModel.cellNibName = isVR ? @"WVRPlayerRightView" : nil;
    
    return _gRightCellViewModel;
}

#pragma mark - WVRPlayerBottomViewDelegate

- (BOOL)playOnClick:(BOOL)isPlay {
    BOOL result = [super playOnClick:isPlay];
//    if (![self.vPlayer isPlaying]) {
//        [self updatePlayStatus:WVRPlayerToolVStatusStop];
//    } else {
//        [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
//    }
    
    [self.playerView scheduleHideControls];
    
    return result;
}

//- (void)launchOnClick:(UIButton *)sender {
//    
//    // 跳转Launcher
//    
//    [self actionSwitchVR];
//    
//    [[self playerView] reloadData];
//    if (self.isMonocular) {
//        [self.gVRModeBackBtnAnimationViewModel.gAnimationCmd execute:nil];
//    }else{
//        [self.gVRModeBackBtnAnimationViewModel.gUpAnimationCmd execute:nil];
//    }
//}

//- (void)chooseVRMode:(BOOL)isVR {
//    [self actionSwitchVR];
////    [self.vPlayer setMonocular:!isVR];
//    self.gBottomCellViewModel.isVRMode = isVR;
//    
//    [self.playerView scheduleHideControls];
//}

#pragma mark - WVRPlayerTopViewDelegate

- (void)backOnClick:(UIButton *)sender {
    
    if ([self.uiDelegate respondsToSelector:@selector(actionOnExit)]) {
        
        [WVRTrackEventMapping trackingVideoPlay:@"back"];
        
        [self.uiDelegate actionOnExit];
    }
}

#pragma mark - WVRPlayerLeftViewDelegate

- (void)clockOnClick:(BOOL)isClock
{
    if (isClock) {
        [self updateLockStatus:WVRPlayerToolVStatusLock];
    } else {
        [self updateLockStatus:WVRPlayerToolVStatusNotLock];
    }
}

#pragma mark - WVRPlayRightViewDelegate

- (void)resetBtnOnClick:(UIButton *)sender
{
    [self.vPlayer orientationReset];
    
    [self.playerView scheduleHideControls];
}

#pragma mark - WVRSliderDelegate

- (void)sliderStartScrubbing:(UISlider *)sender {
//    [self stopTimer];
    [self updatePlayStatus:WVRPlayerToolVStatusPrepared];
    
    [self.playerView scheduleHideControls];
}

- (void)sliderEndScrubbing:(UISlider *)sender {
    
    long videoDuration = [self.vPlayer getDuration];
    
    [self.vPlayer seekTo:sender.value * videoDuration];
    
    [self updatePlayStatus:WVRPlayerToolVStatusSliding];
    long curPosition = sender.value * videoDuration;
    long bufferPosition = [self.vPlayer getPlayableDuration];
    
    self.gBottomCellViewModel.duration = videoDuration;
    self.gBottomCellViewModel.bufferPosition = bufferPosition;
    self.gBottomCellViewModel.position = curPosition;
    
    [self.playerView scheduleHideControls];
}

- (void)execUpdateDefiBtnTitle {
    [super execUpdateDefiBtnTitle];
    
//    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:[self videoEntity].curDefinition];
}

#pragma mark - private

- (void)updateLockStatus:(WVRPlayerToolVStatus)status {
    
    self.gPlayViewViewModel.lockStatus = status;
    self.gPlayViewViewModel.lockStatus = status;
    self.gTopCellViewModel.lockStatus = status;
    self.gBottomCellViewModel.lockStatus = status;
    self.gLeftCellViewModel.lockStatus = status;
    self.gRightCellViewModel.lockStatus = status;
}

@end

//
//  WVRPlayerDetailUIManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerDetailUIManager.h"

//#import "WVRPlayerStartController.h"
#import "WVRRemindChargeController.h"
#import "WVRSpringBoxController.h"
#import "WVRSpring2018Manager.h"

@interface WVRPlayerDetailUIManager ()<WVRPlayerTopViewDelegate,WVRPlayerBottomViewDelegate, WVRPlayerLeftViewDelegate, WVRPlayRightViewDelegate, WVRSliderDelegate>

@property (nonatomic, strong) UIView * gContentView;

@end


@implementation WVRPlayerDetailUIManager
@synthesize gPlayerViewAdapter = _gPlayerViewAdapter;
@synthesize gTopCellViewModel = _gTopCellViewModel;
@synthesize gLeftCellViewModel = _gLeftCellViewModel;
@synthesize gRightCellViewModel = _gRightCellViewModel;
@synthesize gBottomCellViewModel = _gBottomCellViewModel;

#pragma mark - overwrite func

- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView {
    
    WVRPlayerView *view = (id)[super createPlayerViewWithContainerView:containerView];
    
    // 初始化
    [view fillData:self.gPlayViewViewModel];
    view.dataSource = self.gPlayerViewAdapter;
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    @weakify(self);
    [RACObserve([self videoEntity], videoTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gVRLoadingCellViewModel.gTitle = [self videoEntity].videoTitle;
    }];
    
    [RACObserve([self videoEntity], videoTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gLodingCellViewModel.gTitle = [self videoEntity].videoTitle;
    }];
    [view reloadData];
    
//    [self addComponents];     // 放在updateAfterSetParams方法里执行 确认拿到详情页数据后添加
    
    return view;
}

- (void)addComponents {
    [super addComponents];
    
    [self addRemindChargeController];
    
    [self addSpring2018Controller];
    
    if (self.videoEntity.streamType != STREAM_VR_LIVE) {
//        [self addStartViewController];
    }
}

- (void)addRemindChargeController {
    
    WVRRemindChargeController *controller = [[WVRRemindChargeController alloc] initWithDelegate:self];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"parentView"] = [self playerView];
    params[@"ve"] = self.videoEntity;
    
    [controller addControllerWithParams:params];
    
    [self.components addObject:controller];
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

//- (void)execCompletion {
//    [super execCompletion];
//    
//}

- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration {
    [super execPositionUpdate:posi buffer:bu duration:duration];
    
    self.gBottomCellViewModel.duration = duration;
    self.gBottomCellViewModel.bufferPosition = bu;
    self.gBottomCellViewModel.position = posi;
}

- (void)updateLockStatus:(WVRPlayerToolVStatus)status
{
//    self.gPlayViewStatus = status;
    self.gPlayViewViewModel.lockStatus = status;
    self.gTopCellViewModel.lockStatus = status;
    self.gBottomCellViewModel.lockStatus = status;
    self.gLeftCellViewModel.lockStatus = status;
    self.gRightCellViewModel.lockStatus = status;
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
        _gTopCellViewModel.cellNibName = @"WVRPlayerTopView";
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
        bottomViewModel.cellNibName = @"WVRPlayerSmallBottomView";
        bottomViewModel.delegate = self;
        bottomViewModel.height = HEIGHT_BOTTOM_VIEW_ADJUST;
        [RACObserve([WVRSpring2018Manager shareInstance], isValid) subscribeNext:^(id  _Nullable x) {
            if ([WVRSpring2018Manager shareInstance].isValid) {
                bottomViewModel.toFullIcon = @"icon_play_tofull";
            }else{
                bottomViewModel.toFullIcon = @"player_icon_toFull";
            }
        }];
        
        _gBottomCellViewModel = bottomViewModel;
        [self parserStreamtypeForSmall];
    }
    return _gBottomCellViewModel;
}

- (void)parserStreamtypeForSmall
{
    switch (self.videoEntity.streamType) {
        case STREAM_2D_TV:
            self.gBottomCellViewModel.cellNibName = @"WVRPlayerSmallBottomView2DTV";
            break;
        default:
            self.gBottomCellViewModel.cellNibName = @"WVRPlayerSmallBottomView";
            break;
    }
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
        _gRightCellViewModel.cellNibName = @"WVRPlayerRightView";
        _gRightCellViewModel.delegate = self;
        _gRightCellViewModel.width = WIDTH_RIGHT_VIEW_DEFAULT;
    }
    switch (self.videoEntity.streamType) {
        case STREAM_VR_VOD:
            
            break;
        case STREAM_2D_TV:
            return nil;
            break;
        case STREAM_3D_WASU:
            return nil;
            break;
        case STREAM_VR_LOCAL:
            
            break;
        default:
            break;
    }
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
    return result;
}

- (void)fullOnClick:(UIButton *)sender {
    
    [WVRTrackEventMapping trackingVideoPlay:@"fullScreen"];
    
    [self changeViewFrameForFull];
}

- (void)launchOnClick:(UIButton *)sender {
    
    [self actionSwitchVR];
}

#pragma mark - WVRPlayerTopViewDelegate

- (void)backOnClick:(UIButton *)sender {
    
    [self changeViewFrameForSmall];
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
}

#pragma mark - WVRSliderDelegate

- (void)sliderStartScrubbing:(UISlider *)sender {
    //    [self stopTimer];
    [self updatePlayStatus:WVRPlayerToolVStatusPrepared];
}

- (void)sliderEndScrubbing:(UISlider *)sender {
    DDLogInfo(@"");
    
    [self.vPlayer seekTo:sender.value*[self.vPlayer getDuration]];
    
    [self updatePlayStatus:WVRPlayerToolVStatusSliding];
    long curPosition = sender.value*[self.vPlayer getDuration];
    long bufferPosition = [self.vPlayer getPlayableDuration];
    long duration = [self.vPlayer getDuration];
    self.gBottomCellViewModel.duration = duration;
    self.gBottomCellViewModel.bufferPosition = bufferPosition;
    self.gBottomCellViewModel.position = curPosition;
}

#pragma mark - Component Event

- (WVRPlayerUIEventCallBack *)playerui_actionRetry:(NSDictionary *)params {
    
    [self.uiDelegate actionRetry];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_actionGotoBuy:(NSDictionary *)params {
    
    [self.uiDelegate actionGotoBuy];
    
    return nil;
}

#pragma mark - screen rotation

- (void)changeViewFrameForFull {
    [super changeViewFrameForFull];
    self.gPlayAdapterOriginDic[kTOP_PLAYVIEW] = self.gTopCellViewModel;
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
    if (self.isNotMonocular) {
        [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
        [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    } else {
        self.gPlayAdapterOriginDic[kLEFT_PLAYVIEW] = self.gLeftCellViewModel;
        BOOL isVR = (self.videoEntity.streamType == STREAM_VR_VOD || self.videoEntity.streamType == STREAM_VR_LOCAL);
        if (isVR) {
            self.gPlayAdapterOriginDic[kRIGHT_PLAYVIEW] = self.gRightCellViewModel;
        }
    }
    self.gBottomCellViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:self.videoEntity.curDefinition];
    self.gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
//    [self.playerView reloadData];父类转屏方法已reloadData
    
    [self forceToOrientationMaskLandscapeRight];
}

- (void)changeViewFrameForSmall {
    [super changeViewFrameForSmall];
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    [self parserStreamtypeForSmall];
//    [self.playerView reloadData];
    
    [self forceToOrientationPortrait];
}

#pragma mark - overwrite WVRPlayerUIManagerProtocol

- (void)forceToOrientationPortraitWithAnimation:(void (^)(void))animationBlock completion:(void (^)(void))completionBlock {
    @weakify(self);
    [super forceToOrientationPortraitWithAnimation:^{
        @strongify(self);
        if ([self.uiDelegate respondsToSelector:@selector(rotaionAnimations:)]) {
            [self.uiDelegate rotaionAnimations:NO];
        }
        if (animationBlock) {
            animationBlock();
        }
        [self deliveryEventToComponents:@"playerui_setIsLandscape" params:@{ @"isLandscape":@(NO) }];
    } completion:^{
        if (completionBlock) {
            completionBlock();
        }
        
        [self updateLockStatus:WVRPlayerToolVStatusNotLock];
    }];
}

- (void)forceToOrientationMaskLandscapeRightWithAnimation:(void (^)(void))animationBlock completion:(void (^)(void))completionBlock {
    @weakify(self);
    [super forceToOrientationMaskLandscapeRightWithAnimation:^{
        @strongify(self);
        if ([self.uiDelegate respondsToSelector:@selector(rotaionAnimations:)]) {
            [self.uiDelegate rotaionAnimations:YES];
        }
        if (animationBlock) {
            animationBlock();
        }
    } completion:^{
        @strongify(self);
        if (completionBlock) {
            completionBlock();
        }
        [self deliveryEventToComponents:@"playerui_setIsLandscape" params:@{ @"isLandscape":@(YES) }];
    }];
}

// 重新开始、播放下一个视频，显示startView
- (void)execWaitingPlay {
    [super execWaitingPlay];
    
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
    self.gLodingCellViewModel.gTitle = self.videoEntity.videoTitle;
    self.gVRLoadingCellViewModel.gTitle = self.videoEntity.videoTitle;
}

@end

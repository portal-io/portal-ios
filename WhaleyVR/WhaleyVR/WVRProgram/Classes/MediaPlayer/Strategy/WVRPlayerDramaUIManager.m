//
//  WVRPlayerDramaUIManager.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerDramaUIManager.h"
#import "WVRPlayerViewDrama.h"
#import "WVRPlayDramaCenterCellViewModel.h"
#import "WVRSpring2018Manager.h"
#import "WVRSpringBoxController.h"

@interface WVRPlayerDramaUIManager()

@property (nonatomic, strong) WVRPlayDramaCenterCellViewModel * gDramaCenterCellViewModel;

@end


@implementation WVRPlayerDramaUIManager
@synthesize gBottomCellViewModel = _gBottomCellViewModel;
@synthesize gTopCellViewModel = _gTopCellViewModel;
@synthesize gLeftCellViewModel = _gLeftCellViewModel;
@synthesize gRightCellViewModel = _gRightCellViewModel;

-(UIView *)createPlayerViewWithContainerView:(UIView *)containerView
{
    WVRPlayerViewDrama *view = nil;
    view = [[WVRPlayerViewDrama alloc] init];
    
    [containerView addSubview:view];
    self.playerView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(view.superview);
    }];
    // 初始化
    [view fillData:self.gPlayViewViewModel];
    view.dataSource = self.gPlayerViewAdapter;
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    self.gPlayAdapterOriginDic[kCENTER_PLAYVIEW] = self.gDramaCenterCellViewModel;
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
    return view;
}

-(void)installAfterSetParams
{
    [super installAfterSetParams];
    @weakify(self);
    [RACObserve(self, gDramasDic) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gDramaCenterCellViewModel.leftIcon = self.gDramasDic[KLEFT_DRAMA];
        self.gDramaCenterCellViewModel.middleIcon = self.gDramasDic[KMIDDLE_DRAMA];
        self.gDramaCenterCellViewModel.rightIcon = self.gDramasDic[KRIGHT_DRAMA];
    }];
    [RACObserve(self.gDramaCenterCellViewModel, lockStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        WVRPlayerToolVStatus status = self.gDramaCenterCellViewModel.lockStatus;
        self.gPlayViewViewModel.lockStatus = status;
        self.gTopCellViewModel.lockStatus = status;
        self.gBottomCellViewModel.lockStatus = status;
        self.gLeftCellViewModel.lockStatus = status;
        self.gRightCellViewModel.lockStatus = status;
    }];
}

- (void)addComponents {
    [super addComponents];
    
    [self addSpring2018Controller];
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

-(WVRPlayDramaCenterCellViewModel *)gDramaCenterCellViewModel
{
    if (!_gDramaCenterCellViewModel) {
        _gDramaCenterCellViewModel = [[WVRPlayDramaCenterCellViewModel alloc] init];
        _gDramaCenterCellViewModel.cellNibName = @"WVRPlayDramaCenterCell";
//        @weakify(self);
//        [_gDramaCenterCellViewModel.chooseDramaSignal subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
//            NSString * tip = [NSString stringWithFormat:@"choose:%@",x];
//            SQToastInKeyWindow(tip);
//        }];
    }
    return _gDramaCenterCellViewModel;
}

-(RACSignal *)gChooseDramaSignal
{
    return self.gDramaCenterCellViewModel.chooseDramaSignal;
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
        bottomViewModel.cellNibName = @"WVRPlayerDramaSmallBottomView";
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

- (void)fullOnClick:(UIButton *)sender {
    
    [WVRTrackEventMapping trackingVideoPlay:@"fullScreen"];
    
    [self changeViewFrameForFull];
}

- (void)launchOnClick:(UIButton *)sender {
    
    [self actionSwitchVR];
    
//    [SQToastTool showToastWithMsg:@"为保证体验，互动剧的VR模式请在GearVR小米眼镜等设备中下载体验" parenetView:self.playerView yScale:(self.playerView.height-(HEIGHT_BOTTOM_VIEW_DEFAULT+10))/self.playerView.height];
}

#pragma mark - WVRPlayerTopViewDelegate

- (void)backOnClick:(UIButton *)sender {
    
    [self changeViewFrameForSmall];
}

- (void)changeViewFrameForFull {
    [super changeViewFrameForFull];
    self.gPlayAdapterOriginDic[kTOP_PLAYVIEW] = self.gTopCellViewModel;
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
    self.gPlayAdapterOriginDic[kLEFT_PLAYVIEW] = self.gLeftCellViewModel;
    BOOL isVR = (self.videoEntity.streamType == STREAM_VR_VOD || self.videoEntity.streamType == STREAM_VR_LOCAL);
    if (isVR) {
        self.gPlayAdapterOriginDic[kRIGHT_PLAYVIEW] = self.gRightCellViewModel;
    }
    self.gBottomCellViewModel.cellNibName = @"WVRPlayerDramaFullSBottomView";
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:self.videoEntity.curDefinition];
    //    [self.playerView reloadData];父类转屏方法已reloadData
    [self forceToOrientationMaskLandscapeRight];
    [self.gDramaCenterCellViewModel.goFullAnimationCmd execute:nil];
}

- (void)changeViewFrameForSmall {
    [super changeViewFrameForSmall];
    self.gBottomCellViewModel.cellNibName = @"WVRPlayerDramaSmallBottomView";
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    [self forceToOrientationPortrait];
    [self.gDramaCenterCellViewModel.goSmallAnimationCmd execute:nil];
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

- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration {
    [super execPositionUpdate:posi buffer:bu duration:duration];
    
    self.gBottomCellViewModel.duration = duration;
    self.gBottomCellViewModel.bufferPosition = bu;
    self.gBottomCellViewModel.position = posi;
    //test
//    if (posi >= 10000&&posi < 11000) {
//        [self updatePlayStatus:WVRPlayerToolVStatusWatingChooseDrama];
//    }
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

-(void)updatePlayStatus:(WVRPlayerToolVStatus)status
{
    [super updatePlayStatus:status];
    self.gDramaCenterCellViewModel.playStatus = status;
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

// 重新开始、播放下一个视频，显示startView
- (void)execWaitingPlay {
    [super execWaitingPlay];
    
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
    self.gLodingCellViewModel.gTitle = self.videoEntity.videoTitle;
}

- (void)updateDramaStatus:(WVRPlayerToolVStatus)status
{
    self.gLeftCellViewModel.gDramaStatus = status;
    self.gRightCellViewModel.gDramaStatus = status;
    self.gTopCellViewModel.gDramaStatus = status;
    self.gBottomCellViewModel.gDramaStatus = status;
    self.gDramaCenterCellViewModel.gDramaStatus = status;//最后刷新，等其他控件刷新后
}

@end

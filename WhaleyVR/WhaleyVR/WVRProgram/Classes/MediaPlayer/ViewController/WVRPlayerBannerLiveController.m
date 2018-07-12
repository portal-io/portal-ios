//
//  WVRPlayerBannerLiveController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerBannerLiveController.h"
#import "WVRLiveDetailViewModel.h"
#import "WVRVideoEntityLive.h"

@interface WVRPlayerBannerLiveController (){
    
    WVRVideoEntityLive *_videoEntity;
    BOOL _isDestroy;
    BOOL _isPrepared;
    id _rac_handler;
}

@property (nonatomic, strong, readonly) WVRLiveDetailViewModel *gLiveDetailViewModel;

@property (nonatomic, weak) id<WVRPlayerBannerProtocol> delegate;

@property (nonatomic, weak) UIView * contentView;

@end


@implementation WVRPlayerBannerLiveController
@synthesize gLiveDetailViewModel = _tmpVideoDetailViewModel;
@synthesize playerUI = _playerUI;

- (instancetype)initWithContentView:(UIView*)contentView delegate:(id<WVRPlayerBannerProtocol>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.contentView = contentView;
    }
    return self;
}

- (WVRLiveDetailViewModel *)gLiveDetailViewModel {
    
    if (!_tmpVideoDetailViewModel) {
        _tmpVideoDetailViewModel = [[WVRLiveDetailViewModel alloc] init];
    }
    return _tmpVideoDetailViewModel;
}

- (void)viewDidLoad {
//    [super viewDidLoad];
//    [[self playerUI] updateContentView:self.contentView];
//    [[[self playerUI] playerView] reloadData];
    
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)toOrientation
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (void)dealwithUnityBackParams {
    
    NSString *definition = [self playerUI].unityBackParams[@"currentQuality"];
    long position = [[self playerUI].unityBackParams[@"currentPosition"] integerValue];
    
    // bug 11543，防止因stop导致黑屏
    [self.vPlayer resetIsPauseStatusForBanner];
    
    if ([self.videoEntity.curDefinition isEqualToString:definition]) {
        
        [self startTimer];
        [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
    } else {
        self.curPosition = position;
        self.curDefinition = definition;
        
        [self startTimer];
        [self readyToPlay];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    UIViewController *currentVC = [UIViewController getCurrentVC];
    BOOL goUnity = [currentVC isKindOfClass:NSClassFromString(@"UnityViewControllerBase")];
    if (!goUnity) {
        [self playerUI].isGoUnity = NO;
        [self playerUI].isGoUnityFootball = NO;
    }
}

- (void)createLayoutView
{
    [super createLayoutView];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)readyToPlay
{
    if (_isDestroy) {
        [self destory];
    } else {
        [super readyToPlay];
    }
}

-(void)updateContentView:(UIView*)contentView
{
    [[self playerUI] updateContentView:contentView];
}

- (WVRPlayerBannerLiveUIManager *)playerUI {
    
    if (!_playerUI) {
        WVRPlayerBannerLiveUIManager * playerUI = [[WVRPlayerBannerLiveUIManager alloc] init];
        playerUI.videoEntity = [self videoEntity];
        playerUI.detailBaseModel = [self detailBaseModel];
        playerUI.vPlayer = self.vPlayer;
        playerUI.uiDelegate = self;
        playerUI.uiLiveDelegate = self;
        _playerUI = playerUI;
        [_playerUI installAfterSetParams];
        @weakify(self);
        [[RACObserve(((WVRVideoEntityLive*)[self videoEntity]), totalLotteryTime) skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            ((WVRVideoEntityLive*)[self videoEntity]).curLotteryTime = ((WVRVideoEntityLive*)[self videoEntity]).totalLotteryTime;
        }];
    }
    return (WVRPlayerBannerLiveUIManager *)_playerUI;
}

#pragma mark - overwrite func

- (void)setupRequestRAC {
    
    @weakify(self);
    [[self.gLiveDetailViewModel gSuccessSignal] subscribeNext:^(WVRLiveItemModel *_Nullable x) {
        @strongify(self);
        if ([x.code isEqualToString:self.videoEntity.sid]) {
            if (_isDestroy) {
                return ;
            }
            [self dealWithDetailData:x];
        } else {
            NSLog(@"bannerLogs:不是当前Banner的详情");
        }
    }];
    
    [[self.gLiveDetailViewModel gFailSignal] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        
        SQToastInKeyWindow(kNetError);
    }];
}

- (void)buildInitData {
    if (![WVRReachabilityModel isNetWorkOK]) {
        return;
    }
    [super buildInitData];
}

- (void)requestForDetailData {
    
    [self startLoadPlay];
}

- (void)startLoadPlay
{
    if (![self playerUI].isGoUnity) {
        if (!self.vPlayer) {
            
            self.vPlayer = [[WVRPlayerHelper alloc] initWithContainerView:self.view MainController:self];
            self.vPlayer.playerDelegate = self;
            self.vPlayer.biModel.screenType = 1;
        }
        _isDestroy = NO;
        self.gLiveDetailViewModel.code = self.videoEntity.sid;
        NSLog(@"sid___: %@", self.videoEntity.sid);
        [self.gLiveDetailViewModel.gDetailCmd execute:nil];
        [self installAfterViewLoadForbanner];
    }
}

- (void)restartForLaunch {
    
    if ([self playerUI].dealWithUnityBack == WVRPlayerUnityBackDealRotation && ([self playerUI].tmpPlayerViewStatus == WVRPlayerUIViewStatusHalfVertical)) {
        [self playerUI].dealWithUnityBack = WVRPlayerUnityBackDealNothing;
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [[self playerUI] changeViewFrameForFull];
//            [[self playerUI] forceToOrientationMaskLandscapeRight:nil];
//        });
    } else if ([self playerUI].dealWithUnityBack == WVRPlayerUnityBackDealExit) {
        [self playerUI].dealWithUnityBack = WVRPlayerUnityBackDealNothing;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[self playerUI] changeViewFrameForSmall];
            [self destory];
        });
        return;
    }
    [self playerUI].dealWithUnityBack = WVRPlayerUnityBackDealNothing;
    
    if ([self playerUI].isGoUnity) {
        
        if (self.vPlayer.isFreeTimeOver) {
            
            // 试看结束后回来，不自动开播
            
        } else if (self.vPlayer.isOnDestroy || self.vPlayer.isReleased) {
            self.view.hidden = NO;
            [[self playerUI] execStalled];
            
            if ([self playerUI].isLandscape) {
                [WVRAppModel changeStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            }
            @weakify(self);
            __block RACDisposable *handler = [RACObserve([self playerUI], unityBackParams) subscribeNext:^(id x) {
                
                if (nil != x) {
                    
                    @strongify(self);
                    
                    [self dealwithUnityBackParams];
                    [handler dispose];
                }
            }];
            _rac_handler = handler;
        }
    } else if ([self playerUI].isGoUnityFootball) {
        if ([self playerUI].isLandscape) {
            [WVRAppModel changeStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        }
        [self startTimer];
        [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
    }
}

- (void)onVideoPrepared
{
    [super onVideoPrepared];
//    if (_isDestroy) {
//        [self destory];
//        return;
//    }
    long position = [self.vPlayer getCurrentPosition];
    long buffer = [self.vPlayer getPlayableDuration];
    [[self playerUI] execPositionUpdate:position buffer:buffer duration:[self.vPlayer getDuration]];
    self.view.hidden = NO;
    BOOL prepared = [self.delegate onVideoPrepared];
    if (prepared) {
        [self.vPlayer checkNetStatus];
    }
    _isPrepared = YES;
}

- (BOOL)respondNetStatusChange
{
    if (self.vPlayer.isPlaying || !_isDestroy) {
        return YES;
    }
    return NO;
}

- (void)onCompletion
{
    [self stopTimer];
    [[self playerUI] execCompletion];
}

- (void)onError:(int)code
{
    [super onError:code];
    [[self playerUI] actionBackBtnClick];
}

-(void)onBuffering
{
    [super onBuffering];
//    [self updatePlayStatus:WVRPlayerToolVStatusStop];
}

-(void)onBufferingOff
{
    [super onBufferingOff];
//    [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
}

-(void)stopForNext
{
    [self.vPlayer stop];
    self.view.hidden = YES;
}

-(void)destory
{
    _isDestroy = YES;
    _isPrepared = NO;
    self.view.hidden = YES;
//    self.videoEntity.sid = @"";
    [(WVRNavigationController *)self.navigationController setGestureInValid:NO];
    [[self playerUI] execSleepForControllerChanged];
    if (self.vPlayer.isValid) {
        self.vPlayer.dataParam.position = [self.vPlayer getCurrentPosition];
        [self.vPlayer stop];
        [[self playerUI] execSuspend];
    }
    [_playerUI.playerView removeFromSuperview];
    _playerUI = nil;
//    [[self playerUI].gGiftContainerCellViewModel.gGiftAnimationPresenter destryShowGiftStrategy];
    [self stopTimer];
}

-(void)destroyForUnity
{
    if (self.vPlayer.isValid) {
        [self.vPlayer destroyForUnity];
    }
    [self stopTimer];
}

-(void)start
{
    [self startTimer];
    if (!_isPrepared) {
        NSLog(@"当前banner没有准备好");
        return;
    }
    if (!self.vPlayer.isPlaying) {
        if ([self playerUI].gPlayViewStatus == WVRPlayerToolVStatusUserPause) {
            
        }else{
            [[self playerUI] execResume];
        }
    }
    self.view.hidden = NO;
}

-(void)restartUI
{
    [[self playerUI] execPlaying];
//    [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
}

-(void)pauseUI{
    [[self playerUI] execPause];
//    [self updatePlayStatus:WVRPlayerToolVStatusPause];
}

-(void)stop
{
    if (self.vPlayer.isPlaying) {
        [[self playerUI] execPause];
    }
}

- (void)liveDetailFailBlock
{
    
}

@end

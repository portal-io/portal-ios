//
//  WVRPlayerBannerController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerBannerController.h"
#import "WVRVideoDetailViewModel.h"
#import "WVRVideoEntity360.h"
#import "WVRLiveDetailViewModel.h"
#import "WVRPlayerBannerLiveUIManager.h"

@interface WVRPlayerBannerController (){
    
    BOOL _isPrepared;
    id _rac_handler;
}

@property (nonatomic, strong) WVRVideoDetailViewModel *gVideoDetailViewModel;
@property (nonatomic, weak) id<WVRPlayerBannerProtocol> delegate;

@property (nonatomic, weak) UIView * contentView;

@end


@implementation WVRPlayerBannerController
@synthesize gVideoDetailViewModel = _tmpVideoDetailViewModel;
@synthesize playerUI = _playerUI;

- (instancetype)initWithContentView:(UIView *)contentView delegate:(id<WVRPlayerBannerProtocol>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.contentView = contentView;
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self installAfterViewLoadForbanner];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    

}

- (void)viewDidDisappear:(BOOL)animated {
    
    UIViewController *currentVC = [UIViewController getCurrentVC];
    BOOL goUnity = [currentVC isKindOfClass:NSClassFromString(@"UnityViewControllerBase")];
    if (!goUnity) {
        [self playerUI].isGoUnity = NO;
        [self playerUI].isGoUnityFootball = NO;
    }
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

- (void)toOrientation
{
    
}

-(void)createLayoutView
{
    [super createLayoutView];
//    [self bindContentView];
}

-(void)updateContentView:(UIView*)contentView
{
    [[self playerUI] updateContentView:contentView];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

#pragma mark - setter getter

- (WVRVideoDetailViewModel *)gVideoDetailViewModel {
    
    if (!_tmpVideoDetailViewModel) {
        _tmpVideoDetailViewModel = [[WVRVideoDetailViewModel alloc] init];
    }
    return _tmpVideoDetailViewModel;
}

- (WVRPlayerBannerUIManager *)playerUI {
    
    if (!_playerUI) {
        _playerUI = [[WVRPlayerBannerUIManager alloc] init];
        _playerUI.videoEntity = [self videoEntity];
        _playerUI.detailBaseModel = [self detailBaseModel];
        _playerUI.vPlayer = self.vPlayer;
        _playerUI.uiDelegate = self;
        ((WVRPlayerBannerUIManager *)_playerUI).uiDelegate = self;
        [_playerUI installAfterSetParams];
    }
  
    return (WVRPlayerBannerUIManager *)_playerUI;
}

#pragma mark - overwrite func

- (void)setupRequestRAC {
    
    @weakify(self);
    [[self.gVideoDetailViewModel gSuccessSignal] subscribeNext:^(WVRVideoDetailVCModel *_Nullable x) {
        @strongify(self);
        if ([x.code isEqualToString:self.videoEntity.sid]) {
            if (self.isDestroy) {
                return ;
            }
            [self dealWithDetailData:x];
        } else {
            NSLog(@"bannerLogs:不是当前Banner的详情");
        }
    }];
    
    [[self.gVideoDetailViewModel gFailSignal] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        
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

- (void)startLoadPlay {
    
    if (![self playerUI].isGoUnity) {
        if (!self.vPlayer) {
            
            self.vPlayer = [[WVRPlayerHelper alloc] initWithContainerView:self.view MainController:self];
            self.vPlayer.playerDelegate = self;
            self.vPlayer.biModel.screenType = 1;
        }
        self.isDestroy = NO;
        
        self.gVideoDetailViewModel.code = self.videoEntity.sid;
        [self.gVideoDetailViewModel.gDetailCmd execute:nil];
    }
}

- (void)restartForLaunch {
    
    if ([self playerUI].dealWithUnityBack == WVRPlayerUnityBackDealRotation && ([self playerUI].tmpPlayerViewStatus == WVRPlayerUIViewStatusHalfVertical)) {
        [self playerUI].dealWithUnityBack = WVRPlayerUnityBackDealNothing;
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [[self playerUI] changeViewFrameForFull];
//        });
    } else if ([self playerUI].dealWithUnityBack == WVRPlayerUnityBackDealExit) {
        [self playerUI].dealWithUnityBack = WVRPlayerUnityBackDealNothing;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[self playerUI] changeViewFrameForSmall];
            [self destory];
        });
        return;
    }
    
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

- (void)dealWithDetailData:(WVRVideoDetailVCModel *)model {
    [super dealWithDetailData:model];

}


- (void)readyToPlay
{
    if (self.isDestroy) {
        [self destory];
        return;
    } else {
        [super readyToPlay];
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
//    [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
    BOOL prepared = [self.delegate onVideoPrepared];
    if (prepared) {
        [self.vPlayer checkNetStatus];
    }
    _isPrepared = YES;
}

- (BOOL)respondNetStatusChange
{
    if (self.vPlayer.isPlaying || !self.isDestroy) {
        return YES;
    }
    return NO;
}

- (void)onCompletion
{
    [self stopTimer];
    [[self playerUI] execCompletion];
}

- (void)onBuffering
{
    [super onBuffering];
}

- (void)onBufferingOff
{
    [super onBufferingOff];
}

- (void)updatePlayStatus:(WVRPlayerToolVStatus)status
{
    [[self playerUI] updatePlayStatus:status];
}

- (void)stopForNext
{
    [self.vPlayer stop];
    self.view.hidden = YES;
}

- (void)destory
{
    self.isDestroy = YES;
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
    [self stopTimer];
}

//- (void)destroyForUnity
//{
//    if (self.vPlayer.isValid) {
//        [self.vPlayer destroyForUnity];
//    }
//    [self stopTimer];
//}

- (void)recordHistory {
}

- (void)watch_online_record:(BOOL)isComin {
}

- (void)start
{
    [self stopTimer];
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

- (void)restartUI
{
//    [[self playerUI] execResume];
    [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
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

-(void)httpFailBlock
{
    
}
- (void)liveDetailFailBlock
{
    
}

@end

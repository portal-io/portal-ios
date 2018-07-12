//
//  WVRPlayerBannerUIManager.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerBannerUIManager.h"
#import "WVRPlayerBannerView.h"
#import "WVRPlayViewViewModel.h"
#import "WVRPlayerHelper+BI.h"
#import "UnityAppController.h"

@interface WVRPlayerBannerUIManager ()<WVRPlayerTopViewDelegate,WVRPlayerBottomViewDelegate, WVRPlayerLeftViewDelegate, WVRPlayRightViewDelegate, WVRSliderDelegate>

@property (nonatomic, strong) UIView * view;
@property (nonatomic, strong) UIView * gContentView;

@end


@implementation WVRPlayerBannerUIManager
@synthesize gPlayerViewAdapter = _gPlayerViewAdapter;
@synthesize gTopCellViewModel = _gTopCellViewModel;
@synthesize gLeftCellViewModel = _gLeftCellViewModel;
@synthesize gRightCellViewModel = _gRightCellViewModel;
@synthesize gBottomCellViewModel = _gBottomCellViewModel;
@synthesize gLodingCellViewModel = _gLodingCellViewModel;
@synthesize gVRLoadingCellViewModel = _gVRLoadingCellViewModel;

- (WVRPlayLoadingCellViewModel *)gVRLoadingCellViewModel
{
    if (!_gVRLoadingCellViewModel) {
        WVRPlayLoadingCellViewModel * cur = [super gVRLoadingCellViewModel];
        cur.playStatus = WVRPlayerToolVStatusDefault;
        _gVRLoadingCellViewModel = cur;
    }
    return _gVRLoadingCellViewModel;
}

-(WVRPlayLoadingCellViewModel *)gLodingCellViewModel
{
    if (!_gLodingCellViewModel) {
        WVRPlayLoadingCellViewModel * cur = [super gLodingCellViewModel];
        cur.playStatus = WVRPlayerToolVStatusDefault;
        _gLodingCellViewModel = cur;
    }
    return _gLodingCellViewModel;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (WVRPlayerViewAdapter *)gPlayerViewAdapter
{
    if (!_gPlayerViewAdapter) {
        _gPlayerViewAdapter = [[WVRPlayerViewAdapter alloc] init];
        [_gPlayerViewAdapter loadData:self.gPlayAdapterOriginDic];
    }
    return _gPlayerViewAdapter;
}

-(WVRPlayTopCellViewModel *)gTopCellViewModel
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

-(WVRPlayBottomCellViewModel *)gBottomCellViewModel
{
    if (!_gBottomCellViewModel) {
        WVRPlayBottomCellViewModel * bottomViewModel = [[WVRPlayBottomCellViewModel alloc] init];
        bottomViewModel.cellNibName = @"WVRPlayerSmallBottomView";
        bottomViewModel.delegate = self;
        bottomViewModel.height = HEIGHT_BOTTOM_VIEW_ADJUST;
        bottomViewModel.defiTitle = [self definitionToTitle:self.videoEntity.curDefinition];
        _gBottomCellViewModel = bottomViewModel;
    }
    return _gBottomCellViewModel;
}

-(WVRPlayLeftCellViewModel *)gLeftCellViewModel
{
    if (!_gLeftCellViewModel) {
        _gLeftCellViewModel = [[WVRPlayLeftCellViewModel alloc] init];
        _gLeftCellViewModel.cellNibName = @"WVRPlayerLeftView";
        _gLeftCellViewModel.delegate = self;
        _gLeftCellViewModel.width = WIDTH_LEFT_VIEW_DEFAULT;
    }
    return _gLeftCellViewModel;
}

-(WVRPlayRightCellViewModel *)gRightCellViewModel
{
    if (!_gRightCellViewModel) {
        _gRightCellViewModel = [[WVRPlayRightCellViewModel alloc] init];
        _gRightCellViewModel.cellNibName = @"WVRPlayerRightView";
        _gRightCellViewModel.delegate = self;
        _gRightCellViewModel.width = WIDTH_RIGHT_VIEW_DEFAULT;
    }
    return _gRightCellViewModel;
}


-(void)bindContentView
{
    [self.view removeFromSuperview];
    [self.gContentView addSubview:self.view];
    [self.gContentView bringSubviewToFront:self.view];
    if (self.gContentView) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        //        [self addPlayerViewCont:self.view inSec:self.gContentView];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gContentView);
            make.right.equalTo(self.gContentView);
            make.top.equalTo(self.gContentView);
            make.bottom.equalTo(self.gContentView);
        }];
    }
}

-(void)updateContentView:(UIView*)contentView
{
    self.gContentView = contentView;
    [self bindContentView];
    [self updateLockStatus:WVRPlayerToolVStatusNotLock];
    [self updatePlayStatus:WVRPlayerToolVStatusDefault];
    [self.playerView controlsShowHideAnimation:NO];
    [self.playerView reloadData];
}

- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView {
    
//    BOOL isFullScreen = [self.uiDelegate isKindOfClass:NSClassFromString(@"WVRPlayerVC")];
    
    // live 已经重写该方法
//    WVRPlayerViewStyle style = isFullScreen ? WVRPlayerViewStyleLandscape : WVRPlayerViewStyleHalfScreen;
    self.view = containerView;
    float height = containerView.height;
    float width = containerView.width;
    CGRect rect = CGRectMake(0, 0, MAX(width, height), MIN(width, height));
    
//    NSDictionary *veDict = [[self videoEntity] yy_modelToJSONObject];
//    WVRPlayerBannerView *view = [[WVRPlayerBannerView alloc] initWithFrame:rect style:style videoEntity:veDict delegate:self];
    WVRPlayerBannerView *view = [[WVRPlayerBannerView alloc] initWithFrame:rect];
    view.dataSource = self.gPlayerViewAdapter;
    view.delegate = self;
    view.realDelegate = self;
    [containerView addSubview:view];
    self.playerView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(view.superview);
    }];
    [self.playerView fillData:self.gPlayViewViewModel];
    self.playerView.dataSource = self.gPlayerViewAdapter;
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    [self bindContentView];
    [self.playerView reloadData];
    return view;
}

#pragma mark - overwrite WVRPlayerUIManagerProtocol

- (void)forceToOrientationPortraitWithAnimation:(void (^)(void))animationBlock completion:(void (^)(void))completionBlock {
    
    [super forceToOrientationPortraitWithAnimation:^{
        if ([self.uiDelegate respondsToSelector:@selector(rotaionAnimations:)]) {
            [self.uiDelegate rotaionAnimations:NO];
        }
        if (animationBlock) {
            animationBlock();
        }
    } completion:^{
        if (completionBlock) {
            completionBlock();
        }
        
        [self updateLockStatus:WVRPlayerToolVStatusNotLock];
        UIView *playerStartV = nil;
        for (UIView *tmpV in self.playerView.subviews) {
            if ([tmpV isKindOfClass:NSClassFromString(@"WVRPlayerStartView")]) {
                playerStartV = tmpV;
                break;
            }
        }
        if (playerStartV) {
            [self.playerView bringSubviewToFront:playerStartV];
        }
    }];
}

#pragma mark - WVRPlayerBottomViewDelegate

- (BOOL)playOnClick:(BOOL)isPlay {
    self.gIsUserPause = !isPlay;
    BOOL result = [super playOnClick:isPlay];
//    if (![self.vPlayer isPlaying]) {
//    if (!isPlay) {
//        [self updatePlayStatus:WVRPlayerToolVStatusUserPause];
//    }else{
//        [self updatePlayStatus:WVRPlayerToolVStatusPlaying];
//    }
    return result;
}

- (void)fullOnClick:(UIButton *)sender {
    
    [self changeViewFrameForFull];
}

- (void)changeViewFrameForFull {
    [super changeViewFrameForFull];
    
    [self updateOriginDicForFull];
    UIViewController * vc = [UIViewController getCurrentVC];
    [vc.view addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vc.view);
        make.right.equalTo(vc.view);
        make.top.equalTo(vc.view);
        make.bottom.equalTo(vc.view);
    }];
    vc.tabBarController.tabBar.hidden = YES;
    
    kWeakSelf(self);
    [self forceToOrientationMaskLandscapeRight:^{
        [weakself.vPlayer trackEventForStartPlay];
    }];
}

-(void)updateOriginDicForFull
{
    [self.view removeFromSuperview];
}

- (void)launchOnClick:(UIButton *)sender {

    [self actionSwitchVR];
}

#pragma mark - WVRPlayerTopViewDelegate

- (void)backOnClick:(UIButton *)sender
{
    [self changeViewFrameForSmall];
}

- (void)actionBackBtnClick
{
    [self changeViewFrameForSmall];
}

#pragma mark - WVR

- (void)changeViewFrameForSmall {
    
    [self.vPlayer trackEventForEndPlay];
    
    [super changeViewFrameForSmall];
    [self updateOriginDicForSmall];
    [self.view removeFromSuperview];
    [self.gContentView addSubview:self.view];
    [self.gContentView bringSubviewToFront:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gContentView);
        make.right.equalTo(self.gContentView);
        make.top.equalTo(self.gContentView);
        make.bottom.equalTo(self.gContentView);
    }];
    
    UnityAppController *app = [UIApplication sharedApplication].delegate;
    UITabBarController *tab = app.tabBarController;
    UINavigationController *nav = tab.selectedViewController;
    
    if ([nav isKindOfClass:[UINavigationController class]] && nav.viewControllers.count == 1) {
        nav.tabBarController.tabBar.hidden = NO;
    }
    
    [self forceToOrientationPortrait];
    [self showStatusBar];
    if (self.vPlayer.isPlayError) {
        [self updateViewShowStatusForError];
    }
}

-(void)updateOriginDicForSmall
{
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    self.gBottomCellViewModel.cellNibName = @"WVRPlayerSmallBottomView";
}

#pragma mark - WVRPlayerLeftViewDelegate

-(void)clockOnClick:(BOOL)isClock
{
    if (isClock) {
        [self updateLockStatus:WVRPlayerToolVStatusLock];
    } else {
        [self updateLockStatus:WVRPlayerToolVStatusNotLock];
    }
}

#pragma mark - WVRPlayRightViewDelegate

-(void)resetBtnOnClick:(UIButton *)sender
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
    //    if ([self isPlaying]) {
    //    [self pause];
    [self.vPlayer seekTo:sender.value*[self.vPlayer getDuration]];
    //    [self.mLoadingV startAnimating:NO];
    [self updatePlayStatus:WVRPlayerToolVStatusSliding];
    long curPosition = sender.value*[self.vPlayer getDuration];
    long bufferPosition = [self.vPlayer getPlayableDuration];
    long duration = [self.vPlayer getDuration];
    self.gBottomCellViewModel.duration = duration;
    self.gBottomCellViewModel.bufferPosition = bufferPosition;
    self.gBottomCellViewModel.position = curPosition;
    //    }
}

- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration {
    [super execPositionUpdate:posi buffer:bu duration:duration];
    
    self.gBottomCellViewModel.duration = duration;
    self.gBottomCellViewModel.bufferPosition = bu;
    self.gBottomCellViewModel.position = posi;
}

-(void)updateLockStatus:(WVRPlayerToolVStatus)status
{
//    self.gPlayViewStatus = status;
    self.gPlayViewViewModel.lockStatus = status;
    self.gTopCellViewModel.lockStatus = status;
    self.gBottomCellViewModel.lockStatus = status;
    self.gLeftCellViewModel.lockStatus = status;
    self.gRightCellViewModel.lockStatus = status;
}

- (void)execPreparedWithDuration:(long)duration
{
    [super execPreparedWithDuration:duration];
    
    UIView *playerStartV = nil;
    for (UIView *tmpV in self.playerView.subviews) {
        if ([tmpV isKindOfClass:NSClassFromString(@"WVRPlayerStartView")]) {
            playerStartV = tmpV;
            break;
        }
    }
    if (playerStartV) {
        [self.playerView bringSubviewToFront:playerStartV];
    }
}

- (void)execError:(NSString *)message code:(NSInteger)code {
    
    [super execError:message code:code];
    [self updateViewShowStatusForError];
}

-(void)updateViewShowStatusForError
{
    if ([WVRAppContext sharedInstance].gSupportedInterfaceO == UIInterfaceOrientationMaskPortrait) {
        self.view.hidden = YES;
    }else{
        self.view.hidden = NO;
    }
}
@end

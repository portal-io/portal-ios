//
//  WVRPlayerBannerLiveUIManager.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerBannerLiveUIManager.h"
#import "WVRPlayerBannerView.h"
#import "WVRPlayerBannerViewAdapter.h"
#import "WVRPlayLiveTopCellViewModel.h"
#import "WVRPlayLiveBottomCellViewModel.h"
#import "WVRPlayViewViewModel.h"
#import "WVRUMShareView.h"
#import "WVRVideoEntityLive.h"
#import "WVRPlayerHelper+BI.h"
#import "WVRProgramBIModel.h"

#import "UnityAppController.h"

@interface WVRPlayerBannerLiveUIManager()<WVRPlayLiveTopViewDelegate,WVRPlayerBottomViewDelegate,WVRPlayerLiveBottomViewDelegate>

@property (nonatomic, strong) UIView * view;
@property (nonatomic, strong) UIView * gContentView;

@end


@implementation WVRPlayerBannerLiveUIManager
@synthesize gPlayerViewAdapter = _gPlayerViewAdapter;
@synthesize gTopCellViewModel = _gTopCellViewModel;
@synthesize gLeftCellViewModel = _gLeftCellViewModel;
@synthesize gRightCellViewModel = _gRightCellViewModel;
@synthesize gBottomCellViewModel = _gBottomCellViewModel;

- (void)addComponentsForFullScreenLive {        // 全屏直播才执行此方法，子类重写
    
}

- (void)refreshLiveAlertInfo {
    
    ((WVRPlayLiveTopCellViewModel*)self.gTopCellViewModel).beginTime = [(WVRVideoEntityLive*)[self videoEntity] beginTime];
    self.gTopCellViewModel.title = [self videoEntity].videoTitle;
    ((WVRPlayLiveTopCellViewModel*)self.gTopCellViewModel).address = [(WVRVideoEntityLive*)[self videoEntity] address];
    ((WVRPlayLiveTopCellViewModel*)self.gTopCellViewModel).intro = [(WVRVideoEntityLive*)[self videoEntity] intro];
    ((WVRPlayLiveTopCellViewModel*)self.gTopCellViewModel).playCount = [self videoEntity].biEntity.playCount;
}

- (WVRPlayTopCellViewModel *)gTopCellViewModel
{
    if (!_gTopCellViewModel) {
        WVRPlayLiveTopCellViewModel * topCellViewModel = [[WVRPlayLiveTopCellViewModel alloc] init];
        topCellViewModel.delegate = self;
        topCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];

        topCellViewModel.height = HEIGHT_TOP_VIEW_LIVE_H;
        _gTopCellViewModel = (WVRPlayTopCellViewModel *)topCellViewModel;
    }
    return _gTopCellViewModel;
}

- (WVRPlayBottomCellViewModel *)gBottomCellViewModel
{
    if (!_gBottomCellViewModel) {
        WVRPlayLiveBottomCellViewModel *bottomCellViewModel = [[WVRPlayLiveBottomCellViewModel alloc] init];
        bottomCellViewModel.delegate = self;
        bottomCellViewModel.cellNibName = @"WVRPlayLiveBannerBottomCell";
        bottomCellViewModel.height = HEIGHT_BOTTOM_VIEW_LIVE;
        _gBottomCellViewModel = (WVRPlayBottomCellViewModel *)bottomCellViewModel;
    }
    return _gBottomCellViewModel;
}

- (void)bindContentView
{
    [self.view removeFromSuperview];
    [self.gContentView addSubview:self.view];
    [self.gContentView bringSubviewToFront:self.view];
    if (self.gContentView) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self addPlayerViewCont:self.view inSec:self.gContentView];
    }
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gContentView);
        make.right.equalTo(self.gContentView);
        make.top.equalTo(self.gContentView);
        make.bottom.equalTo(self.gContentView);
    }];
}

-(void)updateContentView:(UIView*)contentView
{
    self.gContentView = contentView;
    [self bindContentView];
    
    [self updatePlayStatus:WVRPlayerToolVStatusDefault];
    [[self playerView] controlsShowHideAnimation:NO];
}

- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView {
    self.view = containerView;
    float height = containerView.height;
    float width = containerView.width;
    CGRect rect = CGRectMake(0, 0, MAX(width, height), MIN(width, height));
    WVRPlayerViewLive *view = [[WVRPlayerViewLive alloc] initWithFrame:rect];
    view.delegate = self;
    view.realDelegate = self;
    [containerView addSubview:view];
    self.playerView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(view.superview);
    }];
    [[self playerView] fillData:self.gPlayViewViewModel];
    [self playerView].dataSource = self.gPlayerViewAdapter;
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kLEFT_PLAYVIEW];
    [self.gPlayAdapterOriginDic removeObjectForKey:kRIGHT_PLAYVIEW];
    [[self playerView] reloadData];
    [self bindContentView];
    [self registerObserverEvent];
    return view;
}

- (WVRPlayerViewAdapter *)gPlayerViewAdapter
{
    if (!_gPlayerViewAdapter) {
        _gPlayerViewAdapter = [[WVRPlayerViewAdapter alloc] init];
        [_gPlayerViewAdapter loadData:self.gPlayAdapterOriginDic];
    }
    return _gPlayerViewAdapter;
}

/// overwrite banner比较特殊 转全屏的时候才加组件
- (void)updateAfterSetParams {
    [self installGiftPresenter];
}

#pragma mark - WVRPlayerBottomViewDelegate

- (BOOL)playOnClick:(BOOL)isPlay {
    
    BOOL result = [super playOnClick:isPlay];
    return result;
}

- (void)fullOnClick:(UIButton *)sender {
    
    [self changeViewFrameForFull];
    
    [self forceToOrientationMaskLandscapeRight:nil];
}

- (void)addComponents
{
    if (self.components.count == 0) {
        
        [super addComponents];
    }
}

- (void)addBlurBackgroundController {
}

- (void)changeViewFrameForFull {
    [super changeViewFrameForFull];
    
    [self addComponents];
    [self deliveryEventToComponents:@"playerui_setMonocular" params:@{ @"isMonocular": @(self.isNotMonocular) }];
    
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
    [self execDanmuSwitch:[(WVRVideoEntityLive *)[self videoEntity] danmuSwitch]];
    [self execLotterySwitch:[(WVRVideoEntityLive *)[self videoEntity] lotterySwitch]];
    [self execEasterEggCountdown:((WVRVideoEntityLive *)[self videoEntity]).curLotteryTime];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
        [self.vPlayer trackEventForStartPlay];
    });
}

// banner全屏必须主动刷新一下viewModel的数据信息(title .eg)
- (void)updateOriginDicForFull
{
    // 转到全屏时，判断是否显示车展直播的机位
    self.gBottomCellViewModel.showCameraBtn = [self.detailBaseModel.type isEqualToString:CONTENTTYPE_LIVE_CAR];
    
    ((WVRPlayLiveTopCellViewModel *)self.gTopCellViewModel).playCount = self.videoEntity.biEntity.playCount;
    self.gTopCellViewModel.title = self.videoEntity.videoTitle;
//    self.gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
    if (((WVRVideoEntityLive *)[self videoEntity]).displayMode == WVRLiveDisplayModeHorizontal) {
        self.gTopCellViewModel.cellNibName = @"WVRPlayerFullLiveTopView";
    } else {
        self.gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
        self.gTopCellViewModel.height = HEIGHT_TOP_VIEW_LIVE;
    }
    self.gBottomCellViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
    // 初始化
    self.gPlayAdapterOriginDic[kGIFTCONTAINER_PLAYVIEW] = self.gGiftContainerCellViewModel;
}

- (void)forceToOrientationMaskLandscapeRight
{
    [self forceToOrientationMaskLandscapeRight:nil];
}

- (void)forceToOrientationMaskLandscapeRight:(void (^)(void))completionBlock {
    
    if (self.isNotMonocular) {
        
        [super forceToOrientationMaskLandscapeRight:completionBlock];
        
    } else if ([(WVRVideoEntityLive *)self.videoEntity displayMode] == WVRLiveDisplayModeVertical) {
        [WVRAppContext sharedInstance].gStatusBarHidden = YES;//必须成对调用
        UIViewController * vc = [UIViewController getCurrentVC];
        if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [vc prefersStatusBarHidden];
            [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
//        [WVRAppContext sharedInstance].gStatusBarHidden = NO;
        [[self playerView] reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (completionBlock) {
                completionBlock();
            }
        });
        
    } else {
        [super forceToOrientationMaskLandscapeRight:completionBlock];
    }
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
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
    
    [self updateOriginDicForSmall];
    [self removeUIComponents];              // 这里banner移除组件
    [self.view removeFromSuperview];
    [self.gContentView addSubview:self.view];
    [self.gContentView bringSubviewToFront:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gContentView);
        make.right.equalTo(self.gContentView);
        make.top.equalTo(self.gContentView);
        make.bottom.equalTo(self.gContentView);
    }];
    
    UnityAppController *app = (id)[UIApplication sharedApplication].delegate;
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

#pragma mark - WVRPlayLiveTopViewDelegate

- (void)shareOnClick:(WVRPlayerLiveTopView *)view {
//    kWeakSelf(self);
    //    [[self playerUI] scheduleHideControls];
    //    [self controlOnPause];
    
    WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:[UIViewController getCurrentVC].view
                                                                   sID:self.videoEntity.sid
                                                               iconUrl:[(WVRVideoEntityLive *)self.videoEntity icon]
                                                                 title:[(WVRVideoEntityLive *)self.videoEntity videoTitle]
                                                                 intro:@""
                                                                 mobId:nil
                                                             shareType:WVRShareTypeLive];
    shareView.cancleBlock = ^() {
//        [self controlOnResume];
    };
}

#pragma mark - WVR

- (void)updateOriginDicForSmall
{
    [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
    ((WVRPlayLiveBottomCellViewModel *)self.gBottomCellViewModel).cellNibName = @"WVRPlayLiveBannerBottomCell";
    // 初始化
    [self.gPlayAdapterOriginDic removeObjectForKey:kGIFTCONTAINER_PLAYVIEW];
//    [[self playerView] reloadData];
}

- (void)execPreparedWithDuration:(long)duration
{
    [super execPreparedWithDuration:duration];
    
}

- (void)execUpdateDefiBtnTitle {
    [super execUpdateDefiBtnTitle];
    
//    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:[self videoEntity].curDefinition];
}

#pragma mark - BI

/// 对应BI埋点的pageId字段，直播预告页面已重写该方法
- (NSString *)currentPageId {
    
    return @"liveDetails";
}

- (NSString *)videoFormat {
    
    return self.detailBaseModel.videoType;
}

- (NSString *)biPageName {
    
    return self.detailBaseModel.title;
}

- (NSString *)biPageId {
    
    return self.detailBaseModel.sid;
}

- (NSString *)biContentType {
    
    return self.detailBaseModel.type;
}

- (int)biIsChargeable {
    
    return self.detailBaseModel.isChargeable;
}

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.currentPageId = [self currentPageId];
    model.biPageId = [self biPageId];
    model.biPageName = [self biPageName];
    model.videoFormat = [self videoFormat];
    model.contentType = [self biContentType];
    model.isChargeable = [self biIsChargeable];
    model.isProgram = YES;
    
    return model;
}

- (void)execError:(NSString *)message code:(NSInteger)code {
    
    [super execError:message code:code];
    [self updateViewShowStatusForError];
}

- (void)updateViewShowStatusForError
{
    if ([WVRAppContext sharedInstance].gSupportedInterfaceO == UIInterfaceOrientationMaskPortrait) {
        self.view.hidden = YES;
    } else {
        self.view.hidden = NO;
    }
}
@end

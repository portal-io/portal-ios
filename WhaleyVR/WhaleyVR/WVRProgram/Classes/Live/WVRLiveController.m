//
//  WVRLiveController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveController.h"


#import "WVRSQFindUIStyleHeader.h"

#import "SQRefreshHeader.h"
#import "WVRGotoNextTool.h"

#import "SQPageView.h"
#import "SQCollectionView.h"

#import "WVRLiveNoticePresenter.h"
#import "WVRLiveReViewPresenter.h"
#import "WVRLiveTopBarPresenter.h"
#import "WVRLiveRecommendPresenter.h"

#import "WVRLiveRecommendPresenter.h"
#import "WVRLiveShowPresenter.h"
#import "WVRSmallPlayerPresenter.h"
#import "WVRLiveTabTipView.h"
#import "WVRFootballPresenter.h"
#import "WVRBaseSubPagePresenter.h"
#import "WVRLivePagePresenter.h"
#import "WVRLiveViewControllerProtocol.h"
#import "WVRLiveTopTab.h"
#import "WVRPageView.h"
#import "WVRMyReservationController.h"

#import "WVRMediator+AccountActions.h"

#import "WVRSpring2018Manager.h"

#define HEIGHT_TTVIEW (50 + kStatuBarHeight)

#define LIVE_PAGE_REQUEST_PARAM (@"live_tab")

@interface WVRLiveController ()<WVRTopTabViewDelegate, WVRLiveViewControllerProtocol>

@property (nonatomic, strong) WVRLiveTopBarPresenter* gTopBarPresenter;

@property (nonatomic, strong) WVRLivePagePresenter* gPagePresenter;

@property (nonatomic, strong) WVRPageView * mPageView;

@property (nonatomic, strong) WVRLiveTopTab * mTopTabBar;

@property (nonatomic) NSArray * mSubPresenters;

@property (nonatomic) NSArray * mSubViews;

@property (nonatomic) BOOL preIsPlaying;

@property (nonatomic) NSInteger mCurPageIndex;

@property (nonatomic) NSInteger mRecommendIndex;

@property (nonatomic) WVRLiveTabTipView * mTipV;

@property (nonatomic) BOOL mTTLoadSuccess;

@end


@implementation WVRLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mPageView];
    self.view.backgroundColor = k_Color11;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
//        [[WVRSmallPlayerPresenter shareInstance] restartForLaunch];
    } else {
//        [WVRAppContext sharedInstance].gShouldAutorotate = YES;
//        [WVRAppContext sharedInstance].gSupportedInterfaceO = UIInterfaceOrientationMaskPortrait;
//        UIInterfaceOrientation ori = UIInterfaceOrientationPortrait;
//        [WVRAppModel forceToOrientation:ori];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
        [[WVRSmallPlayerPresenter shareInstance] restartForLaunch];
    } else {
        if (self.mCurPageIndex == self.mRecommendIndex) {
            if([self prefersStatusBarHidden]){
                [[WVRSmallPlayerPresenter shareInstance] start];
                return;
            }
            [[WVRSmallPlayerPresenter shareInstance] updateCanPlay:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_LIVE_TAB_RELOAD_PLAYER object:nil];
        }
    }
    [WVRSpring2018Manager addHomePageEntryForSpring2018];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
    
    } else {
        if (self.mCurPageIndex == self.mRecommendIndex) {
            if ([WVRAppContext sharedInstance].gStatusBarHidden) {
                [[WVRSmallPlayerPresenter shareInstance] stop];
                return;
            }
            [[WVRSmallPlayerPresenter shareInstance] destroy];
        }
    }
}

-(NSInteger)mRecommendIndex
{
    return self.gTopBarPresenter.gMixPageIndex;
}

- (WVRLiveTopTab *)mTopTabBar
{
    if (!_mTopTabBar) {
        _mTopTabBar = [[WVRLiveTopTab alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_TTVIEW)];
        _mTopTabBar.delegate = self;
        [self.view addSubview:_mTopTabBar];
    }
    return _mTopTabBar;
}

-(WVRPageView *)mPageView
{
    if (!_mPageView) {
        WVRPageView * pageV = [[WVRPageView alloc] initWithFrame:CGRectMake(0, self.mTopTabBar.bottomY, SCREEN_WIDTH, self.view.height-self.mTopTabBar.bottomY-kTabBarHeight)];
        _mPageView = pageV;
        _mPageView.delegate = self.gPagePresenter;
        _mPageView.dataSource = self.gPagePresenter;
        [self.view addSubview:pageV];
    }
    return _mPageView;
}

-(void)fetchData
{
    [self requestInfo];
}

-(void)requestInfo
{
    [[WVRSmallPlayerPresenter shareInstance] updateCanPlay:YES];
    [self.gTopBarPresenter requestInfo:LIVE_PAGE_REQUEST_PARAM];
}

-(WVRLiveTopBarPresenter *)gTopBarPresenter
{
    if (!_gTopBarPresenter) {
        _gTopBarPresenter = [[WVRLiveTopBarPresenter alloc] initWithParams:LIVE_PAGE_REQUEST_PARAM attchView:self];
    }
    return _gTopBarPresenter;
}

-(WVRLivePagePresenter *)gPagePresenter
{
    if (!_gPagePresenter) {
        _gPagePresenter = [[WVRLivePagePresenter alloc] initWithParams:nil attchView:self];
    }
    return _gPagePresenter;
}

- (void)destroy {
    
    self.mSubViews = nil;
    self.mSubPresenters = nil;
}

- (void)addTipView {
    
    if (![WVRUserModel sharedInstance].liveTipIsShow) {
        WVRLiveTabTipView * tipV = (WVRLiveTabTipView *)VIEW_WITH_NIB(NSStringFromClass([WVRLiveTabTipView class]));
        tipV.frame = self.view.bounds;
        [tipV.tipBtn addTarget:self action:@selector(dismissTipV) forControlEvents:UIControlEventTouchUpInside];
        self.mTipV = tipV;
        [[UIApplication sharedApplication].keyWindow addSubview:tipV];
        [WVRUserModel sharedInstance].liveTipIsShow = YES;
    }
}

- (void)dismissTipV {
    
    [self.mTipV removeFromSuperview];
    self.mTipV = nil;
}

#pragma mark - WVRPageViewProtocol

- (void)scrolling:(CGFloat)scale flag:(BOOL)bigFlag
{
    NSLog(@"scale:%f",scale);
    [self.mTopTabBar scrolling:scale flag:bigFlag];
}

-(void)scrollingToPageNamber:(NSInteger)index
{
    NSLog(@"index: %d",(int)index);
    //    [self.mTopTabBar scrolling];
}

-(void)scrollToPageNamber:(NSInteger)index
{
    float xx = self.mPageView.frame.size.width * index;
    [self.mPageView scrollRectToVisible:CGRectMake(xx, 0, self.mPageView.frame.size.width, self.mPageView.frame.size.height) animated:YES];
    [self.gPagePresenter updatePageView:index];
    
}

-(void)scrollViewDidEndDecelerating:(NSUInteger)index
{
    [self.mTopTabBar updateSegmentSelectIndex:index];
}

-(void)reloadData
{
    [self.mPageView reloadData];
}

#pragma mark - WVRTopTabViewProtocol


-(void)updateWithTitles:(NSArray *)titles andItemModels:(NSArray *)itemModels
{
    [self addTipView];
    [self.mTopTabBar updateWithTitles:titles scrollView:self.mPageView];
    
    [self.gPagePresenter setArgs:itemModels];
    [self.gPagePresenter fetchData];
}

#pragma mark - WVRTopTabViewDelegate

-(void)didSelectSegmentItem:(NSInteger)index;
{
    self.mCurPageIndex = index;
    float xx = self.mPageView.frame.size.width * index;
    [self.mPageView scrollRectToVisible:CGRectMake(xx, 0, self.mPageView.frame.size.width, self.mPageView.frame.size.height) animated:YES];
    [self.gPagePresenter updatePageView:index];
}

-(void)didSelectRightItem;
{
    if ([[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:nil]) {
        WVRMyReservationController * vc = [WVRMyReservationController new];
        vc.title = @"我的预约";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    
//    BOOL isRight = [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait;
    
    return [WVRAppContext sharedInstance].gStatusBarHidden;     // _isLandspace
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}

- (void)dealloc {
    
    DDLogInfo(@"");
}

#pragma mark - orientation

- (BOOL)shouldAutorotate {
    
    return [WVRAppContext sharedInstance].gShouldAutorotate;//self.hidenStatusBar;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif 
{
    return [WVRAppContext sharedInstance].gSupportedInterfaceO;//UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [WVRAppContext sharedInstance].gPreferredInterfaceO;
}

@end

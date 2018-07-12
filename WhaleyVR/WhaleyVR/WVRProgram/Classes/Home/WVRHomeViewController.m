//
//  WVRHomeViewController.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHomeViewController.h"
#import "WVRRecommendPageMIXView.h"
#import "WVRSearchViewController.h"
#import "WVRCheckVersionTool.h"

#import "WVRTopBarPresenter.h"
#import "WVRFindNavBarView.h"
#import "WVRFindSearchBar.h"

#import "WVRTopTabView.h"
#import "WVRTopBarPresenter.h"
#import "WVRPageView.h"
#import "WVRHomePagePresenter.h"

#import "WVRSmallPlayerPresenter.h"

#import "WVRHistoryController.h"
#import "WVRAllChannelController.h"

#import "WVRHomePresenter.h"

#import "WVRHomeViewControllerProtocol.h"

#import "WVRMediator+SettingActions.h"
#import "WVRSpring2018Manager.h"

#define COUNT_PAGES (2)

#define STR_RECOMMEND_TYPE (@"recommend_newhome")

@interface WVRHomeViewController ()<WVRTopTabViewDelegate, WVRHomeViewControllerProtocol>

@property (nonatomic, strong) WVRHomePresenter * gHomePresenter;

@property (nonatomic, strong) WVRPageView * mPageView;

@property (nonatomic, strong) WVRFindNavBarView * mNavBarV;

@property (nonatomic, strong) WVRTopTabView * mTopTabBar;

@end


@implementation WVRHomeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubViews];
    [self.gHomePresenter fetchData];
    self.view.backgroundColor = [UIColor whiteColor];
//    [WVRCheckVersionTool checkHaveNewVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
        
    } else {
        [WVRAppContext sharedInstance].gShouldAutorotate = YES;
        [WVRAppContext sharedInstance].gSupportedInterfaceO = UIInterfaceOrientationMaskPortrait;
        UIInterfaceOrientation ori = UIInterfaceOrientationPortrait;
        [WVRAppModel forceToOrientation:ori];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
        [[WVRSmallPlayerPresenter shareInstance] restartForLaunch];
//        [[WVRSmallPlayerPresenter shareInstance] setIsLaunch:NO];
    } else {
        if ([self prefersStatusBarHidden]) {
            [[WVRSmallPlayerPresenter shareInstance] start];
            return;
        }
        [self.gHomePresenter.gPagePresenter updatePlayerStatusForCurIndex];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_HANDLE_JPUSH_NOT object:nil];
    [WVRAppContext sharedInstance].gHomeDidAppear = YES;
    
    [WVRSpring2018Manager addHomePageEntryForSpring2018];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
//        [[WVRSmallPlayerPresenter shareInstance] destroyForLauncher];
    }
    else{
        if([self prefersStatusBarHidden]){
            [[WVRSmallPlayerPresenter shareInstance] stop];
            return;
        }
        [[WVRSmallPlayerPresenter shareInstance] destroy];
    }
}

- (void)dealloc
{
    DDLogInfo(@"");
}

- (void)loadSubViews
{
    WVRFindNavBarView *navBarV = [[WVRFindNavBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavBarHeight)];//(WVRFindNavBarView *)VIEW_WITH_NIB(NSStringFromClass([WVRFindNavBarView class]));
    kWeakSelf(self);
    navBarV.startSearchClickBlock = ^{
        [weakself searchButtonClicked];
    };
    navBarV.cacheClickBlock = ^{
        [weakself cacheButtonClicked];
    };
    navBarV.historyClickBlock = ^{
        [weakself historyButtonClicked];
    };
    self.mNavBarV = navBarV;
    [self.view addSubview:navBarV];
    
    WVRTopTabView * topTabBar = [[WVRTopTabView alloc] initWithFrame:CGRectMake(0, navBarV.bottomY, SCREEN_WIDTH, fitToWidth(45.f))];
    topTabBar.delegate = self;
    
    self.mTopTabBar = topTabBar;
    [self.view addSubview:topTabBar];
    
    WVRPageView * pageV = [[WVRPageView alloc] initWithFrame:CGRectMake(0, topTabBar.bottomY, SCREEN_WIDTH, self.view.height-topTabBar.bottomY-kTabBarHeight)];
    self.mPageView = pageV;
    self.mPageView.delegate = self.gHomePresenter.gPagePresenter;
    self.mPageView.dataSource = self.gHomePresenter.gPagePresenter;
    [self.view addSubview:pageV];
}

#pragma mark - getter

- (WVRHomePresenter *)gHomePresenter
{
    if (!_gHomePresenter) {
        _gHomePresenter = [[WVRHomePresenter alloc] initWithParams:nil attchView:self];
    }
    return _gHomePresenter;
}

#pragma mark - WVRPageViewProtocol

- (void)scrolling:(CGFloat)scale flag:(BOOL)bigFlag
{
    NSLog(@"scale:%f",scale);
    [self.mTopTabBar scrolling:scale flag:bigFlag];
}

- (void)scrollingToPageNamber:(NSInteger)index
{
    NSLog(@"index: %d",(int)index);
//    [self.mTopTabBar scrolling];
}

- (void)scrollToPageNamber:(NSInteger)index
{
    float xx = self.mPageView.frame.size.width * index;
    [self.mPageView scrollRectToVisible:CGRectMake(xx, 0, self.mPageView.frame.size.width, self.mPageView.frame.size.height) animated:YES];
    [self.gHomePresenter.gPagePresenter updatePageView:index];
}

- (void)scrollViewDidEndDecelerating:(NSUInteger)index
{
    [self.mTopTabBar updateSegmentSelectIndex:index];
}

#pragma mark - WVRFindNavBarView block

- (void)searchButtonClicked
{
    [WVRTrackEventMapping curEvent:@"home" flag:@"research"];
    
    WVRSearchViewController *searchVC = [[WVRSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)cacheButtonClicked {
    
    UIViewController *localVC = [[WVRMediator sharedInstance] WVRMediator_LocalViewController:NO];
    
    [self.navigationController pushViewController:localVC animated:YES];
}

- (void)historyButtonClicked
{
    WVRHistoryController *historyVC = [[WVRHistoryController alloc] init];
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)reloadData
{
    [self.mPageView reloadData];
}

#pragma mark - WVRTopTabViewProtocol

- (void)updateWithTitles:(NSArray *)titles andItemModels:(NSArray *)itemModels
{
    [self.mTopTabBar updateWithTitles:titles scrollView:self.mPageView];
    
    [self.gHomePresenter.gPagePresenter setArgs:itemModels];
    [self.gHomePresenter.gPagePresenter fetchData];
}

#pragma mark - WVRTopTabViewDelegate

- (void)didSelectSegmentItem:(NSInteger)index;
{
    float xx = self.mPageView.frame.size.width * index;
    [self.mPageView scrollRectToVisible:CGRectMake(xx, 0, self.mPageView.frame.size.width, self.mPageView.frame.size.height) animated:YES];
    [self.gHomePresenter.gPagePresenter updatePageView:index];
}

- (void)didSelectRightItem;
{
    NSLog(@"select rightItem");
    WVRAllChannelController * vc = [WVRAllChannelController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden {

    return [WVRAppContext sharedInstance].gStatusBarHidden;     // _isLandspace
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
#pragma mark - orientation

- (BOOL)shouldAutorotate {
    
    return self.gShouldAutorotate;//self.hidenStatusBar;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return self.gSupportedInterfaceO;//UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)gShouldAutorotate
{
    return [WVRAppContext sharedInstance].gShouldAutorotate;
}

- (UIInterfaceOrientationMask)gSupportedInterfaceO
{
    return [WVRAppContext sharedInstance].gSupportedInterfaceO;
}

#pragma mark - BI

/// 对应BI埋点的pageId字段
- (NSString *)currentPageId {
    
    return @"homePage";
}

- (NSString *)biPageId {
    
    NSArray<WVRItemModel *> *arr = self.gHomePresenter.gPagePresenter.args;
    NSInteger index = [self.mTopTabBar getSelectIndex];
    
    if (index >= arr.count) {
        return nil;
    }
    
    WVRItemModel *item = [arr objectAtIndex:index];
    
    return item.linkArrangeValue;
}

- (NSString *)biPageName {
    
    NSInteger index = [self.mTopTabBar getSelectIndex];
    
    return [self.gHomePresenter.gPagePresenter getRealNameForIndex:index];
}

@end

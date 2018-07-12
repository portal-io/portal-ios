//
//  WVRRecommendPageController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRecommendPageTitleController.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRAutoArrangeView.h"
#import "WVRRecommendPageMIXView.h"

#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"
#import "WVRSQFindUIStyleHeader.h"
#import "SQCollectionView.h"
#import "SQSegmentView.h"
#import "SQPageView.h"

#import "WVRTitleRecommendPageViewModel.h"

#import "WVRRecommendPageModel.h"

#define HEIGHT_TITLE (fitToWidth(40.f))
#define HEIGHT_SEGMENT (fitToWidth(35.f))
#define HEIGHT_PAGEVIEW (self.view.frame.size.height-HEIGHT_TITLE-kNavBarHeight)
#define FRAME_SUB_PAGEVIEW (CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PAGEVIEW))


@interface WVRRecommendPageTitleController ()<UIScrollViewDelegate>
@property (nonatomic) NSMutableDictionary * sitesDic;
@property (nonatomic)  SQSegmentView *mSegmentV;
@property (nonatomic)  SQPageView *mPageView;
@property (nonatomic) NSMutableArray * subPageViews;
@property (nonatomic) NSMutableArray * subPageViewDelegates;
@property (nonatomic) NSDictionary * mModelDic;
@property (nonatomic) NSMutableArray * subPageErrorViews;

@property (nonatomic) WVRTitleRecommendPageViewModel * gTitleRecommendPageViewModel;

@property BOOL isTest;

@property (nonatomic) WVRSectionModel * sectionModel;

@end


@implementation WVRRecommendPageTitleController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sectionModel = self.createArgs;
    [self installRAC];
    [self initData];
    [self requestInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initTitleBar {
    [super initTitleBar];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    if (!self.sitesDic) {
        self.sitesDic = [NSMutableDictionary dictionary];
    }
    if (!self.subPageViews) {
        self.subPageViews = [NSMutableArray array];
        self.subPageViewDelegates = [NSMutableArray array];
    }
    if (!self.subPageErrorViews) {
        self.subPageErrorViews = [NSMutableArray array];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mSegmentV setNeedsLayout];//ios 10 viewDidAppear 必调用此方法，scrollwview 的contentSzie才正常
    [self.mPageView setNeedsLayout];
}

- (WVRTitleRecommendPageViewModel *)gTitleRecommendPageViewModel
{
    if (!_gTitleRecommendPageViewModel) {
        _gTitleRecommendPageViewModel = [[WVRTitleRecommendPageViewModel alloc] init];
    }
    return _gTitleRecommendPageViewModel;
}

- (void)installRAC
{
    @weakify(self);
    [[self.gTitleRecommendPageViewModel mCompleteSignal] subscribeNext:^(WVRRecommendPageModel*  _Nullable x) {
        @strongify(self);
        [self siteHttpSuccessBlock:x.sectionModels name:x.firstSectionModelName];
    }];
    [[self.gTitleRecommendPageViewModel mFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self siteHttpFailBlock:x];
    }];
}

- (void)initSegmentV:(NSDictionary*)sectionModelDic
{
    kWeakSelf(self)
    NSArray * titles = [self segmentVTitles:sectionModelDic];
    if (titles.count == 0) {
        return;
    }
    [self.mSegmentV setItemTitles:titles andScrollView:self.mPageView selectedBlock:^(NSInteger index, NSInteger isRepeat) {
          [weakself pageViewScrollToPageIndex:index];
    }];
//    self.mSegmentV.sectionTitles = titles;
//    self.mSegmentV.selectedSegmentIndex = 0;
//    self.mSegmentV.indexChangeBlock = ^(NSInteger index){
//        [weakself pageViewScrollToPageIndex:index];
//    };
//    self.mSegmentV.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
}

- (void)initPageView:(NSInteger)pageCount
{
    for (int i = 0; i < pageCount; i++) {
        WVRSectionModel * sectionModel = self.mModelDic[@(i)];
        if ([sectionModel.linkArrangeType isEqualToString:LINKARRANGETYPE_RECOMMENDPAGE]) {
            [self loadRecommemdPageView:sectionModel];
        }else{
            [self loadNodePageView:sectionModel];
        }
    }
//    self.mPageView.delegate = self;
    [self.mPageView addSubPageViews:self.subPageViews y:0];
}

- (void)loadRecommemdPageView:(WVRSectionModel*)sectionModel
{
    WVRRecommendPageMIXViewInfo * vInfo = [WVRRecommendPageMIXViewInfo new];
    vInfo.viewController = self;
    vInfo.frame = self.view.bounds;
    vInfo.sectionModel = sectionModel;
    vInfo.sectionModel.type = self.sectionModel.type;
    
    WVRRecommendPageMIXView* subPageV = [WVRRecommendPageMIXView createWithInfo:vInfo];
    subPageV.backgroundColor = UIColorFromRGB(0xebeff2);
    [self.subPageViews addObject:subPageV];
}

- (void)loadNodePageView:(WVRSectionModel*)sectionModel
{
    WVRAutoArrangeViewInfo * vInfo = [WVRAutoArrangeViewInfo new];
    vInfo.viewController = self;
    vInfo.frame = self.view.bounds;
    vInfo.sectionModel = sectionModel;
    vInfo.sectionModel.type = self.sectionModel.type;
    
    WVRAutoArrangeView * subPageV = [WVRAutoArrangeView createWithInfo:vInfo];
    subPageV.backgroundColor = UIColorFromRGB(0xebeff2);
    [self.subPageViews addObject:subPageV];
}

- (SQSegmentView *)mSegmentV
{
    if (!_mSegmentV) {
        _mSegmentV = [[SQSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_SEGMENT)];
        UIView * sgVbg = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, HEIGHT_TITLE)];
        sgVbg.backgroundColor = [UIColor whiteColor];
        [sgVbg addSubview:_mSegmentV];
        [self.view addSubview:sgVbg];
        _mSegmentV.backgroundColor = [UIColor whiteColor];
    }
    return _mSegmentV;
}

- (SQPageView *)mPageView
{
    if (!_mPageView) {
        _mPageView = [[SQPageView alloc] initWithFrame:CGRectMake(0, self.mSegmentV.y+kNavBarHeight+HEIGHT_TITLE, SCREEN_WIDTH, HEIGHT_PAGEVIEW)];
        _mPageView.backgroundColor = [UIColor whiteColor];
        _mPageView.pagingEnabled = YES;
        [self.view addSubview:_mPageView];
    }
    return _mPageView;
}

- (NSArray *)segmentVTitles:(NSDictionary*)sectionModelDic
{
    NSMutableArray * titles = [NSMutableArray array];
    for (NSInteger i=0 ; i < sectionModelDic.count; i++) {
        WVRSectionModel* sectionModel = sectionModelDic[@(i)];
        if (sectionModel.name) {
            [titles addObject:sectionModel.name];
        }
    }
    return titles;
}

- (void)requestInfo
{
    [super requestInfo];
    SQShowProgress;
    self.gTitleRecommendPageViewModel.code = self.sectionModel.linkArrangeValue;
    [[self.gTitleRecommendPageViewModel getTitleRecommendPageCmd] execute:nil];
}

- (void)siteHttpSuccessBlock:(NSDictionary*)args name:(NSString* )name
{
    SQHideProgress;
    self.title = name;
    if (args.count==0) {
        return ;
    }
    self.mModelDic = args;
    [self initSegmentV:args];
    [self initPageView:args.count];
    [self updatePageView:0];
}

- (void)siteHttpFailBlock:(NSString*)args
{
    SQHideProgress;

    [self detailLoadFail:nil];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    float xx = scrollView.contentOffset.x ;
//    NSInteger index = xx/self.mPageView.frame.size.width;
//    self.mSegmentV.selectedSegmentIndex = index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xx = scrollView.contentOffset.x ;
    NSInteger index = xx/self.mPageView.frame.size.width;
//    self.mSegmentV.selectedSegmentIndex = index;
    NSLog(@"index: %d", (int)index);
    [self updatePageView:index];
}

- (void)pageViewScrollToPageIndex:(NSInteger)index
{
    NSLog(@"index: %d", (int)index);
    [self updatePageView:index];
    float xx = self.mPageView.frame.size.width * index;
    [self.mPageView scrollRectToVisible:CGRectMake(xx, 0, self.mPageView.frame.size.width, self.mPageView.frame.size.height) animated:YES];
}

- (void)updatePageView:(NSInteger)index
{
    if (index<self.subPageViews.count) {
        WVRAutoArrangeView* subPageView = self.subPageViews[index];
        [subPageView requestInfo];
    }
}

- (void)dealloc
{
    DDLogInfo(@"");
}

@end

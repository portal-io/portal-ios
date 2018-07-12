//
//  WVRPublisherListVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 发布者列表

#import "WVRPublisherListVC.h"
#import "WVRNavigationBar.h"
#import "WVRGotoNextTool.h"

#import "WVRPublisherListCell.h"
#import "WVRPublisherListHeader.h"
#import "WVRPublisherListModel.h"
#import "WVRPublisherDetailModel.h"
#import "WVRAttentionModel.h"

#import "WVRPublisherListView.h"
#import "WVRHorizontalScrollView.h"

#import "WVRRecommendStyleHeader.h"

#import "WVRMediator+AccountActions.h"

@interface WVRPublisherListVC ()<UIScrollViewDelegate, WVRPublisherListViewDelegate, WVRPublisherListHeaderDelegate> {
    
    float _listViewHeight;
    float _lazyHeaderHeight;
    float _tmpResposeHeight;
    
    float _mainViewOffSet;
}

@property (nonatomic, copy) NSString *cpCode;

@property (nonatomic, strong) WVRNavigationBar *bar;
@property (nonatomic) UIBarButtonItem *mBackItem;

@property (nonatomic, strong) WVRPublisherDetailModel *detailModel;
@property (nonatomic, strong) WVRPublisherListModel   *countSortModel;
@property (nonatomic, strong) WVRPublisherListModel   *timeSortModel;
@property (nonatomic, strong) NSMutableArray          *countSortArray;
@property (nonatomic, strong) NSMutableArray          *timeSortArray;

@property (nonatomic, weak) UIScrollView        *scrollView;
@property (nonatomic, weak) WVRHorizontalScrollView *horizontalView;
@property (nonatomic, weak) UIButton            *followBtn;
@property (nonatomic, weak) WVRPublisherListHeader *headerView;

@property (atomic, assign) BOOL isRequesting;
@property (atomic, assign) BOOL requestFailed;
@property (atomic, assign) int  requestCount;

@property (atomic, assign) int countSortPage;
@property (atomic, assign) int timeSortPage;

@property (nonatomic, assign) BOOL isFollow;

@property (atomic, assign) BOOL needRefreshFollowStatus;

@end


@implementation WVRPublisherListVC
@synthesize bar;
@synthesize requestCount = _requestCount;

static NSString *const publisherListCellId   = @"publisherListCellId";
static NSString *const publisherListHeaderId = @"publisherListHeaderId";

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // 本页面默认不会出现在tab中，所以这个属性默认置为YES
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithCpCode:(NSString *)cpCode {
    
    self = [super init];
    if (self) {
        // 本页面默认不会出现在tab中，所以这个属性默认置为YES
        self.hidesBottomBarWhenPushed = YES;
        [self setCpCode:cpCode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSelf];
    [self buildData];
    
    [self createNavBar];
    [self drawUI];
    
    [self requestData];
    
    [self registNoti];
}

- (void)configSelf {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (bar) {
        
        [self.view bringSubviewToFront:bar];
    }
    
    if (_needRefreshFollowStatus) {
        _needRefreshFollowStatus = NO;
        
        [self requestForAttentionStatus];
    }
}

#pragma mark - build data

- (void)buildData {
    
    _timeSortPage = 0;
    _countSortPage = 0;
    _mainViewOffSet = adaptToWidth(125);
    _listViewHeight = self.view.height - kNavBarHeight - adaptToWidth(44);
}

- (void)registNoti {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionStatusChanged:) name:kAttentionStatusNoti object:nil];
}

#pragma mark - Notification

- (void)loginStatusChanged:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    int status = [dict[@"status"] intValue];
    
    if (status == 0) {
        [self updateFollowBtn:NO];
    }
    
    self.needRefreshFollowStatus = (status == 1);
}

- (void)attentionStatusChanged:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSString *code = dict[@"cpCode"];
    if ([code isEqualToString:self.cpCode]) {
        
        int status = [dict[@"status"] intValue];
        [self updateFollowBtn:(status == 1)];
    }
}

#pragma mark - UI

- (void)createNavBar {
    
    bar = [[WVRNavigationBar alloc] init];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    self.mBackItem = item.leftBarButtonItem;
    [bar pushNavigationItem:item animated:NO];
    [self.view addSubview:bar];
}

- (void)navSetting {
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    
    UIButton *followBtn = [self createFollowBtn];
    
    UIBarButtonItem *followItem = [[UIBarButtonItem alloc] initWithCustomView:followBtn];
    _followBtn = followBtn;
    [self updateFollowBtn:self.isFollow];
    
    item.rightBarButtonItems = @[ followItem ];
    
    item.title = _detailModel.cp.name;
    
    [self.bar pushNavigationItem:item animated:NO];
}

- (UIButton *)createFollowBtn {
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(0, 0, 65, 30);
    followBtn.backgroundColor = k_Color1;
    followBtn.tintColor = [UIColor whiteColor];
    [followBtn setTintColor:[UIColor whiteColor]];
    followBtn.layer.cornerRadius = followBtn.height / 2.f;
    followBtn.layer.borderColor = followBtn.backgroundColor.CGColor;
    followBtn.layer.borderWidth = 1;
    followBtn.layer.masksToBounds = YES;
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [followBtn setImage:[[UIImage imageNamed:@"attention_btn_follow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    followBtn.titleLabel.font = FONT(13.5);
    [followBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return followBtn;
}

- (void)drawUI {
    
    if (nil == self.countSortModel || nil == self.detailModel) { return; }
    
    if (nil != _scrollView) { return; }
    
    [self navSetting];
    
    [self createScrollView];
    [self createHeader];
    [self createHorizontalView];
    
    [self.view bringSubviewToFront:bar];
}

- (void)createScrollView {
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    float height = _listViewHeight + [self headerHeight];
    sv.contentSize = CGSizeMake(sv.width, height);
    sv.bounces = NO;
    sv.delegate = self;
    sv.backgroundColor = k_Color10;
    sv.showsVerticalScrollIndicator = NO;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
    if (@available(iOS 11.0, *)) {
        
        sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
    
    [self.view addSubview:sv];
    _scrollView = sv;
}

- (void)createHeader {
    
    WVRPublisherListHeader *header = [[WVRPublisherListHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [self headerHeight])];
    
    header.realDelegate = self;
    header.dataModel = _detailModel;
    
    [_scrollView addSubview:header];
    _headerView = header;
}

- (void)createHorizontalView {
    
    float y = [self headerHeight];
    WVRHorizontalScrollView *sv = [[WVRHorizontalScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.width, _listViewHeight)];
    if (@available(iOS 11.0, *)) {
        sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    sv.contentSize = CGSizeMake(sv.width * 2, sv.height);
    sv.backgroundColor = [UIColor whiteColor];
    sv.pagingEnabled = YES;
    sv.bounces = NO;
    sv.delegate = self;
    
    [_scrollView addSubview:sv];
    _horizontalView = sv;
    
    for (int i = 0; i < 2; i ++) {
        WVRPublisherListView *listView = [[WVRPublisherListView alloc] initWithFrame:CGRectMake(_horizontalView.width * i, 0, _horizontalView.width, _horizontalView.height)];
        listView.viewType = i;
        listView.realDelegate = self;
        
        [_horizontalView addSubview:listView];
        listView.dataArray = (i == 0 ? _timeSortArray : _countSortArray);
    }
}

#pragma mark - setter

- (void)setTimeSortModel:(WVRPublisherListModel *)timeSortModel {
    
    if (_timeSortModel != timeSortModel) {
        _timeSortModel = timeSortModel;
        
        if (_timeSortPage == 0) {
            _timeSortArray = [NSMutableArray array];
        }
        
        for (WVRPublisherListItemModel *itemModel in timeSortModel.programs) {
            
            [_timeSortArray addObject:itemModel];
        }
        
        WVRPublisherListView *listView = [self listViewForType:PublisherSortTypePublishTime];
        [listView endRefreshing:(timeSortModel.pageNumber >= timeSortModel.totalPages)];
        listView.dataArray = _timeSortArray;
    }
}

- (void)setCountSortModel:(WVRPublisherListModel *)countSortModel {
    
    if (_countSortModel != countSortModel) {
        _countSortModel = countSortModel;
        
        if (_countSortPage == 0) {
            _countSortArray = [NSMutableArray array];
        }
        
        for (WVRPublisherListItemModel *itemModel in countSortModel.programs) {
            
            [_countSortArray addObject:itemModel];
        }
        
        WVRPublisherListView *listView = [self listViewForType:PublisherSortTypePlayCount];
        [listView endRefreshing:(countSortModel.pageNumber >= countSortModel.totalPages)];
        listView.dataArray = _countSortArray;
    }
}

- (void)setRequestCount:(int)requestCount {
    if (_requestCount != requestCount) {
        _requestCount = requestCount;
        
        if (_requestCount >= 3) {
            // 刷新或创建UI
            if (_requestFailed) {
                [self networkFaild];
            } else {
                self.mBackItem.tintColor = [UIColor colorWithWhite:1 alpha:1];
                [self hideProgress];
                
                [self drawUI];
            }
            self.isRequesting = NO;
        }
    }
}

- (int)requestCount {
    
    return _requestCount;
}

- (void)setIsFollow:(BOOL)isFollow {
    
    _detailModel.follow = isFollow ? 1 : 0;
}

- (BOOL)isFollow {
    
    return _detailModel.follow == 1;
}

#pragma mark - getter

- (WVRPublisherListView *)listViewForType:(PublisherSortType)type {
    
    for (WVRPublisherListView *listView in _horizontalView.subviews) {
        
        if (![listView isKindOfClass:[WVRPublisherListView class]]) { continue; }
        
        if (listView.viewType == type) {
            return listView;
        }
    }
    return nil;
}

#pragma mark - lazy Var

// 数据请求完毕之后才调动，否则会出错
- (float)headerHeight {
    
    if (0 == _lazyHeaderHeight) {
        
        NSAttributedString *attributedString = [WVRUIEngine attributedStringWithString:_detailModel.cp.info font:kFontFitForSize(12) color:k_Color6];
        
        CGSize size = [WVRComputeTool sizeOfString:attributedString Size:CGSizeMake(SCREEN_WIDTH - adaptToWidth(20), MAXFLOAT)];
        
        _lazyHeaderHeight = adaptToWidth(180) + HEIGHT_SPLITE_LINE + ceilf(size.height) + _mainViewOffSet;
    }
    return _lazyHeaderHeight;
}

- (float)responsePanGestureHeight {
    
    if (0 == _tmpResposeHeight) {
        _tmpResposeHeight = _scrollView.contentSize.height - _scrollView.height;
    }
    
    return _tmpResposeHeight;
}

#pragma mark - WVRPublisherListHeaderDelegate

- (void)sortBottonClickWithType:(PublisherSortType)type {
    
    float x = self.horizontalView.width * type;
    [self.horizontalView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        
        float offsetY = scrollView.contentOffset.y;
        [self mainScrollViewOffsetChange:offsetY];
        
    } else if (scrollView == _horizontalView) {
        
        float offsetX = scrollView.contentOffset.x;
        [self horizontalViewOffsetChange:offsetX];
    }
}

- (void)mainScrollViewOffsetChange:(float)offsetY {
    
    float alpha = 0;
    
    if (offsetY <= _mainViewOffSet) {
        
        [self.bar setOverlayDiaphaneity:alpha];
        
    } else {
        float resHeight = [self responsePanGestureHeight];
        if (offsetY > resHeight) {
//                float y = offsetY - resHeight;
            // 此处把事件传递下去
            
            [_scrollView setContentOffset:CGPointMake(0, resHeight)];
        } else {
            
            alpha = (offsetY - _mainViewOffSet) / 100;
            
            [self.bar setOverlayDiaphaneity:alpha];
        }
    }
}

- (void)horizontalViewOffsetChange:(float)offsetX {
    
    float scale = offsetX / _horizontalView.width;
    
    if (scale == 0) {
        [self.headerView listViewDidChangeToType:0];
    } else if (scale == 1) {
        [self.headerView listViewDidChangeToType:1];
    }
}

#pragma mark - WVRPublisherListViewDelegate

- (void)listViewDidSelectItemAtIndex:(NSInteger)index itemModel:(WVRPublisherListItemModel *)model {
    
    WVRBaseModel *jumpModel = [[WVRBaseModel alloc] init];
    jumpModel.linkArrangeValue = model.code;
    jumpModel.linkArrangeType = nil;
    jumpModel.programType = model.programType;
    jumpModel.videoType = model.videoType;
    
    [WVRGotoNextTool gotoNextVC:jumpModel nav:self.navigationController];
}

- (void)listViewPullUpLoadMore:(WVRPublisherListView *)listView {
    
    kWeakSelf(self);
    int page = 0;
    if (listView.viewType == PublisherSortTypePublishTime) {
        page = ++ _timeSortPage;
    } else {
        page = ++ _countSortPage;
    }
    
    [WVRPublisherListModel requestForPublisherListForCp:self.cpCode sortType:PublisherSortTypePublishTime atPage:page block:^(WVRPublisherListModel * model, NSError *error) {
        
        if (model) {
            if (listView.viewType == PublisherSortTypePublishTime) {
                weakself.timeSortModel = model;
            } else {
                weakself.countSortModel = model;
            }
        } else {
            [listView endRefreshing:NO];
            SQToastInKeyWindow(@"网络错误，请稍后重试");
        }
    }];
}

- (BOOL)mainScrollViewResponsePanGestrue {
    
    float y = self.scrollView.contentOffset.y;
    
    return (y < [self responsePanGestureHeight]);
}

#pragma mark - Action

// 返回
- (void)leftBarButtonClick {
    
    [WVRTrackEventMapping trackEvent:@"subject" flag:@"back"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 关注
- (void)rightBarButtonClick {
    
    if ([[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:nil]) {
        [self followAction];
    }
}

- (void)followAction {
    
    kWeakSelf(self);
    
    int status = self.isFollow ? 0 : 1;
    
    [WVRAttentionModel requestForFollow:self.cpCode status:status block:^(id responseObj, NSError *error) {
        NSString *msg = nil;
        if (responseObj) {
            BOOL isFollow = (status == 1);
            [weakself updateFollowBtn:isFollow];
            int count = isFollow ? 1 : -1;
            weakself.detailModel.follow = status;
            weakself.detailModel.cp.fansCount = weakself.detailModel.cp.fansCount + count;
            [weakself.headerView updateFansCount:weakself.detailModel.cp.fansCount];
            msg = (status == 1) ? kToastAttentionSuccess : kToastCancelAttentionSuccess;
        } else {
            msg = (status == 1) ? kToastAttentionFail : kToastCancelAttentionFail;
        }
        SQToastInKeyWindow(msg);
    }];
}

- (void)updateFollowBtn:(BOOL)isFollow {
    
    self.isFollow = isFollow;
    UIColor *color = isFollow ? k_Color8 : k_Color12;
    NSString *title = isFollow ? @"已关注" : @"关注";
    NSString *image = isFollow ? @"attention_btn_followed" : @"attention_btn_follow";
    UIColor *bgColor = isFollow ? k_Color12 : k_Color1;     // [UIColor clearColor]
    UIColor *borderColor = isFollow ? k_Color8 : k_Color1;
    
    [_followBtn setTitle:title forState:UIControlStateNormal];
    if (isFollow) {
        [_followBtn setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [_followBtn setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    _followBtn.layer.borderColor = borderColor.CGColor;
    [_followBtn setTitleColor:color forState:UIControlStateNormal];
    [_followBtn setBackgroundColor:bgColor];
}


#pragma mark - request

- (void)requestData {
    self.mBackItem.tintColor = [UIColor colorWithWhite:0 alpha:1];
    if (_isRequesting) { return; }
    
    self.isRequesting = YES;
    self.requestCount = 0;
    self.requestFailed = NO;
    
    _countSortPage = 0;
    _timeSortPage = 0;
    
    if (!_scrollView) { [self showProgress]; }
    
    __weak typeof(self) weakSelf = self;
    
    [WVRPublisherListModel requestForPublisherListForCp:self.cpCode sortType:PublisherSortTypePlayCount atPage:_countSortPage block:^(WVRPublisherListModel * model, NSError *error) {
        
        if (model) {
            weakSelf.countSortModel = model;
        } else {
            weakSelf.requestFailed = YES;
        }
        
        weakSelf.requestCount += 1;
    }];
    
    [WVRPublisherListModel requestForPublisherListForCp:self.cpCode sortType:PublisherSortTypePublishTime atPage:_timeSortPage block:^(WVRPublisherListModel * model, NSError *error) {
        
        if (model) {
            weakSelf.timeSortModel = model;
        } else {
            weakSelf.requestFailed = YES;
        }
        
        weakSelf.requestCount += 1;
    }];
    
    [WVRPublisherDetailModel requestForPublisherDetailWithCode:self.cpCode block:^(WVRPublisherDetailModel * model, NSError *error) {
        
        if (model) {
            weakSelf.detailModel = model;
        } else {
            weakSelf.requestFailed = YES;
        }
        
        weakSelf.requestCount += 1;
    }];
}

- (void)requestForAttentionStatus {
    
    kWeakSelf(self);
    [WVRPublisherDetailModel requestForPublisherDetailWithCode:self.cpCode block:^(WVRPublisherDetailModel * model, NSError *error) {
        
        if (model) {
            [weakself updateFollowBtn:(model.follow == 1)];
        }
    }];
}

#pragma mark - Request Error

// 重新请求数据
- (void)re_requestData {
    
    [self requestData];
}

- (void)networkFaild {
    
    [self hideProgress];
    
    if (_scrollView) {      // 已有界面
        
        [self showMessage:kNoNetAlert];
        
    } else {                    // 未有界面
        [self detailLoadFail:nil];
        self.mBackItem.tintColor = [UIColor colorWithWhite:0 alpha:1];
        [self.view bringSubviewToFront:self.bar];
    }
}

-(void)requestInfo{
    [self re_requestData];
}

#pragma mark - orientation

- (BOOL)shouldAutorotate {
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end

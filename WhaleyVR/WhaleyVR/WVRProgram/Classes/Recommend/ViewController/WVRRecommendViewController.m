//
//  WVRRecommendVC.m
//  WhaleyVR
//
//  Created by Snailvr on 16/8/31.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 我的关注

#import "WVRRecommendViewController.h"

#import "SQRefreshHeader.h"

#import "WVRGotoNextTool.h"
#import "WVRRecommendFollowVC.h"

#import "WVRNoneFollowView.h"
#import "WVRFollowUnLoginView.h"

#import "WVRMyFollowCell.h"
#import "WVRMyFollowFirstHeader.h"
#import "WVRMyFollowReuseHeader.h"
#import "WVRMyFollowReuseFooter.h"
#import "WVRPublisherListVC.h"

#import "WVRRecommendStyleHeader.h"
#import "WVRSpring2018Manager.h"

@interface WVRRecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WVRMyFollowReuseFooterDelegate, WVRMyFollowFirstHeaderDelegate, WVRMyFollowReuseHeaderDelegate> {
    
    float _firstHeaderHeight;        // first section header height
    float _sectionHeaderHeight;
    float _sectionFooterHeight;
    float _cellHeight;
}

@property (nonatomic, weak) UIView *notLoginView;
@property (nonatomic, weak) UIView *noneView;
@property (nonatomic, weak) UICollectionView *mainView;

@property (atomic, assign) BOOL needRefresh;
@property (atomic, assign) BOOL isRequesting;
@property (atomic, assign) BOOL isEnd;

@property (nonatomic, strong) WVRAttentionModel *dataModel;
@property (nonatomic, strong) NSMutableArray<NSArray<WVRAttentionLatestUpdated *> *> *dataArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *countArray;   // count For every section
@property (nonatomic, assign) int currentPage;


@end


@implementation WVRRecommendViewController

static NSString *kMyFollowCellId = @"kMyFollowCellId";
static NSString *kMyFollowFirstHeaderId = @"kMyFollowFirstHeaderId";
static NSString *kMyFollowReuseHeaderId = @"kMyFollowReuseHeaderId";
static NSString *kMyFollowReuseFooterId = @"kMyFollowReuseFooterId";
static NSString *kMyFollowNoneFooterId  = @"kMyFollowNoneFooterId";

int kFollowItemCount = 2;
int kFollowSectionMaxCount = 20;

#pragma mark - ViewControllerLifeCiycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.tabBarItem.badgeValue = @"99+";
    [self viewSettings];
    
    [self buildData];
    
    [self registNoti];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (_needRefresh) {
        _needRefresh = NO;
        
        [self refreshUI];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [WVRSpring2018Manager addHomePageEntryForSpring2018];
}

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
        DDLogInfo(@"%@", exception.reason);
    }
}

#pragma mark - UI

- (void)refreshUI {
    
    // 重绘UI
    if ([WVRUserModel sharedInstance].isLogined) {
        _currentPage = 0;
        [self setDisplayView:self.mainView];
        [self requestDataForPage:_currentPage];
    } else {
        [self setDisplayView:self.notLoginView];
        [self notLoginView];
    }
}

- (void)viewSettings {
    
    [self createLeftButton];
    self.navigationItem.title = @"我的关注";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 推荐关注button
- (void)createLeftButton {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 37/2, 37/2);
    [leftButton setImage:[UIImage imageNamed:@"navbar_recommendAttention"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navbar_recommendAttention_pressed"] forState:UIControlStateHighlighted];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

// 推荐关注button点击事件
- (void)leftButtonClicked {
    
    WVRRecommendFollowVC *recommenFollowVC = [[WVRRecommendFollowVC alloc] init];
    recommenFollowVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommenFollowVC animated:YES];
}

- (void)createMainView {
    
    if (_mainView) {
        [self setDisplayView:_mainView];
        [_mainView reloadData];
        
        return;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.width, self.view.height - kNavBarHeight - kTabBarHeight) collectionViewLayout:layout];
    mainView.backgroundColor = [UIColor whiteColor];
    
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = k_Color10;
    
    mainView.mj_header = [SQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    
    [mainView registerClass:[WVRMyFollowCell class] forCellWithReuseIdentifier:kMyFollowCellId];
    [mainView registerClass:[WVRMyFollowFirstHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyFollowFirstHeaderId];
    [mainView registerClass:[WVRMyFollowReuseHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyFollowReuseHeaderId];
    [mainView registerClass:[WVRMyFollowReuseFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMyFollowReuseFooterId];
    [mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMyFollowNoneFooterId];
    
    if (@available(iOS 11.0, *)) {
        mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _mainView = mainView;
    [self setDisplayView:mainView];
    
    _mainView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpLoadMore)];
}

#pragma mark - setter

- (void)setDataModel:(WVRAttentionModel *)dataModel {
    
    if (_dataModel != dataModel) {
        _dataModel = dataModel;
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        WVRAttentionLatestUpdated *tmpUP = nil;
        if (_currentPage > 0) {
            // 拼接
//            tmpArray = (NSMutableArray *)[_dataArray lastObject];
//            tmpUP = [[_dataArray lastObject] lastObject];
            
        } else {
            // 新建
            _dataArray = [NSMutableArray array];
            
            _countArray = [NSMutableArray array];
            [_countArray addObject:@0];
        }
        
        for (WVRAttentionLatestUpdated *up in dataModel.latestUpdated) {
            
            if ((tmpUP == nil || [tmpUP.cpCode isEqualToString:up.cpCode]) && tmpArray.count < kFollowSectionMaxCount) {
                [tmpArray addObject:up];
            } else {
                if (tmpArray.count > 0) {
                    [_dataArray addObject:tmpArray];
                }
                tmpArray = [NSMutableArray array];
                [tmpArray addObject:up];
            }
            tmpUP = up;
        }
        
        // 上面逻辑中最后一个array是没有加入到dataArray的
        if (tmpArray.count > 0) {
            [_dataArray addObject:tmpArray];
        }
        
        long idx = 0;
        long curCount = _countArray.count - 1;
        for (NSArray *array in _dataArray) {
            
            idx += 1;
            if (idx <= curCount) { continue; }
            
            long count = array.count;
            if (count >= 0) {
                if (count <= kFollowItemCount) {
                    [_countArray addObject:@(count)];
                } else {
                    [_countArray addObject:@(kFollowItemCount)];
                }
            }
        }
    }
}

#pragma mark - getter

- (UIView *)noneView {
    
    if (!_noneView) {
        WVRNoneFollowView *noneV = [[WVRNoneFollowView alloc] init];
        [self.view addSubview:noneV];
        _noneView = noneV;
    }
    
    return _noneView;
}

- (UIView *)notLoginView {
    
    if (!_notLoginView) {
        WVRFollowUnLoginView *notLoginV = [[WVRFollowUnLoginView alloc] init];
        [self.view addSubview:notLoginV];
        _notLoginView = notLoginV;
    }
    return _notLoginView;
}

#pragma mark - build data

// 构建初始化数据, 在创建UI之前
- (void)buildData {
    
    _firstHeaderHeight = adaptToWidth(105);
    _sectionHeaderHeight = adaptToWidth(71)+HEIGHT_SPLITE_LINE;
    _sectionFooterHeight = adaptToWidth(40);
    _cellHeight = adaptToWidth(90);
    
    _currentPage = 0;
    _dataArray = [NSMutableArray array];
    
    if ([WVRUserModel sharedInstance].isLogined) {
        [self requestDataForPage:_currentPage];
    } else {
        [self notLoginView];
    }
}

- (void)registNoti {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionStatusChanged:) name:kAttentionStatusNoti object:nil];
}

#pragma mark - Notification

- (void)loginStatusChanged:(NSNotification *)noti {
    
    self.needRefresh = YES;
}

- (void)attentionStatusChanged:(NSNotification *)noti {
    
    self.needRefresh = YES;
}

#pragma mark - 下拉刷新
// 更新数据
- (void)pulldownRefreshData {
    
    [_noneView removeFromSuperview];

    _currentPage = 0;
    [self requestDataForPage:_currentPage];
    
    NSLog(@"Recommend Page Refresh Data");
}

#pragma mark - 上拉加载更多

- (void)pullUpLoadMore {
    
    if (!_dataArray.count) { return; }
    
    _currentPage += 1;
    [self requestDataForPage:_currentPage];
}

#pragma mark - request

// 传 NO 加载第一页数据
- (void)requestDataForPage:(int)page {
    
    if (_isRequesting) { return; }
    
    _isRequesting = YES;
    
    if (!_mainView) { [self showProgress]; }
    if (page == 0) { [self.mainView.mj_footer resetNoMoreData]; }
    
    __weak typeof(self) weakSelf = self;
    [WVRAttentionModel requestForMyFollowListForPage:page block:^(WVRAttentionModel *model, NSError *error) {
        
        if (model) {
            [weakSelf setDataModel:model];
            
            if (model.cpList.count == 0) {
                [weakSelf setDisplayView:self.noneView];
            } else {
                [weakSelf createMainView];
            }
        } else {
            [weakSelf networkFaild];
        }
        
        [self hideProgress];
        if (page == 0) {
            [weakSelf.mainView.mj_header endRefreshing];
        } else {
            if (model.pageNumber < model.totalPages) {
                [weakSelf.mainView.mj_footer endRefreshing];
            } else {
                [weakSelf.mainView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        weakSelf.isRequesting = NO;
    }];
}


#pragma mark - Request Error

// 重新请求数据
- (void)re_requestData {
    
    [self setDisplayView:nil];
    
    _currentPage = 0;
    [self requestDataForPage:_currentPage];
}

- (void)networkFaild {
    
    if (_mainView.superview != nil && true) {      // 已有界面
        
        [self showToast:kNoNetAlert];
        
    } else {                    // 未有界面
        @weakify(self);
        [self showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self re_requestData];
        }];
    }
}

#pragma mark - private func

- (void)setDisplayView:(UIView *)view {
    
    NSMutableArray *arr = [NSMutableArray array];
    if (_notLoginView) { [arr addObject:_notLoginView]; }
    if (_noneView) { [arr addObject:_noneView]; }
    if (_mainView) { [arr addObject:_mainView]; }
//    if (_netErrorView) { [arr addObject:_netErrorView]; }
    
    for (UIView *tmpView in arr) {
        if (tmpView == view && tmpView != nil) {
            [self.view addSubview:tmpView];
            UIView * springView = [self.view viewWithTag:TAG_SPRINGBTN];
            [self.view bringSubviewToFront:springView];
        } else {
            [tmpView removeFromSuperview];
        }
    }
}

#pragma mark - WVRMyFollowFirstHeaderDelegate

- (void)headerDidSelectItemAtIndex:(NSInteger)index {
    
    WVRAttentionCpList *cp = [self.dataModel.cpList objectAtIndex:index];
    
    WVRPublisherListVC *vc = [[WVRPublisherListVC alloc] initWithCpCode:cp.code];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WVRMyFollowReuseHeaderDelegate

- (void)headerClickAtIndex:(NSInteger)section {
    
    WVRAttentionLatestUpdated *up = [[_dataArray objectAtIndex:section - 1] firstObject];
    
    WVRPublisherListVC *vc = [[WVRPublisherListVC alloc] initWithCpCode:up.cpCode];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WVRMyFollowReuseFooterDelegate

int kFollowMoreCount = 10;        // 每次点击展开更多最多展开的个数

- (void)footerClickAtIndex:(NSInteger)section {
    
    NSNumber *num = [_countArray objectAtIndex:section];
    NSInteger count = [_dataArray objectAtIndex:section - 1].count;
    long longNum = num.longValue;
    
    if (longNum < count) {
        if (longNum + kFollowMoreCount < count) {
            
            num = [NSNumber numberWithLong:(longNum + kFollowMoreCount)];
        } else {
            num = @(count);
        }
    } else {
        num = @(kFollowItemCount);
    }
    [_countArray replaceObjectAtIndex:section withObject:num];
    
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:section];
    [self.mainView reloadSections:set];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectItemAtIndexPath - section: %ld, item: %ld", (long)indexPath.section, (long)indexPath.item);
    
    WVRAttentionLatestUpdated *up = [[_dataArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.item];
    
    WVRBaseModel *jumpModel = [[WVRBaseModel alloc] init];
    jumpModel.linkArrangeValue = up.sid;
    jumpModel.linkArrangeType = nil;
    
    jumpModel.programType = up.programType ?: PROGRAMTYPE_RECORDED;
    jumpModel.videoType = up.videoType;
    
    [WVRGotoNextTool gotoNextVC:jumpModel nav:self.navigationController];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _dataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) { return 0; }
    
//    NSArray *arr = [_dataArray objectAtIndex:section - 1];
    NSNumber *num = [_countArray objectAtIndex:section];
    
    return num.integerValue;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRMyFollowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyFollowCellId forIndexPath:indexPath];
    
    NSArray *arr = [_dataArray objectAtIndex:indexPath.section - 1];
    WVRAttentionLatestUpdated *up = [arr objectAtIndex:indexPath.item];
    
    cell.iconUrl = up.smallPic;
    cell.title = up.displayName;
    cell.count = up.stat.playCount;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            WVRMyFollowFirstHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyFollowFirstHeaderId forIndexPath:indexPath];
            header.realDelegate = self;
            header.dataArray = _dataModel.cpList;
            
            return header;
        } else {
            WVRMyFollowReuseHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyFollowReuseHeaderId forIndexPath:indexPath];
            
            WVRAttentionLatestUpdated *up = [[_dataArray objectAtIndex:indexPath.section - 1] firstObject];
            header.iconUrl = up.headPic;
            header.title = up.name;
            header.time = up.updateTime;
            header.tag = indexPath.section;
            header.realDelegate = self;
            
            return header;
        }
    } else if (kind == UICollectionElementKindSectionFooter) {
        int count = (int)([_dataArray objectAtIndex:indexPath.section - 1].count);
        
        if (count > kFollowItemCount) {
            int curCount = [_countArray objectAtIndex:indexPath.section].intValue;
            
            WVRMyFollowReuseFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMyFollowReuseFooterId forIndexPath:indexPath];
            footer.realDelegate = self;
            footer.tag = indexPath.section;
            footer.type = (curCount < count) ? FollowReuseFooterTypeMore : FollowReuseFooterTypeLess;
            
            return footer;
        } else {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMyFollowNoneFooterId forIndexPath:indexPath];
            return footer;
        }
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH, _cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, _firstHeaderHeight);
    }
    
    return CGSizeMake(SCREEN_WIDTH, _sectionHeaderHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (section == 0) { return CGSizeZero; }
    
    NSArray *arr = [_dataArray objectAtIndex:section - 1];
    
    if (arr.count > kFollowItemCount) {
        return CGSizeMake(SCREEN_WIDTH, _sectionFooterHeight);
    }
    
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

@end

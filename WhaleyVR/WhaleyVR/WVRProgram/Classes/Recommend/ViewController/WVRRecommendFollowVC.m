//
//  WVRMyFollowVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 推荐关注

#import "WVRRecommendFollowVC.h"
#import "SQRefreshHeader.h"
#import "WVRRecommendFollowModel.h"
#import "WVRRecommendFollowCell.h"
#import "WVRPublisherListVC.h"
#import "WVRGotoNextTool.h"

#import "WVRRecommendStyleHeader.h"

@interface WVRRecommendFollowVC ()<UICollectionViewDelegate, UICollectionViewDataSource, WVRRecommendFollowCellDelegate>

@property (nonatomic, weak) UICollectionView *mainView;
@property (atomic, assign) BOOL              isRequesting;

@property (nonatomic, strong) WVRRecommendFollowModel *dataModel;

@property (atomic, strong) NSMutableArray<NSNumber *> *offsetArray;    // 缓存cell中collection的偏移量

@property (atomic, assign) BOOL needRefresh;

@end


@implementation WVRRecommendFollowVC

static NSString *const recommendFollowCellId   = @"recommendFollowCellId";
static NSString *const recommendFollowHeaderId = @"recommendFollowHeaderId";


#pragma mark - ViewControllerLifeCiycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewSettings];
    
    [self buildData];
    
    [self requestData];
    
    [self registNoti];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (_needRefresh) {
        _needRefresh = NO;
        
        [self requestData];
    }
}

#pragma mark - setter

- (void)setDataModel:(WVRRecommendFollowModel *)dataModel {
    
    if (dataModel != _dataModel) {
        _dataModel = dataModel;
        
        _offsetArray = [NSMutableArray array];
        
        // offset数组防止崩溃
        if (self.offsetArray.count < dataModel.listArray.count) {
            long k = dataModel.listArray.count - self.offsetArray.count;
            for (int n = 0; n < k; n ++) {
                [self.offsetArray addObject:@0];
            }
        }
    }
}

#pragma mark - build data

// 构建初始化数据, 在创建UI之前
- (void)buildData {
    
    _offsetArray = [NSMutableArray array];
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

#pragma mark - about UI

- (void)viewSettings {
    
    self.navigationItem.title = @"推荐关注";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createMainView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width, adaptToWidth(150));
    layout.headerReferenceSize = CGSizeMake(self.view.width, adaptToWidth(104));
    layout.minimumLineSpacing = HEIGHT_SPLITE_LINE;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.width, self.view.height - kNavBarHeight) collectionViewLayout:layout];
    
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = k_Color10;
    
    [mainView registerClass:[WVRRecommendFollowCell class] forCellWithReuseIdentifier:recommendFollowCellId];
    [mainView registerClass:[WVRRecommendFollowHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:recommendFollowHeaderId];
    
    mainView.mj_header = [SQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    
    if (@available(iOS 11.0, *)) {
        mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:mainView];
    _mainView = mainView;
}

#pragma mark - 下拉刷新
// 更新数据
- (void)pulldownRefreshData {
    
    [self requestData];
}

#pragma mark - request

// 传 NO 加载第一页数据
- (void)requestData {
    
    if (_isRequesting) { return; }
    
    _isRequesting = YES;
    
    if (!_mainView) { [self showProgress]; }
    
    __weak typeof(self) weakSelf = self;
    [WVRRecommendFollowModel requestForRecommendFollowList:^(WVRRecommendFollowModel *model, NSError *error) {
        
        if (model) {
            weakSelf.dataModel = model;
            
            if (weakSelf.mainView) {
                
                [weakSelf.mainView reloadData];
            } else {
                
                [weakSelf createMainView];
            }
        } else {
            [weakSelf networkFaild];
        }
        
        [weakSelf hideProgress];
        [weakSelf.mainView.mj_header endRefreshing];
        weakSelf.isRequesting = NO;
    }];
}


#pragma mark - Request Error

// 重新请求数据
- (void)re_requestData {
    
    [self requestData];
}

- (void)networkFaild {
    
    if (_mainView.superview != nil && _dataModel != nil) {      // 已有界面
        
        [self showToast:kNoNetAlert];
        
    } else {                    // 未有界面
//        self.mBackItem.tintColor = [UIColor colorWithWhite:0 alpha:1];
//        [self.view bringSubviewToFront:self.bar];
        [self detailLoadFail:nil];
//        [self showNetErrorVWithreloadBlock:^{
//            @strongify(self);
//            [self re_requestData];
//        }];
    }
}

-(void)requestInfo
{
    [self re_requestData];
}

#pragma mark - private func

#pragma mark - WVRRecommendFollowCellDelegate

- (void)itemCellDidSelectAtIndex:(NSInteger)index withDataModel:(WVRRecommendFollowItemModel *)dataModel {
    
    if (index < 0) {
        
        WVRPublisherListVC *vc = [[WVRPublisherListVC alloc] initWithCpCode:dataModel.cpInfo.code];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WVRPublisherListItemModel *item = [dataModel.cpProgramDtos objectAtIndex:index];
        
        WVRBaseModel *jumpModel = [[WVRBaseModel alloc] init];
        jumpModel.linkArrangeValue = item.code;
        jumpModel.linkArrangeType = nil;
        jumpModel.programType = item.programType;
        jumpModel.videoType = item.videoType;
        
        [WVRGotoNextTool gotoNextVC:jumpModel nav:self.navigationController];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRRecommendFollowCell *itemView = (WVRRecommendFollowCell *)cell;
    [(WVRRecommendFollowCell *)cell stopCollectionAnimation];
    
    _offsetArray[indexPath.item] = [[NSNumber alloc] initWithFloat:itemView.offsetX];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataModel.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRRecommendFollowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendFollowCellId forIndexPath:indexPath];
    
    cell.realDelegate = self;
    cell.dataModel = _dataModel.listArray[indexPath.item];
    [cell setOffsetX:[[_offsetArray objectAtIndex:indexPath.item] floatValue]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        WVRRecommendFollowHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:recommendFollowHeaderId forIndexPath:indexPath];
        
        WVRRecommendFollowItemModel *model = _dataModel.headerModel;
        header.picUrl = model.picUrl_;
        
        return header;
    }
    return nil;
}

@end

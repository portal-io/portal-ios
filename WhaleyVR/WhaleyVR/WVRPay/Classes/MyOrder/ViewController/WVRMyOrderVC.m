//
//  WVRMyOrderVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 我的购买（订单）

#import "WVRMyOrderVC.h"
#import "WVRMyOrderCell.h"
#import "WVRMyOrderItemModel.h"

#import "WVRItemModel.h"
#import "SQRefreshHeader.h"

#import "WVRMyOrderViewModel.h"

#import "WVRMediator+ProgramActions.h"

@interface WVRMyOrderVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) WVRMyOrderViewModel * gMyOrderViewModel;

@property (nonatomic, weak) UICollectionView *mainView;
@property (nonatomic, strong) WVRMyOrderListModel *dataModel;

@property (nonatomic, assign) int curPage;

@end


@implementation WVRMyOrderVC

static NSString *const myOrderCellId = @"myOrderCellId";

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的购买";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _curPage = 0;
    [self installRAC];
    [self requestDataWithPage:_curPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (WVRMyOrderViewModel *)gMyOrderViewModel
{
    if(!_gMyOrderViewModel) {
        _gMyOrderViewModel = [[WVRMyOrderViewModel alloc] init];
    }
    return _gMyOrderViewModel;
}

- (void)installRAC {
    
    @weakify(self);
    [[RACObserve(self.gMyOrderViewModel, gResponseModel) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self setDataModel:x];
    }];
    [[RACObserve(self.gMyOrderViewModel, gErrorViewModel) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self networkFaild];
    }];
}

#pragma mark - UI

- (void)drawUI {
    
    [self hideProgress];
    
    if (_dataModel.content.count > 0) {
        
        [self createMainView];
    } else {
        [self createNullView];
    }
}

- (void)createMainView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width, adaptToWidth(91));
    
    layout.sectionInset = UIEdgeInsetsMake(adaptToWidth(10), 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.width, self.view.height - kNavBarHeight) collectionViewLayout:layout];
    
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor clearColor];
    mainView.showsHorizontalScrollIndicator = NO;
    
    [mainView registerClass:[WVRMyOrderCell class] forCellWithReuseIdentifier:myOrderCellId];
    
    mainView.mj_header = [SQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    
    if (self.dataModel.content.count >= kHTTPPageSize) {
        mainView.mj_footer = [SQRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupLoadMoreData)];
    }
    if (@available(iOS 11.0, *)) {
        mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:mainView];
    _mainView = mainView;
}

- (void)createNullView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_loading_fail"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds= YES;
    imageView.centerX = self.view.width / 2.0;
    imageView.centerY = self.view.height / 2.f - adaptToWidth(30);
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottomY + adaptToWidth(20), self.view.width, adaptToWidth(25))];
    label.text = @"没有已购买的视频";
    label.font = kFontFitForSize(15.5);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = k_Color5;
    [self.view addSubview:label];
}

#pragma mark - setter

/// 列表数据拼接处理
- (void)setDataModel:(WVRMyOrderListModel *)dataModel {
    
    if (dataModel.number == 0) {
        
        _dataModel = dataModel;
    } else {
        NSMutableArray *list = [_dataModel.content mutableCopy];
        
        for (WVRMyOrderItemModel *model in dataModel.content) {
            
            [list addObject:model];
        }
        dataModel.content = list;
        _dataModel = dataModel;
    }
    
    [self refreshUI];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRMyOrderItemModel *itemModel = [_dataModel.content objectAtIndex:indexPath.item];
    
    if (itemModel.merchandiseStatus == MerchandiseStatusOffline) {
        switch ([itemModel purchaseType]) {
            case PurchaseProgramTypeCollection:
                SQToastInKeyWindow(@"该合集版权已经到期");
                break;
            case PurchaseProgramTypeVR:
            case PurchaseProgramTypeLive:
                SQToastInKeyWindow(@"该视频版权已经到期");
                break;
            default:
                break;
        }
        
        return;
    }
    
    if (itemModel.purchaseType == PurchaseProgramTypeCollection && itemModel.merchandiseContentCount == 0) {
        SQToastInKeyWindow(@"请耐心等待直播回顾上线");
        return;
    }
    
    WVRItemModel *jumpModel = [[WVRItemModel alloc] init];
    jumpModel.name = itemModel.merchandiseName;
    switch ([itemModel purchaseType]) {
        case PurchaseProgramTypeVR: {
            
            jumpModel.linkArrangeType = LINKARRANGETYPE_PROGRAM;
            jumpModel.linkArrangeValue = itemModel.merchandiseCode;
            jumpModel.videoType = VIDEO_TYPE_VR;
        }
            break;
        case PurchaseProgramTypeLive: {
            
            jumpModel.linkArrangeType = LINKARRANGETYPE_LIVE;
            jumpModel.linkArrangeValue = itemModel.merchandiseCode;
            
            if (itemModel.liveStatus == WVRLiveStatusNotStart) {
                
                jumpModel.liveStatus = WVRLiveStatusNotStart;
            } else if (itemModel.liveStatus == WVRLiveStatusPlaying) {
                
                jumpModel.liveStatus = WVRLiveStatusPlaying;
            } else {
                jumpModel.liveStatus = WVRLiveStatusEnd;
                DDLogError(@"当前版本并没有直播节目单独的购买，应该是合集");
            }
        }
            break;
        case PurchaseProgramTypeCollection: {
            
            jumpModel.linkArrangeType = LINKARRANGETYPE_CONTENT_PACKAGE;
            jumpModel.linkArrangeValue = itemModel.merchandiseCode;
        }
            break;
        default:
            break;
    }
    
    NSDictionary *dict = @{ @"param":[jumpModel yy_modelToJSONObject], @"nav":self.navigationController };
    [[WVRMediator sharedInstance] WVRMediator_gotoNextVC:dict];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataModel.content.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRMyOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myOrderCellId forIndexPath:indexPath];
    
    cell.dataModel = [_dataModel.content objectAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark - request

int _myOrderRequestCount = 40;

- (void)requestDataWithPage:(int)page {
    
    if (!_mainView) {
        [self showProgress];
    }
    self.gMyOrderViewModel.gPage = [NSString stringWithFormat:@"%d",page];
    [[self.gMyOrderViewModel myOrderListCmd] execute:nil];
//    @weakify(self);
//    kWeakSelf(self);
//    [WVRMyOrderListModel requestForMyOrderListWithPage:page pageSize:_myOrderRequestCount block:^(WVRMyOrderListModel *model, NSError *error) {
//
//        if (model) {
//
//            // 数据源变化，触发UI刷新
//            [weakself setDataModel:model];
//
//        } else {
//
//            [weakself networkFaild];
//        }
//    }];
}

- (void)refreshUI {
    
    if (!_dataModel) { return; }
    
    if (self.mainView) {
        [self.mainView reloadData];
        
        if (_dataModel.number == 0) {
            
            [self.mainView.mj_header endRefreshing];
        } else {
            
            [self.mainView.mj_footer endRefreshing];
        }
        
        if ((_dataModel.totalPages - 1) <= _dataModel.number) {
            
            [self.mainView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } else {
        [self drawUI];
    }
}

- (void)pulldownRefreshData {
    
    _curPage = 0;
    [self requestDataWithPage:_curPage];
}

- (void)pullupLoadMoreData {
    
    ++ _curPage;
    [self requestDataWithPage:_curPage];
}

- (void)re_requestData {
    
    [self pulldownRefreshData];
}

- (void)networkFaild {
    
    [self hideProgress];
    
    if (_mainView) {          // 已有界面
        [self.mainView.mj_header endRefreshing];
        [self.mainView.mj_footer endRefreshing];
        [self showMessage:kNetError];
        
    } else {                    // 未有界面
        [self detailLoadFail:nil];
    }
}


-(void)requestInfo
{
    [self re_requestData];
}

@end

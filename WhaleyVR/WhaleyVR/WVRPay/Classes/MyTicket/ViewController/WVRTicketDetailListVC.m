//
//  WVRPurchaseDetailListVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/6.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 购买明细

#import "WVRTicketDetailListVC.h"
#import "WVRPurchaseDetailListCell.h"
#import "WVRExchangeTicketModel.h"
#import "WVRUserCouponOrderListViewModel.h"

@interface WVRTicketDetailListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *mainView;
@property (nonatomic, strong) UIView    *headView;
@property (nonatomic, strong) WVRUserTicketListModel *dataModel;

@property (nonatomic, assign) int curPage;

@property (nonatomic, strong) WVRUserCouponOrderListViewModel *gUserCouponViewModel;

@end


@implementation WVRTicketDetailListVC

static NSString *const purchaseDetailListCellId = @"purchaseDetailListCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购买明细";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _curPage = 0;
    [self installRAC];
    
    [self requestDataWithPage:_curPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)installRAC
{
    @weakify(self);
    [self.gUserCouponViewModel.gSuccessSignal subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        [self updateDataSuccess:x];
    }];
    [self.gUserCouponViewModel.gFailSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self networkFaild];
    }];
}

- (void)drawUI {
    
    [self hideProgress];
    
    if (_dataModel.orderListPageCache.content.count > 0) {
        
        [self createMainView];
    } else {
        [self createNullView];
    }
}

- (WVRUserCouponOrderListViewModel *)gUserCouponViewModel {
    if (!_gUserCouponViewModel) {
        _gUserCouponViewModel = [[WVRUserCouponOrderListViewModel alloc] init];
    }
    return _gUserCouponViewModel;
}

- (void)createMainView {
    
    self.view.backgroundColor = Color_RGB(245, 245, 245);
    
//    float rowHeight = adaptToWidth(85);
    
    CGRect rect = CGRectMake(0, kNavBarHeight, self.view.width, self.view.height - kNavBarHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.rowHeight = rowHeight;
    tableView.bounces = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = self.headView;
    tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
    [tableView registerClass:[WVRPurchaseDetailListCell class] forCellReuseIdentifier:purchaseDetailListCellId];
    tableView.tableFooterView = [[UIView alloc] init];
    
    tableView.mj_header = [SQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    
    if (self.dataModel.orderListPageCache.content.count >= kHTTPPageSize) {
        
        tableView.mj_footer = [SQRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupLoadMoreData)];
    }
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:tableView];
    _mainView = tableView;
}

- (UIView *)headView {
    
    if (!_headView) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, adaptToWidth(45))];
        
        float x = adaptToWidth(10);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, _headView.width - x, _headView.height)];
        
        label.text = [NSString stringWithFormat:@"总计购买%d次，拥有%d个券，共价值%@", _dataModel.totalNum, _dataModel.orderListPageCache.totalElements, [WVRComputeTool numToPrice:_dataModel.sumAmount]];
        
        label.textColor = k_Color6;
        label.font = kFontFitForSize(13);
        label.backgroundColor = [UIColor clearColor];
        
        [_headView addSubview:label];
        _headView.backgroundColor = [UIColor clearColor];
    }
    return _headView;
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
    label.text = @"没有已购买的观看券";
    label.font = kFontFitForSize(15.5);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = k_Color5;
    [self.view addSubview:label];
}

#pragma mark - setter

- (void)setDataModel:(WVRUserTicketListModel *)dataModel {
    
    if (_curPage == 0) {
        _dataModel = dataModel;
    } else {
        NSMutableArray *list = [_dataModel.orderListPageCache.content mutableCopy];
        
        for (WVRUserTicketItemModel *model in dataModel.orderListPageCache.content) {
            
            [list addObject:model];
        }
        _dataModel.orderListPageCache.content = list;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath: %d", (int)indexPath.item);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRPurchaseDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:purchaseDetailListCellId];
    
    [cell setDataModel:[_dataModel.orderListPageCache.content objectAtIndex:indexPath.item]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataModel.orderListPageCache.content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRUserTicketItemModel *model = [_dataModel.orderListPageCache.content objectAtIndex:indexPath.item];
    return model.cellHeight;
}

#pragma mark - request

int _purchaseDetailRequestCount = 40;

- (void)requestDataWithPage:(int)page {
    
    if (!_mainView) {
        [self showProgress];
    }
    
    self.gUserCouponViewModel.page = [NSString stringWithFormat:@"%d", _curPage];
    self.gUserCouponViewModel.size = @"1000";
    [self.gUserCouponViewModel.requestCmd execute:nil];
}

- (void)updateDataSuccess:(WVRUserTicketListModel *)model {
    
    [self setDataModel:model];
    
    if (self.mainView) {
        [self.mainView reloadData];
        
        if (_curPage == 0) {
            [self.mainView.mj_header endRefreshing];
        } else {
            if (model.orderListPageCache.totalPages - 1 <= _curPage) {
                [self.mainView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.mainView.mj_footer endRefreshing];
            }
        }
    } else {
        [self drawUI];
    }
}

/// 下拉刷新
- (void)pulldownRefreshData {
    
    _curPage = 0;
    [self requestDataWithPage:_curPage];
}

/// 上拉加载更多
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

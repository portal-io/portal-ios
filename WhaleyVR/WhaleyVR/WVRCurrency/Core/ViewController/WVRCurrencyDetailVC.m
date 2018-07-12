//
//  WVRCurrencyDetailVC.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyDetailVC.h"
#import "WVRCurrencyDetailViewModel.h"
#import "WVRTableViewAdapter.h"

#import "WVRBaseEmptyView.h"

@interface WVRCurrencyDetailVC ()

@property (nonatomic, strong) WVRCurrencyDetailViewModel * gCurrencyDetailViewModel;

@end

@implementation WVRCurrencyDetailVC
@synthesize gTableView = _gTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.gTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.gTableView];
    
    [self installRAC];
    [self requestInfo];
}

- (void)initTitleBar {
    
    [super initTitleBar];
    self.title = @"充值明细";
}

- (WVRCurrencyDetailViewModel *)gCurrencyDetailViewModel {
    if (!_gCurrencyDetailViewModel) {
        _gCurrencyDetailViewModel = [[WVRCurrencyDetailViewModel alloc] init];
    }
    return _gCurrencyDetailViewModel;
}

- (UITableView *)gTableView
{
    if (!_gTableView) {
        _gTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _gTableView.y = kNavBarHeight;
        _gTableView.height -= _gTableView.y;
        _gTableView.delegate = self.gCurrencyDetailViewModel.gTableViewAdapter;
        _gTableView.dataSource = self.gCurrencyDetailViewModel.gTableViewAdapter;
        _gTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        _gTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        [_gTableView setSeparatorColor:k_Color9];
        [_gTableView setSeparatorInset:UIEdgeInsetsMake(0, -15, 0, 0)];
//        [_gTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _gTableView.backgroundColor = [UIColor colorWithHex:0xebeff2];
    }
    return _gTableView;
}

- (void)installRAC
{
    @weakify(self);
    [self.gCurrencyDetailViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gCurrencyDetailViewModel.isEmpty) {
            
            [self showEmptyView];
        } else {
            
            [self.gTableView reloadData];
        }
    }];
    [self.gCurrencyDetailViewModel.mFailSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self detailLoadFail:nil];
    }];
}

- (void)requestInfo
{
    [[self.gCurrencyDetailViewModel getCurrencyOrderListCmd] execute:nil];
}

// 充值记录为空
- (void)showEmptyView {
    
    [self.gTableView removeFromSuperview];
    
    WVRBaseEmptyView *view = [[WVRBaseEmptyView alloc] initWithFrame:self.view.bounds];
    view.userInteractionEnabled = NO;
    [self.view addSubview:view];
    [view showNullViewWithTitle:@"充值记录为空" icon:@"http_request_failed" withreloadBlock:^(){}];
}

@end

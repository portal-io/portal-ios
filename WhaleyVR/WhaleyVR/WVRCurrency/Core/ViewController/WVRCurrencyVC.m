//
//  WVRCurrencyVC.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyVC.h"
#import "WVRCurrencyFaceValueViewModel.h"
#import "WVRTableViewAdapter.h"
#import "WVRCurrencyBalanceHeadView.h"
#import "WVRCurrencyExplainVC.h"
#import "WVRCurrencyBalanceHeadViewModel.h"
#import "WVRCurrencyDetailVC.h"

@interface WVRCurrencyVC ()

@property (nonatomic, strong) WVRCurrencyFaceValueViewModel * gFaceValueViewModel;

@property (nonatomic, weak) WVRCurrencyBalanceHeadView * gBalanceHeadView;

@end

@implementation WVRCurrencyVC
@synthesize gTableView = _gTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.gTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self showCancleLeftBtn];
    self.title = @"鲸币";
    [self.view addSubview:self.gTableView];
    [self.view addSubview:self.gBalanceHeadView];
    [self installRAC];
    [self requestInfo];
}

-(void)initTitleBar
{
    [super initTitleBar];
    [self installRightItem];
}

-(void)installRightItem
{
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 60, 44);
//    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightButton addTarget:self action:@selector(gotoCurrencyDetailVC) forControlEvents:UIControlEventTouchUpInside];
//
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCurrencyDetailVC)];
    
    self.navigationItem.rightBarButtonItem = item;

}

-(void)gotoCurrencyDetailVC
{
    WVRCurrencyDetailVC * vc = [[WVRCurrencyDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(WVRCurrencyFaceValueViewModel *)gFaceValueViewModel
{
    if(!_gFaceValueViewModel){
        _gFaceValueViewModel = [[WVRCurrencyFaceValueViewModel alloc] init];
        @weakify(self);
        _gFaceValueViewModel.gGotoWCDescrCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            [self gotoWCDescrVC];
            return [RACSignal empty];
        }];
    }
    return _gFaceValueViewModel;
}

-(void)gotoWCDescrVC
{
    WVRCurrencyExplainVC * vc = [[WVRCurrencyExplainVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableView *)gTableView
{
    if (!_gTableView) {
        _gTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _gTableView.y = self.gBalanceHeadView.bottomY;
        _gTableView.height -= _gTableView.y;
        _gTableView.delegate = self.gFaceValueViewModel.gTableViewAdapter;
        _gTableView.dataSource = self.gFaceValueViewModel.gTableViewAdapter;
//        _gTableView.sectionFooterHeight = 0;
//        _gTableView.sectionHeaderHeight = 0;
//        _gTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
//        _gTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        [_gTableView setSeparatorColor:k_Color9];
//        [_gTableView setSeparatorInset:UIEdgeInsetsMake(0, -15, 0, 0)];
        [_gTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _gTableView.backgroundColor = [UIColor whiteColor];
    }
    return _gTableView;
}

-(WVRCurrencyBalanceHeadView *)gBalanceHeadView
{
    if(!_gBalanceHeadView){
        WVRCurrencyBalanceHeadViewModel * vm = [[WVRCurrencyBalanceHeadViewModel alloc] init];
        WVRCurrencyBalanceHeadView * cur = (WVRCurrencyBalanceHeadView*)VIEW_WITH_NIB(@"WVRCurrencyBalanceHeadView");
        cur.frame = CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, [vm cellHeight]);
        [cur fillData:vm];
        _gBalanceHeadView = cur;
    }
    return _gBalanceHeadView;
}

-(void)installRAC
{
    @weakify(self);
    [self.gFaceValueViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gTableView reloadData];
    }];
    [self.gFaceValueViewModel.mFailSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self detailLoadFail:nil];
    }];
}

-(void)requestInfo
{
    [[self.gFaceValueViewModel getCurrencyBuyConfigLCmd] execute:nil];
}
@end

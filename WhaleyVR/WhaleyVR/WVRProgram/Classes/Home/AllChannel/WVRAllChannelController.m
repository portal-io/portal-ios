//
//  WVRAllChannelController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelController.h"
#import "WVRAllChannelCProtocol.h"
#import "WVRAllChannelPresenter.h"

#import "SQRefreshHeader.h"
#import "WVRBaseCollectionView.h"

@interface WVRAllChannelController ()<WVRAllChannelCProtocol>

@property (nonatomic, strong) WVRAllChannelPresenter * gPresenter;

@end

@implementation WVRAllChannelController
@synthesize gCollectionView = _gCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gCollectionView];
    [self.gPresenter fetchData];
}

- (void)initTitleBar {
    
    [super initTitleBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"全部频道";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gCollectionView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

- (void)stopHeaderRefresh
{
    [self.gCollectionView.mj_header endRefreshing];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate andDataSource:(id<UICollectionViewDataSource>)dataSource
{
    self.gCollectionView.delegate = delegate;
    self.gCollectionView.dataSource = dataSource;
}

- (void)reloadData
{
    [self.gCollectionView reloadData];
}

- (WVRAllChannelPresenter *)gPresenter
{
    if (!_gPresenter) {
        _gPresenter = [[WVRAllChannelPresenter alloc] initWithParams:nil attchView:self];
    }
    return _gPresenter;
}

- (UICollectionView *)getCollectionView
{
    return self.gCollectionView;
}

- (WVRBaseCollectionView *)gCollectionView {
    
    if (!_gCollectionView) {
        _gCollectionView = [[WVRBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        kWeakSelf(self);
        SQRefreshHeader * header = [SQRefreshHeader headerWithRefreshingBlock:^{
            [weakself.gPresenter fetchRefreshData];
        }];
        _gCollectionView.mj_header = header;
        _gCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return (WVRBaseCollectionView*)_gCollectionView;
}

//- (void)dealloc {
//    
//    DDLogInfo(@"");
//}

@end

//
//  WVR	AutoAarrangeController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 自动编排

#import "WVRAutoArrangeController.h"
#import "WVRAutoArrangeView.h"
#import "WVRAutoArrangePresenter.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRAutoArrangeControllerProtocol.h"

@interface WVRAutoArrangeController ()<WVRAutoArrangeControllerProtocol>

@property (nonatomic, strong) WVRAutoArrangePresenter * gAutoArrangeP;

@end


@implementation WVRAutoArrangeController
@synthesize gCollectionView = _gCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gCollectionView];
    
    [self.gAutoArrangeP fetchData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(WVRBaseCollectionView *)gCollectionView
{
    if (!_gCollectionView) {
        _gCollectionView = [[WVRBaseCollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[UICollectionViewFlowLayout new]];
        _gCollectionView.backgroundColor = UIColorFromRGB(0xeeeeee);
        kWeakSelf(self);
        [(WVRBaseCollectionView*)_gCollectionView addHeaderRefresh:^{
            [weakself.gAutoArrangeP fetchRefreshData];
        }];
        [(WVRBaseCollectionView*)_gCollectionView addFooterMore:^{
            [weakself.gAutoArrangeP fetchMoreData];
        }];
    }
    return (WVRBaseCollectionView*)_gCollectionView;
}

-(UICollectionView*)getCollectionView
{
    return self.gCollectionView;
}

-(WVRAutoArrangePresenter *)gAutoArrangeP
{
    if (!_gAutoArrangeP) {
        _gAutoArrangeP = [[WVRAutoArrangePresenter alloc] initWithParams:self.createArgs attchView:self];
    }
    return _gAutoArrangeP;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gCollectionView.frame = CGRectMake(0, kNavBarHeight, self.view.width, self.view.height-kNavBarHeight);
//    [self.gCollectionView scrollRectToVisible:CGRectMake(0, 0, self.gCollectionView.contentSize.width, self.gCollectionView.contentSize.height) animated:YES];
}

#pragma mark - WVRCollectionViewCProtocol

-(void)setDelegate:(id<UICollectionViewDelegate>)delegate andDataSource:(id<UICollectionViewDataSource>)dataSource
{
    self.gCollectionView.delegate = delegate;
    self.gCollectionView.dataSource = dataSource;
}

-(void)reloadData
{
    [self.gCollectionView reloadData];
    
}

- (void)initTitleBar
{
    [super initTitleBar];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)stopHeaderRefresh
{
    [(WVRBaseCollectionView*)self.gCollectionView stopHeaderRefresh];
}

-(void)stopFooterMore:(BOOL)noMore
{
    [(WVRBaseCollectionView*)self.gCollectionView stopFooterMore:noMore];
}


@end

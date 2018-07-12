//
//  WVRBrandZoneController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBrandZoneController.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRGotoNextTool.h"

#import "WVRBrandZonePresenter.h"

@interface WVRBrandZoneController ()

@property (nonatomic, strong) WVRBrandZonePresenter * gPresenter;

@end


@implementation WVRBrandZoneController

//+ (instancetype)createViewController:(id)createArgs
//{
//    WVRBrandZoneController * vc = [[WVRBrandZoneController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
//    
//    return vc;
//}


//-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
//{
//    self = [super initWithCollectionViewLayout:layout];
//    if (self) {
//        self.cellNibNames = @[NSStringFromClass([WVRSQBrandCell class])];
//        if (!self.mBrandModel) {
//            self.mBrandModel =[WVRBrandZoneVCModel new];
//        }
//        
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self.gPresenter fetchData];
}

-(void)loadSubViews
{
    kWeakSelf(self);
    SQRefreshHeader * refreshHeader = [SQRefreshHeader headerWithRefreshingBlock:^{
        [weakself.gPresenter fetchRefreshData];
    }];
    self.gCollectionView.mj_header = refreshHeader;
    SQRefreshFooter * mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
        [weakself.gPresenter fetchMoreData];
    }];
    self.gCollectionView.mj_footer = mj_footer;
}

-(void)initTitleBar
{
    [super initTitleBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gCollectionView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

-(UICollectionView*)getCollectionView
{
    return self.gCollectionView;
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


@end

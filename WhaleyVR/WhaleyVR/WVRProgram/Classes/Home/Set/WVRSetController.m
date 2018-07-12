//
//  WVRCollectionController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSetController.h"
#import "WVRSetViewModel.h"
#import "WVRSectionModel.h"
#import "WVRSetCell.h"
#import "WVRGotoNextTool.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"

#import "WVRSetViewCProtocol.h"
#import <ReactiveObjC.h>
#import "WVRBaseViewSection.h"

#import "WVRBaseCollectionView.h"

@interface WVRSetController ()<WVRSetViewCProtocol>

@property (nonatomic) WVRSetViewModel * gViewModel;

@property (nonatomic, strong) WVRKVOHandler * gKVOH;

@property (nonatomic, assign) BOOL gHaveShow;

@end


@implementation WVRSetController
@synthesize gCollectionView = _gCollectionView;

- (WVRBaseCollectionView *)gCollectionView {
    
    if (!_gCollectionView) {
        _gCollectionView = [[WVRBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        @weakify(self);
        _gCollectionView.mj_header = [SQRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self headRefreshBlock];
        }];
    }
    return (WVRBaseCollectionView *)_gCollectionView;
}

- (void)headRefreshBlock
{
    [self.gViewModel.refreshCmd execute:nil];
}

- (void)footerMoreBlock {
    
    [self.gViewModel.moreCmd execute:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installRAC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)installRAC {
    
    self.gViewModel.code = self.createArgs[@"code"];
    self.gViewModel.subCode = self.createArgs[@"subCode"];
    //    RAC(self.gViewModel, code) = self.createArgs[@"code"];
    //    RAC(self.gViewModel, subCode) = self.createArgs[@"subCode"];
    @weakify(self);
    [[[RACObserve(self.gViewModel, gOriginDic) skip:1] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self fetchDataSuccessUI];
    }];
    [[[RACObserve(self.gViewModel, gError) skip:1] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self fetchDataFailUI];
    }];
    self.gCollectionView.delegate = self.gViewModel.gDelegate;
    self.gCollectionView.dataSource = self.gViewModel.gDelegate;
    [self headRefreshBlock];
}

- (void)fetchDataSuccessUI
{
    if (!self.gCollectionView.mj_footer) {
        @weakify(self);
        self.gCollectionView.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self footerMoreBlock];
        }];
    }
    
    WVRBaseViewSection * sectionInfo = self.gViewModel.gOriginDic[@(0)];
    [sectionInfo registerNibForCollectionView:self.gCollectionView];
    [self.gCollectionView.mj_header endRefreshing];
    if (self.gViewModel.haveMore) {
        [self.gCollectionView.mj_footer endRefreshing];
    }else{
        [self.gCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
    if (sectionInfo.cellDataArray.count == 0 && !self.gHaveShow) {
        @weakify(self);
        [self showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self headRefreshBlock];
        }];
        return;
    }
    self.gHaveShow = YES;
    [self.gCollectionView reloadData];
}

- (void)fetchDataFailUI
{
    [self.gCollectionView.mj_header endRefreshing];
    [self.gCollectionView.mj_footer endRefreshing];
    if (!self.gHaveShow) {
        @weakify(self);
        [self showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self headRefreshBlock];
        }];
    }
    [self.gCollectionView reloadData];
}


- (WVRSetViewModel *)gViewModel
{
    if (!_gViewModel) {
        _gViewModel = [[WVRSetViewModel alloc] init];
    }
    return _gViewModel;
}

- (WVRKVOHandler *)gKVOH
{
    if (!_gKVOH) {
        _gKVOH = [[WVRKVOHandler alloc] init];
    }
    return _gKVOH;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    
//    [self.gViewModel removeObserver:self.gKVOH forKeyPath:@"title"];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gCollectionView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

- (void)addKVO
{
    //    self.title = self.gViewModel.title;
    //    //观察小孩的hapyValue
    //    //使用KVO为_children对象添加一个观察者，用于观察监听hapyValue属性值是否被修改
    //
    //    [self.gViewModel addObserver:self.gKVOH forKeyPath:@"title" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:@"context"];
    //
    //观察小孩的hurryValue
    //    [self.gViewModel addObserver:self forKeyPath:@"hurryValue" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:@"context"];
    //}
}

@end


@implementation WVRKVOHandler

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        NSString *oldTitle = [change objectForKey:@"old"];//修改之后的最新值
        NSString *newTitle = [change objectForKey:@"new"];//修改之后的最新值
        
        SQToastInKeyWindow([oldTitle stringByAppendingString:newTitle]);
        
    }
}

@end

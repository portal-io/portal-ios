//
//  WVRPageRecommendPresenterImpl.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPageRecommendPresenter.h"
#import "WVRManualArrangeViewModel.h"
#import "WVRBaseViewSection.h"
#import "WVRBaseCollectionView.h"
#import "WVRViewModelDispatcher.h"
#import "WVRSetViewModel.h"

@interface WVRPageRecommendPresenter()

@property (nonatomic, strong) WVRSetViewModel * gViewModel;

@property (nonatomic, strong) NSMutableDictionary * originDic;

//@property (nonatomic, strong) WVRPageRecommendViewModel * gPageRecommendViewModel;

@end

@implementation WVRPageRecommendPresenter

//@page(([NSString stringWithFormat:@"%d%@",(int)WVRLinkTypePage,RECOMMENDPAGETYPE_PAGE]), NSStringFromClass([WVRPageRecommendPresenter class]))
+ (void)load {
    [WVRViewModelDispatcher registerPage:[NSString stringWithFormat:@"%d%@",(int)WVRLinkTypePage,RECOMMENDPAGETYPE_PAGE] className:NSStringFromClass([WVRPageRecommendPresenter class])];
    [WVRViewModelDispatcher registerPage:[NSString stringWithFormat:@"%d%@",(int)WVRLinkTypePage,LINKARRANGETYPE_RECOMMENDPAGE] className:NSStringFromClass([WVRPageRecommendPresenter class])];
}
- (instancetype)initWithParams:(id)params attchView:(id<WVRCollectionViewProtocol>)view {
    
    self = [super init];
    if (self) {
        self.args = params;
        self.collectionViewDelegte = [SQCollectionViewDelegate new];
        self.gView = view;
        [self installRAC];
    }
    return self;
}


-(WVRSetViewModel *)gViewModel
{
    if (!_gViewModel) {
        _gViewModel = [[WVRSetViewModel alloc] init];
    }
    return _gViewModel;
}


-(void)fetchData
{
    [self requestData];
}

- (void)requestData {
    [self.gView clear];
    if (self.originDic.count==0) {
        [self.gView showLoadingWithText:nil];
    }
    [[self.gViewModel refreshCmd] execute:nil];
}


- (void)footerMoreBlock {
    
    [self.gViewModel.moreCmd execute:nil];
}

- (void)requestInfo:(id)requestParams {
    self.args = requestParams;
    [self requestData];
}

- (void)requestInfoForFirst:(id)requestParams {
    
    if (self.originDic.count == 0) {
        [self requestInfo:requestParams];
    }
}


- (void) headerRefreshRequestInfo:(id)requestParams {
    self.args = requestParams;
    [self headerRefreshRequest:YES requestParams:requestParams? requestParams:self.args];
}

- (void)headerRefreshRequest:(BOOL)firstRequest requestParams:(id)requestParams {
    self.args = requestParams;
    [[self.gViewModel refreshCmd] execute:nil];

}

- (void)httpSuccessBlock:(WVRBaseViewSection *)args {
    
    [self.gView hidenLoading];
    if (!self.collectionView.mj_footer) {
        @weakify(self);
        self.collectionView.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self footerMoreBlock];
        }];
    }
    
    WVRBaseViewSection * sectionInfo = args;
    [sectionInfo registerNibForCollectionView:self.collectionView];
    [self.collectionView.mj_header endRefreshing];
    if (self.gViewModel.haveMore) {
        [self.collectionView.mj_footer endRefreshing];
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    [self parseInfoToOriginDic:args];
}

- (void)httpFailBlock:(NSString *)args {
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (self.originDic.count == 0) {
        kWeakSelf(self);
        [self.gView showNetErrorVWithreloadBlock:^{
            [weakself requestData];
        }];
    }else{
        SQToastInKeyWindow(kNoNetAlert);
    }
}

- (void)parseInfoToOriginDic:(WVRBaseViewSection *)args {
    
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary dictionary];
    }
    [self.originDic removeAllObjects];
    
    WVRBaseViewSection * sectionInfo = args;
    self.originDic[@(0)] = sectionInfo;
    [self.gView setDelegate:self.collectionViewDelegte andDataSource:self.collectionViewDelegte];
    [self.collectionViewDelegte loadData:self.originDic];
    [self.gView reloadData];
}

- (void)installRAC {
    
    self.gViewModel.code = [self.args linkArrangeValue];
    NSString* subCode = [[self.args recommendAreaCodes] firstObject];
    self.gViewModel.subCode = subCode;
    
    @weakify(self);
    [[[RACObserve(self.gViewModel, gOriginDic) skip:1] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:self.gViewModel.gOriginDic[@(0)]];
    }];
    [[[RACObserve(self.gViewModel, gError) skip:1] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpFailBlock:@""];
    }];
}

@end

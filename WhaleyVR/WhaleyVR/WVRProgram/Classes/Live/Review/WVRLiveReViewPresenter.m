//
//  WVRLiveViewController.m
//  WhaleyVR
//
//  Created by Snailvr on 16/8/31.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 直播

#import "WVRLiveReViewPresenter.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRSetViewModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveReviewCell.h"

#import "WVRLiveReviewViewModel.h"
#import "WVRHomePageCollectionView.h"

#define PAGE_COUNT (2)

@interface WVRLiveReViewPresenter ()


@property (nonatomic) WVRSetViewModel * mLiveReModel;
@property (nonatomic) WVRSectionModel * mSModel;

@property (nonatomic, strong) WVRLiveReviewViewModel * gLiveReviewViewModel;

@end


@implementation WVRLiveReViewPresenter

//@page(([NSString stringWithFormat:@"%d%@",(int)WVRLinkTypeMix,LINKARRANGETYPE_RECOMMENDPAGE]), NSStringFromClass([WVRLiveReViewPresenter class]))
//
//- (instancetype)initWithParams:(id)params attchView:(id<WVRCollectionViewProtocol>)view {
//    
//    self = [super init];
//    if (self) {
//        self.args = params;
//        self.collectionViewDelegte = [SQCollectionViewDelegate new];
//        kWeakSelf(self);
//        self.collectionViewDelegte.scrollDidScrolling = ^(CGFloat y){
////            [weakself checkBannerVisibleBlock:y];
//        };
//        self.gView = view;
////        [self installRAC];
//    }
//    return self;
//}
//+ (instancetype)createPresenter:(id)createArgs {
//
//    WVRLiveReViewPresenter * presenter = [[WVRLiveReViewPresenter alloc] init];
//    presenter.createArgs = createArgs;
//    presenter.cellNibNames = @[NSStringFromClass([WVRLiveReviewCell class])];
//    presenter.mLiveReModel = [WVRSetViewModel new];
//    [presenter loadViews];
//    [presenter installRAC];
//    return presenter;
//}

//- (instancetype)initWithParams:(id)params attchView:(id<WVRCollectionViewProtocol>)view
//{
//    self = [super init];
//    if (self) {
//        self.args = params;
//        self.collectionViewDelegte = [SQCollectionViewDelegate new];
//        kWeakSelf(self);
//        self.collectionViewDelegte.scrollDidScrolling = ^(CGFloat y){
//            [weakself checkBannerVisibleBlock:y];
//        };
//        self.gView = view;
//        [self installRAC];
//    }
//    return self;
//}
//
//- (void)loadViews {
//
//    [self initCollectionView];
//}
//
//- (UIView *)getView {
//
//    return self.mCollectionV;
//}
//
//- (void)reloadData {
//
//    if (self.collectionVOriginDic.count == 0) {
//        [self requestInfo];
//    }
//}
//
//-(WVRLiveReviewViewModel *)gLiveReviewViewModel
//{
//    if (!_gLiveReviewViewModel) {
//        _gLiveReviewViewModel = [[WVRLiveReviewViewModel alloc] init];
//    }
//    return _gLiveReviewViewModel;
//}
//
//-(void)installRAC
//{
//    @weakify(self);
//    [[self.gLiveReviewViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        [self httpSuccessBlock:x];
//    }];
//    [[self.gLiveReviewViewModel mFailSignal] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
//        @strongify(self);
//        [self httpFailBlock:x.errorMsg];
//    }];
//}
//
//-(WVRHomePageCollectionView *)mCollectionV
//{
//    if (!_mCollectionV) {
//        _mCollectionV = (SQCollectionView*)[[WVRHomePageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
//    }
//    return (WVRHomePageCollectionView*)_mCollectionV;
//}
//
//- (void)initCollectionView {
//
//    [super initCollectionView];
//    kWeakSelf(self);
//    SQRefreshHeader * refreshHeader = [SQRefreshHeader headerWithRefreshingBlock:^{
//        [weakself requestInfo];
//    }];
//    refreshHeader.stateLabel.hidden = YES;
//    self.mCollectionV.mj_header = refreshHeader;
//    SQRefreshFooter * refreshFooter = [SQRefreshFooter footerWithRefreshingBlock:^{
//        [weakself footerMoreRequest];
//    }];
//    self.mCollectionV.mj_footer = refreshFooter;
//}
//
//- (void)requestInfo {
//
//    [super requestInfo];
//    if (self.mSModel==nil) {
//        SQShowProgressIn(self.mCollectionV);
//    }
//    self.gLiveReviewViewModel.code = [self.createArgs linkCode];
//    self.gLiveReviewViewModel.subCode = [self.createArgs subCode];
//    [[self.gLiveReviewViewModel getLiveReviewCmd] execute:nil];
//
//}
//
//- (void)httpSuccessBlock:(WVRSectionModel *)sectionModel
//{
//    kWeakSelf(self);
//    if (sectionModel==nil) {
//        if (self.mSModel==nil) {
//
//            [self showNetErrorV:weakself.mCollectionV reloadBlock:^{
//                [weakself requestInfo];
//            }];
//        }
//        SQHideProgressIn(self.mCollectionV);
//        return ;
//    }
//    [self removeNetErrorV];
//    self.mSModel = sectionModel;
//    self.collectionVOriginDic[@(0)] = [self getSectionInfo];
//    [self updateCollectionView];
//    SQHideProgressIn(self.mCollectionV);
//    [self.mCollectionV.mj_header endRefreshing];
//    [self.mCollectionV.mj_footer endRefreshing];
//}
//
//- (void)footerMoreRequest {
//
//    if (self.mSModel.pageNum == self.mSModel.totalPages-1) {
//        [self endRefreshNoMore];
//        return;
//    }
//    if (self.collectionVOriginDic.count==0) {
//        SQShowProgressIn(self.mCollectionV);
//    }
//    [[self.gLiveReviewViewModel getLiveReviewMoreCmd] execute:nil];
//
//}
//
//- (void)httpSuccessUI:(WVRSectionModel*)args {
//
//    SQHideProgressIn(self.mCollectionV);
//    [self endRefresh];
////    self.mSModel.itemModels = args.itemModels;
//    self.mSModel = args;
//    if (args.itemModels.count==0) {
//        if (self.collectionVOriginDic.count==0) {
//            kWeakSelf(self);
//            [(WVRHomePageCollectionView*)[self mCollectionV] showNetErrorVWithreloadBlock:^{
//                [weakself requestInfo];
//            }];
//        }
//        SQHideProgressIn(self.mCollectionV);
//        return ;
//    }
//    self.collectionVOriginDic[@(0)] = [self getSectionInfo];
//    [self updateCollectionView];
//}
//
//- (void)httpFailBlock:(NSString*)errMsg {
//
//    SQHideProgressIn(self.mCollectionV);
//    kWeakSelf(self);
//    [self endRefresh];
//    if (self.mSModel.itemModels.count==0) {
//        [(WVRHomePageCollectionView*)[self mCollectionV] showNetErrorVWithreloadBlock:^{
//            [weakself requestInfo];
//        }];
//    }else{
//        SQToastInKeyWindow(kNoNetAlert);
//    }
//}
//
//- (void)endRefresh {
//
//    [self.mCollectionV.mj_header endRefreshing];
//    [self.mCollectionV.mj_footer endRefreshing];
//}
//
//- (void)endRefreshNoMore {
//
//    [self.mCollectionV.mj_footer endRefreshingWithNoMoreData];
//}
//
//- (SQCollectionViewSectionInfo *)getSectionInfo {
//
//    SQCollectionViewSectionInfo* sectionInfo = [SQCollectionViewSectionInfo new];
//    kWeakSelf(self);
//    NSMutableArray * cellInfos = [NSMutableArray array];
//    for (WVRSectionModel* model in self.mSModel.itemModels) {
//        WVRLiveReviewCellInfo * cellInfo = [WVRLiveReviewCellInfo new];
//        cellInfo.cellNibName = NSStringFromClass([WVRLiveReviewCell class]);
//        cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(214.0f));
//        cellInfo.itemModel = model;
//        cellInfo.gotoNextBlock = ^(id args){
//            [weakself cellInfoNextBlock:model];
//        };
//        [cellInfos addObject:cellInfo];
//    }
//
//    sectionInfo.cellDataArray = cellInfos;
//    return sectionInfo;
//}
//
//- (void)cellInfoNextBlock:(WVRSectionModel *)model {
//
//    [WVRGotoNextTool gotoNextVC:model nav:self.controller.navigationController];
//}
//
//- (void)gotoMoreVC:(WVRBaseModel*)model {
//
//    [WVRGotoNextTool gotoNextVC:model nav:self.controller.navigationController];
//}
//
//- (void)updateCollectionView {
//
//    [self.collectionDelegate loadData:self.collectionVOriginDic];
//    [self.mCollectionV reloadData];
//}

@end


@implementation WVRLiveReViewPModel

@end

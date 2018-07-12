//
//  WVRFootballPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballPresenter.h"
#import "WVRFootballViewModel.h"
#import "WVRNullCollectionViewCell.h"
#import "WVRLiveCell.h"
#import "WVRLiveEndCell.h"
#import "WVRSQFindSplitCell.h"
#import "WVRSQFindSplitFooter.h"
#import "SQRefreshHeader.h"
#import "WVRFootballViewModel.h"
#import "WVRSectionModel.h"
#import "WVRViewModelDispatcher.h"
#import "WVRBaseViewSection.h"
#import "WVRHomePageCollectionView.h"

@interface WVRFootballPresenter ()

@property (nonatomic) WVRFootballViewModel * gFootballVModel;
@property (nonatomic) NSDictionary * mModelDic;
@property (nonatomic, strong) NSMutableDictionary * originDic;

@end

@implementation WVRFootballPresenter
@page(([NSString stringWithFormat:@"%d%@",(int)1,LINKARRANGETYPE_FOOTBALLLIST]), NSStringFromClass([WVRFootballPresenter class]))


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

-(WVRFootballViewModel *)gFootballVModel
{
    if (!_gFootballVModel) {
        _gFootballVModel = [[WVRFootballViewModel alloc] init];
    }
    return _gFootballVModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gFootballVModel mCompleteSignal] subscribeNext:^(NSDictionary*  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gFootballVModel mFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self networkFaild];
    }];
}

-(void)fetchData
{
    [self requestInfo];
}

-(void)requestInfo
{
    if (self.originDic.count==0) {
        [self.gView showLoadingWithText:nil];
    }
    [self httpRequest];
}

- (void)requestInfo:(id)requestParams
{
    self.args = requestParams;
    [self requestInfo];
}

- (void)requestInfoForFirst:(id)requestParams
{
    if (self.originDic.count == 0) {
        [self requestInfo:requestParams];
    }
}

- (void) headerRefreshRequestInfo:(id)requestParams
{
    [self headerRefreshRequest:YES requestParams:requestParams? requestParams:self.args];
}


- (void)headerRefreshRequest:(BOOL)firstRequest requestParams:(id)requestParams
{
    [self requestInfo];
}

- (void)parseInfoToOriginDic:(NSDictionary *)args
{
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary dictionary];
    }
    [self.originDic removeAllObjects];
    
    for (NSNumber *key in [args allKeys]) {
        WVRSectionModel * sectionModel = args[key];
        WVRBaseViewSection * sectionInfo = [self sectionInfo:sectionModel];
        self.originDic[key] = sectionInfo;
    }
    [self.gView setDelegate:self.collectionViewDelegte andDataSource:self.collectionViewDelegte];
    [self.collectionViewDelegte loadData:self.originDic];
    [self.gView reloadData];
}

- (void)httpRequest {
    self.gFootballVModel.code = [self.args linkArrangeValue];
    [[self.gFootballVModel getFootballCmd] execute:nil];
}

//- (void)headerRefreshSuccessBlock:(WVRSectionModel*)sectionModel {
//
//    [self.gView hidenLoading];
////    if (!self.collectionView.mj_footer) {
////        @weakify(self);
////        self.collectionView.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
////            @strongify(self);
////            [self footerMore];
////        }];
////    }
//    [self parseInfoToOriginDic:@{@(0):sectionModel}];
//    [self.gView stopHeaderRefresh];
//}

//
//+ (instancetype)createPresenter:(id)createArgs {
//
//    WVRFootballPresenter * presenter = [[WVRFootballPresenter alloc] init];
//    presenter.createArgs = createArgs;
//    [presenter registerNot];
//    [presenter installRAC];
//    [presenter loadSubViews];
//    return presenter;
//}
//
//- (void)loadSubViews {
//
//    self.cellNibNames = @[NSStringFromClass([WVRLiveCell class]),NSStringFromClass([WVRLiveEndCell class]),NSStringFromClass([WVRSQFindSplitCell class])];
//    self.headerNibNames = @[];
//    self.footerNibNames = @[NSStringFromClass([WVRSQFindSplitFooter class])];
//    [self initCollectionView];
//}
//

//
//- (void)registerNot {
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSubViews) name:NAME_NOTF_LAYOUTSUBVIEWS_LIVE_RECOMMEND object:nil];
//}
//
//- (void)reloadSubViews {
//
//    [self installModelDic];
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
//-(WVRHomePageCollectionView *)mCollectionV
//{
//    if (!_mCollectionV) {
//        _mCollectionV = (SQCollectionView*)[[WVRHomePageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
//    }
//    return (WVRHomePageCollectionView*)_mCollectionV;
//}
//
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
//}
//
//- (void)requestInfo {
//    [super requestInfo];
//    [(WVRHomePageCollectionView*)[self mCollectionV] clear];
//    if (self.mModelDic.count==0) {
//        SQShowProgressIn(self.mCollectionV);
//    }
//    self.gFootballVModel.code = self.createArgs;
//    [[self.gFootballVModel getFootballCmd] execute:nil];
//}
//
- (void)httpSuccessBlock:(NSDictionary *)modelDic {
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (modelDic.count==0) {
        if (self.mModelDic.count==0) {
            kWeakSelf(self);
            [self.gView showNullViewWithTitle:nil icon:nil withreloadBlock:^{
                [weakself requestInfo];
            }];
        }
        return ;
    }
    self.mModelDic = modelDic;
    [self parseInfoToOriginDic:modelDic];
}
//
//- (void)installModelDic {
//
//    for (NSNumber* cur in self.mModelDic.allKeys) {
//        WVRSectionModel* curSectionModel = self.mModelDic[cur];
//
//        self.collectionVOriginDic[cur] = [self sectionInfo:curSectionModel];
//    }
//    [self updateCollectionView];
//
//}
//
//- (WVRBaseViewSection *)sectionInfo:(WVRSectionModel *)sectionModel {
//
////    NSLog(@"recommendAreaType:%ld", (long)sectionModel.sectionType);
//    WVRBaseViewSection * sectionInfo = nil;
//    NSInteger type = sectionModel.sectionType;
//    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d", (int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
//    [sectionInfo registerNibForCollectionView:self.mCollectionV];
////    sectionInfo.viewController = self.controller;
//    return sectionInfo;
//}
//
- (void)httpFailBlock:(NSString *)errMsg {
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (self.originDic.count == 0) {
        @weakify(self);
        [self.gView showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    }else{
        SQToastInKeyWindow(kNoNetAlert);
    }
    
}
//
//- (void)updateCollectionView {
//
//    [self.collectionDelegate loadData:self.collectionVOriginDic];
//    [self.mCollectionV reloadData];
//}
//
//- (void)dealloc {
//
//    DDLogInfo(@"dealloc");
//}

@end

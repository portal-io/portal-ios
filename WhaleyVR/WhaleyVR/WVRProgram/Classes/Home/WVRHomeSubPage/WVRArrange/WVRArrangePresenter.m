//
//  WVRArrangePresenterImpl.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRArrangePresenter.h"
#import "WVRAutoArrangeViewModel.h"
#import "WVRSmallPlayerPresenter.h"
#import "WVRSectionModel.h"
#import "WVRBaseViewSection.h"
#import "WVRBaseCollectionView.h"
#import "WVRViewModelDispatcher.h"
#import "SQRefreshFooter.h"
#import "WVRAutoArrangeViewModel.h"

@interface WVRArrangePresenter()

@property (nonatomic, strong) NSMutableDictionary * originDic;

@property (nonatomic) WVRAutoArrangeViewModel *gAutoArrangeViewModel;

@property (nonatomic, weak) WVRCollectionViewSectionInfo * mSinglPlayerSection;

@end

@implementation WVRArrangePresenter

@page(([NSString stringWithFormat:@"%d",(int)WVRLinkTypeList]), NSStringFromClass([WVRArrangePresenter class]))

- (instancetype)initWithParams:(id)params attchView:(id<WVRCollectionViewProtocol>)view
{
    self = [super init];
    if (self) {
        self.args = params;
        self.collectionViewDelegte = [SQCollectionViewDelegate new];
        kWeakSelf(self);
        self.collectionViewDelegte.scrollDidScrolling = ^(CGFloat y){
            [weakself checkBannerVisibleBlock:y];
        };
        self.gView = view;
        [self installRAC];
    }
    return self;
}

- (void)checkBannerVisibleBlock:(CGFloat) y
{
    if (y<fitToWidth(290.f)) {
//        if ([[WVRSmallPlayerPresenter shareInstance] prepared]) {
            if (![WVRSmallPlayerPresenter shareInstance].isPlaying) {
                if ([WVRReachabilityModel sharedInstance].isWifi) {
                    [[WVRSmallPlayerPresenter shareInstance] start];
                }
            }
//        }
        [[WVRSmallPlayerPresenter shareInstance] setShouldPause:NO];
    }else if(y>fitToWidth(290.f)){
        [[WVRSmallPlayerPresenter shareInstance] setShouldPause:YES];
        if ([WVRSmallPlayerPresenter shareInstance].isPlaying) {
            [[WVRSmallPlayerPresenter shareInstance] stop];
        }
    }
}

-(WVRAutoArrangeViewModel *)gAutoArrangeViewModel
{
    if (!_gAutoArrangeViewModel) {
        _gAutoArrangeViewModel = [[WVRAutoArrangeViewModel alloc] init];
    }
    return _gAutoArrangeViewModel;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gAutoArrangeViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self headerRefreshSuccessBlock:x];
    }];
    [[self.gAutoArrangeViewModel mFailSignal] subscribeNext:^(NSString*  _Nullable x) {
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

- (void)footerMoreRequestInfo:(id)requestParams
{
    [self footerMore];
}

- (void)headerRefreshRequest:(BOOL)firstRequest requestParams:(id)requestParams
{
    [self requestInfo];
}

- (void)footerMoreRequest:(BOOL)firstRequest requestParams:(id)requestParams
{
    [self footerMore];
}

- (void)parseInfoToOriginDic:(NSDictionary *)args
{
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary dictionary];
    }
    [self.originDic removeAllObjects];
    
    for (NSNumber *key in [args allKeys]) {
        WVRSectionModel * sectionModel = args[key];
        if (sectionModel.pageNum == sectionModel.totalPages) {
            [self.gView stopFooterMore:YES];
        }else{
            [self.gView stopFooterMore:NO];
        }
        WVRBaseViewSection * sectionInfo = [self sectionInfo:sectionModel];
        kWeakSelf(self);
        kWeakSelf(sectionInfo);
        sectionInfo.refreshBlock = ^{
                [(WVRBaseCollectionView *)weakself.collectionView updateWithSectionIndex:weaksectionInfo.sectionIndex];
        };
        self.originDic[key] = sectionInfo;
        if ([key integerValue] == WVRSectionModelTypeSinglePlay) {
            self.mSinglPlayerSection = sectionInfo;
        }
        break;
    }
    [self.gView setDelegate:self.collectionViewDelegte andDataSource:self.collectionViewDelegte];
    [self.collectionViewDelegte loadData:self.originDic];
    [self.gView reloadData];
}

- (void)httpRequest {
    self.gAutoArrangeViewModel.code = [self.args linkArrangeValue];
    [[self.gAutoArrangeViewModel getAutoArrangeCmd] execute:nil];
}

- (void)headerRefreshSuccessBlock:(WVRSectionModel*)sectionModel {
    
    [self.gView hidenLoading];
    if (!self.collectionView.mj_footer) {
        @weakify(self);
        self.collectionView.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self footerMore];
        }];
    }
    [self parseInfoToOriginDic:@{@(0):sectionModel}];
    [self.gView stopHeaderRefresh];
}

- (void)footerMore {
    [[self.gAutoArrangeViewModel getAutoArrangeMoreCmd] execute:nil];
}

- (void)footerMoreSuccessBlock:(WVRSectionModel*)sectionModel {
    [self.gView hidenLoading];
    if (self.originDic.count == 0) {
        [self.gView showNetErrorVWithreloadBlock:^{
            [self requestInfo];
        }];
    }
    [self.gView stopFooterMore:NO];
}

- (void)networkFaild {
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    if (self.originDic.count == 0) {
        [self.gView showNetErrorVWithreloadBlock:^{
            [self requestInfo];
        }];
    }else{
        SQToastInKeyWindow(kNoNetAlert);
    }
}


- (void)reloadPlayer
{
    if (self.args) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_RELOAD_PLAYER object:self.mSinglPlayerSection];
    }
}
@end

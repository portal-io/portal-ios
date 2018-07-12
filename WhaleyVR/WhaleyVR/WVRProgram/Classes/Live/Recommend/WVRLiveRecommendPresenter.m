//
//  WVRLivePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecommendPresenter.h"
#import "WVRNullCollectionViewCell.h"
#import "WVRLiveCell.h"
#import "WVRLiveEndCell.h"

#import "WVRSQFindSplitFooter.h"
#import "WVRSQFindUIStyleHeader.h"
#import "SQRefreshHeader.h"
#import "SQCollectionView.h"
#import "WVRGotoNextTool.h"
#import "WVRSectionModel.h"
#import "WVRLiveRecommendBannerCell.h"
#import "WVRLiveRecTitleHeader.h"
#import "WVRLiveRecReviewCell.h"
#import "WVRLiveRecReBannerCell.h"
#import "WVRSQFindSplitCell.h"

#import "WVRSmallPlayerPresenter.h"

#import "WVRLiveRecommendViewModel.h"
#import "WVRHomePageCollectionView.h"

#import "WVRLiveRecommendBannerViewSection.h"
#import "WVRRecommendPlayerHeader.h"

#define MIN_SPACE_ITEM (1.0f)

@interface WVRLiveRecommendPresenter ()

@property (nonatomic, strong) NSMutableDictionary * originDic;

@property (nonatomic, weak) WVRBaseViewSection * mLiveBannerPlayerSection;

@property (nonatomic, strong) WVRLiveRecommendViewModel * gLiveRecommendViewModel;

@end
@implementation WVRLiveRecommendPresenter
@page(([NSString stringWithFormat:@"%d%@",(int)WVRLinkTypeMix,LINKARRANGETYPE_RECOMMENDPAGE]), NSStringFromClass([WVRLiveRecommendPresenter class]))

- (instancetype)initWithParams:(id)params attchView:(id<WVRCollectionViewProtocol>)view {
    
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

-(void)installRAC
{
    @weakify(self);
    [[self.gLiveRecommendViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpSuccessBlock:x];
    }];
    [[self.gLiveRecommendViewModel mFailSignal] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self httpFailBlock:x.errorMsg];
    }];
}

-(WVRLiveRecommendViewModel *)gLiveRecommendViewModel
{
    if (!_gLiveRecommendViewModel) {
        _gLiveRecommendViewModel = [[WVRLiveRecommendViewModel alloc] init];
    }
    return _gLiveRecommendViewModel;
}

- (void)checkBannerVisibleBlock:(CGFloat) y {
    
    if (y < fitToWidth(200.f)) {
//    if ([(UICollectionView*)self.gView contentOffset].y == -fitToWidth(200.f)) {
        //        if ([[WVRSmallPlayerPresenter shareInstance] prepared]) {
        if ([WVRSmallPlayerPresenter shareInstance].isPaused) {
            if ([WVRReachabilityModel sharedInstance].isWifi) {
                [[WVRSmallPlayerPresenter shareInstance] start];
            }
        }
        //        }
        [[WVRSmallPlayerPresenter shareInstance] setShouldPause:NO];
    } else if(y > fitToWidth(290.f)) {
        [[WVRSmallPlayerPresenter shareInstance] setShouldPause:YES];
        if (![WVRSmallPlayerPresenter shareInstance].isPaused) {
            [[WVRSmallPlayerPresenter shareInstance] stop];
        }
    }
    
}

-(void)fetchData
{
    [self requestInfo];
}

-(void)requestInfo
{
    //    kWeakSelf(self);
    [self.gView clear];
    //    [self.mView removeErrorAndNullView:weakself];
    if (self.originDic.count==0) {
        [self.gView showLoadingWithText:nil];
    }
    self.gLiveRecommendViewModel.code = [self.args linkArrangeValue] ;
    [[self.gLiveRecommendViewModel getLiveRecommendCmd] execute:nil];
}

-(void)httpSuccessBlock:(id)args
{
    [self.gView hidenLoading];
    [self.gView stopHeaderRefresh];
    [self parseInfoToOriginDic:args];
}

-(void)httpFailBlock:(NSString*)msg
{
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

- (void)requestInfo:(id)requestParams {
    
    self.args = requestParams;
    [self requestInfo];
}

- (void)requestInfoForFirst:(id)requestParams {
    
    if (self.originDic.count == 0) {
        [self requestInfo:requestParams];
    }
}

- (void) headerRefreshRequestInfo:(id)requestParams {
    
    [self headerRefreshRequest:YES requestParams:requestParams? requestParams:self.args];
}


- (void)headerRefreshRequest:(BOOL)firstRequest requestParams:(id)requestParams {
    
    [self requestInfo];
    
}

- (void)parseInfoToOriginDic:(NSDictionary *)args {
    
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary dictionary];
    }
    [self.originDic removeAllObjects];
    
    NSArray * allKeys = [args allKeys];
    for (NSNumber *key in allKeys) {
        WVRSectionModel * sectionModel = args[key];
        if (sectionModel.sectionType == WVRSectionModelTypeBanner) {
            sectionModel.sectionType = WVRSectionModelTypeLiveRecommendBanner;
        }else if (sectionModel.sectionType== WVRSectionModelTypeHot){
            sectionModel.sectionType = WVRSectionModelTypeLiveRecommendHot;
        }
        else if (sectionModel.sectionType == WVRSectionModelTypeDefault){
            sectionModel.sectionType = WVRSectionModelTypeLiveRecommendDefault;
        }
        WVRBaseViewSection * sectionInfo = [self sectionInfo:sectionModel];
        self.originDic[key] = sectionInfo;
        if (sectionModel.sectionType == WVRSectionModelTypeLiveRecommendBanner) {
            self.mLiveBannerPlayerSection = sectionInfo;
        }
    }
    
    [self.gView setDelegate:self.collectionViewDelegte andDataSource:self.collectionViewDelegte];
    [self.collectionViewDelegte loadData:self.originDic];
    [self.gView reloadData];
}

- (void)reloadPlayer {
    
    if (self.args) {
//        WVRRecommendPlayerHeaderInfo* headerInfo = (WVRRecommendPlayerHeaderInfo*)self.mSinglPlayerSection.headerInfo;
//        if (headerInfo.reloadPlayerBlock) {
//            headerInfo.reloadPlayerBlock();
//        }
        [[WVRSmallPlayerPresenter shareInstance] updateCanPlay:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_LIVE_TAB_RELOAD_PLAYER object:self.mLiveBannerPlayerSection];//需要优化
//        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_RELOAD_PLAYER object:self.mSinglPlayerSection];
    }
}

- (void)dealloc {
    
    DDLogInfo(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

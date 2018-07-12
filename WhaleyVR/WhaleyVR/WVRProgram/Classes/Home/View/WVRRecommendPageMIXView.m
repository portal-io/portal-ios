//
//  WVRRecommendPageView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRecommendPageMIXView.h"
#import "SQCollectionView.h"
#import "SQRefreshHeader.h"
#import "WVRSQBannerReusableHeader.h"
#import "WVRSmallPlayerPresenter.h"
#import "WVRBaseViewSection.h"
#import "WVRViewModelDispatcher.h"
#import "WVRMixRecommendPageViewModel.h"
#import "WVRRecommendPageModel.h"

@interface WVRRecommendPageMIXView ()

//@property (nonatomic) WVRSQFindModel *mRecommendModel;

@property (nonatomic) SQCollectionViewDelegate * mDelegate;
@property (nonatomic) WVRRecommendPageMIXViewInfo * mVInfo;
@property (nonatomic) NSMutableDictionary* originDic;
@property (nonatomic) NSDictionary * modelDic;

@property (nonatomic) WVRSQBannerReusableHeaderInfo * mBannerHeaderInfo;

@property (nonatomic, strong) WVRMixRecommendPageViewModel * gMixRecommendPageViewModel;

@property (nonatomic, weak) WVRCollectionViewSectionInfo * mSinglPlayerSection;

@end


@implementation WVRRecommendPageMIXView

+ (instancetype)createWithInfo:(WVRRecommendPageMIXViewInfo *)vInfo {
    
    WVRRecommendPageMIXView * pageV = [[WVRRecommendPageMIXView alloc] initWithFrame:vInfo.frame collectionViewLayout:[UICollectionViewFlowLayout new] withVInfo:vInfo];
    
    return pageV;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withVInfo:(WVRRecommendPageMIXViewInfo *)vInfo {
    self =  [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        kWeakSelf(self);
        self.mVInfo = vInfo;
        self.backgroundColor = k_Color10;
        SQRefreshHeader * refreshHeader = [SQRefreshHeader headerWithRefreshingBlock:^{
            
            [weakself headerRefreshRequest:NO];
        }];
        self.mj_header = refreshHeader;
        SQCollectionViewDelegate * delegate = [SQCollectionViewDelegate new];
        self.delegate = delegate;
        self.dataSource = delegate;
        self.mDelegate = delegate;
        delegate.scrollDidScrolling = ^(CGFloat y){
            [weakself checkBannerVisibleBlock:y];
        };

//        [self registerNibForView:self];
//        WVRNetErrorView *view = [WVRNetErrorView errorViewForViewReCallBlock:^{
//            [weakself.mErrorView removeFromSuperview];
//            [weakself headerRefreshRequest:YES];
//        } withParentFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        view.y -= kNavBarHeight;
//        self.mErrorView = view;
        [self installRAC];
    }
    return self;
}

- (void)checkBannerVisibleBlock:(CGFloat)y {
    
    if (y < fitToWidth(290.f)) {
//        if ([[WVRSmallPlayerPresenter shareInstance] prepared]) {
            if (![WVRSmallPlayerPresenter shareInstance].isPlaying) {
                if ([WVRReachabilityModel sharedInstance].isWifi) {
                    [[WVRSmallPlayerPresenter shareInstance] start];
                }
            }
//        }
        [[WVRSmallPlayerPresenter shareInstance] setShouldPause:NO];
    } else if(y > fitToWidth(290.f)) {
        [[WVRSmallPlayerPresenter shareInstance] setShouldPause:YES];
        if ([WVRSmallPlayerPresenter shareInstance].isPlaying) {
            [[WVRSmallPlayerPresenter shareInstance] stop];
        }
    }
}

-(WVRMixRecommendPageViewModel *)gMixRecommendPageViewModel
{
    if (!_gMixRecommendPageViewModel) {
        _gMixRecommendPageViewModel = [[WVRMixRecommendPageViewModel alloc] init];
    }
    return _gMixRecommendPageViewModel;
}


-(void)installRAC
{
    @weakify(self);
    [[self.gMixRecommendPageViewModel mCompleteSignal] subscribeNext:^(WVRRecommendPageModel*  _Nullable x) {
        @strongify(self);
        [self successBlock:x.sectionModels pageName:x.name];
    }];
    [[self.gMixRecommendPageViewModel mFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self networkFaild];
    }];
}

- (void)requestInfo {
    
    if (self.originDic.count == 0) {
        [self headerRefreshRequest:YES];
    }
}

- (void)headerRefreshRequest:(BOOL)firstRequest {
    
//    kWeakSelf(self);
    if (self.originDic.count==0&&firstRequest) {
        SQShowProgress;
    }
    self.gMixRecommendPageViewModel.code = self.mVInfo.sectionModel.linkArrangeValue;
    [[self.gMixRecommendPageViewModel getMixRecommendPageCmd] execute:nil];
}

-(void)successBlock:(NSDictionary*)args pageName:(NSString*)pageName
{
    SQHideProgress;
    self.modelDic = args;
    [self parseInfoToOriginDic];
    [self updateCollectionView];
    self.mVInfo.viewController.title = pageName;
}

- (void)networkFaild {
    SQHideProgress;
    [self.mj_header endRefreshing];
    if (self.originDic.count > 0) {      // 已有界面
        SQToastInKeyWindow(kNetError);
    } else {                         // 未有界面
        
    }
}

- (void)parseInfoToOriginDic {
    
    if (!self.originDic) {
        self.originDic = [NSMutableDictionary dictionary];
    }
    [self.originDic removeAllObjects];
    for (NSNumber *key in [self.modelDic allKeys]) {
        WVRSectionModel * sectionModel = self.modelDic[key];
        WVRCollectionViewSectionInfo * sectionInfo = [self sectionInfo:sectionModel];
        if (sectionModel.sectionType == WVRSectionModelTypeSinglePlay) {
            self.mSinglPlayerSection = sectionInfo;
        }
        self.originDic[key] = sectionInfo;
    }
}

- (WVRBaseViewSection*)sectionInfo:(WVRSectionModel*)sectionModel {
    
//    NSLog(@"recommendAreaType:%ld", (long)sectionModel.sectionType);
    WVRBaseViewSection * sectionInfo = nil;
    NSInteger type = sectionModel.sectionType;
    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d",(int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
    [sectionInfo registerNibForCollectionView:self];
//    sectionInfo.viewController = self.mVInfo.viewController;
    return sectionInfo;
}

- (void)updateCollectionView {
    
    [self.mDelegate loadData:self.originDic];
    [self reloadData];
    [self.mj_header endRefreshing];
}

- (void)updateBannerAutoScroll:(BOOL)isAuto {
    
//    [self.mCollectionRouter updateBannerAutoScroll:isAuto];
}

-(void)updatePlay
{
    if (self.mSinglPlayerSection) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_RELOAD_PLAYER object:self.mSinglPlayerSection];
    }
}
@end


@implementation WVRRecommendPageMIXViewInfo

@end

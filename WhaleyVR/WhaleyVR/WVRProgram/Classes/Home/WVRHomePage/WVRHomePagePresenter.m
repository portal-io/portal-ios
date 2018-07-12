//
//  WVRFindPagePresenterImpl.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHomePagePresenter.h"
#import "WVRItemModel.h"
#import "WVRHomePageCollectionView.h"
#import "WVRPageViewProtocol.h"
#import "WVRBaseCollectionView.h"

#import "SQRefreshHeader.h"
#import "WVRNullCollectionViewCell.h"
#import "WVRSmallPlayerPresenter.h"

#import "WVRViewModelDispatcher.h"
#import "WVRBaseSubPagePresenter.h"

@interface WVRHomePagePresenter ()

@property (nonatomic, weak) id<WVRPageViewProtocol> mPageView;
@property (nonatomic, strong) NSMutableArray * mSubPagePresenters;
@property (nonatomic, strong) NSMutableArray * mSubPageViews;

@property (nonatomic, strong) NSMutableArray * validItemModels;

@property (nonatomic, assign) NSInteger mCurPageIndex;

@property (nonatomic, assign) CGFloat mCurOffsetX;

@end


@implementation WVRHomePagePresenter

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super init];
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRPageViewProtocol)]) {
            self.args = params;
            self.mPageView = (id <WVRPageViewProtocol>)view;
        } else {
            NSException *exception = [[NSException alloc] initWithName:[self description] reason:@"view not conformsTo WVRPageViewProtocol" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (void)fetchData
{
    [self requestInfo];
}

- (void)requestInfo
{
    if (!self.mSubPagePresenters) {
        self.mSubPagePresenters = [NSMutableArray new];
    }
    if (!self.mSubPageViews) {
        self.mSubPageViews = [NSMutableArray new];
    }
    if (!self.validItemModels) {
        self.validItemModels = [NSMutableArray new];
    }
    for (UIView * view in self.mSubPageViews) {
        [view removeFromSuperview];
    }
    [self.mSubPageViews removeAllObjects];
    [self.mSubPagePresenters removeAllObjects];
    [self.validItemModels removeAllObjects];
    [self installPresenters];
    //    [[self.mSubPagePresenters firstObject] requestInfo:[requestParams firstObject]];
    [self.mPageView reloadData];
    [self pageViewScrollToZero];
}

- (void)requestInfo:(id)requestParams
{
    self.args = requestParams;
    [self requestInfo];
}

- (WVRBaseSubPagePresenter*)getSubPagePresenterWithModel:(WVRItemModel*)param andView:(WVRHomePageCollectionView*)collectionView
{
     WVRBaseSubPagePresenter* presenter = (id<WVRBaseSubPagePresenterProtocol>)[WVRViewModelDispatcher dispatchPage:[NSString stringWithFormat:@"%d%@",(int)param.linkType_,param.recommendPageType] args:param attchView:collectionView];
    return presenter;
}

- (void)installPresenters {
    
    for (WVRItemModel *param in self.args) {
        WVRHomePageCollectionView *collectionView = [self createCollectionView];
        WVRBaseSubPagePresenter *presenter = [self getSubPagePresenterWithModel:param andView:collectionView];
        
        if (!presenter) {
            continue;
        }
        
        [self.mSubPagePresenters addObject:presenter];
        presenter.index = self.mSubPagePresenters.count-1;
        
        SQRefreshHeader * header = [SQRefreshHeader headerWithRefreshingBlock:^{
            [presenter headerRefreshRequestInfo:nil];
        }];
        collectionView.mj_header = header;
        presenter.collectionView = collectionView;
        [self.mSubPageViews addObject:collectionView];
        [self.validItemModels addObject:param];
    }
}

- (WVRHomePageCollectionView *)createCollectionView {
    
    WVRHomePageCollectionView * collectionView = [[WVRHomePageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    
    return collectionView;
}

#pragma mark - WVRPageViewDelegate

- (void)pageViewScrollToZero {
    
    self.mCurPageIndex = 0;
    [self.mPageView scrollToPageNamber:0];
    [self.mPageView scrollingToPageNamber:0];
    [self updatePageView:0];
}

- (void)updatePageView:(NSInteger)index {
    
    [self updatePlayerStatus:index];
    self.mCurPageIndex = index;
    if (index < self.mSubPagePresenters.count) {
        WVRBaseSubPagePresenter * presenter = self.mSubPagePresenters[index];
        [presenter requestInfoForFirst:self.validItemModels[index]];
    }
}

- (void)updatePlayerStatus:(NSInteger)index
{
    [[WVRSmallPlayerPresenter shareInstance] destroy];
    if (index<self.mSubPagePresenters.count) {
        WVRBaseSubPagePresenter * curPresenter = self.mSubPagePresenters[index];
        [curPresenter reloadPlayer];
    }
}

#pragma mark - 外部方法

- (void)updatePlayerStatusForCurIndex
{
    [self updatePlayerStatus:self.mCurPageIndex];
}

/// just for BI
- (NSString *)getRealNameForIndex:(NSInteger)index {
    
    WVRBaseSubPagePresenter * presenter = self.mSubPagePresenters[index];
    SEL sel = NSSelectorFromString(@"getRealName");
    
    NSString *realName = nil;
    if ([presenter respondsToSelector:sel]) {
        realName = [presenter performSelector:sel];
    }
    
    return realName;
}

#pragma mark - WVRPageViewDataSource

- (NSInteger)numberOfPage:(WVRPageView *)pageView
{
    return self.validItemModels.count;
}

- (UIView *)subView:(WVRPageView *)pageView forIndex:(NSInteger)index
{
    WVRBaseCollectionView * subView = self.mSubPageViews[index];
//    WVRBaseSubPagePresenter * presenter = self.mSubPagePresenters[index];
//    [presenter fetchData];
    return subView;
}

@end

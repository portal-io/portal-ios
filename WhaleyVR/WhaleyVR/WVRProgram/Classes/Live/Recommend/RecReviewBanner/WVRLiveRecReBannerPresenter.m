//
//  WVRLiveRecSubCPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecReBannerPresenter.h"
#import "WVRLiveRecReBannerItemCell.h"
#import "WVRItemModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveRecReBannerItemFooter.h"

@interface WVRLiveRecReBannerPresenter ()


@end

@implementation WVRLiveRecReBannerPresenter

+ (instancetype)createPresenter:(id)createArgs {
    
    WVRLiveRecReBannerPresenter * presenter = [[WVRLiveRecReBannerPresenter alloc] init];
    
    presenter.cellNibNames = @[NSStringFromClass([WVRLiveRecReBannerItemCell class])];
    presenter.footerNibNames = @[NSStringFromClass([WVRLiveRecReBannerItemFooter class])];
    [presenter loadViews];
    return presenter;
}

- (void)loadViews {
    
    [self initCollectionView];
}

- (UIView *)getView {
    
    return self.mCollectionV;
}

- (void)reloadData {
    
    [self requestInfo];
}

- (void)initCollectionView {
    
    [super initCollectionView];
    [(UICollectionViewFlowLayout*)self.mCollectionV.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.mCollectionV.showsHorizontalScrollIndicator = NO;
    self.mCollectionV.backgroundColor = [UIColor whiteColor];
}

- (void)requestInfo {
    
    [super requestInfo];
    kWeakSelf(self);
    self.collectionVOriginDic[@(0)] = [self getSectionInfo];
    self.collectionDelegate.scrollBottomBlock = ^(BOOL isBottom){
        [weakself cellInfoNextBlock:weakself.itemModel];
    };
    [self updateCollectionView];
}

- (SQCollectionViewSectionInfo *)getSectionInfo {
    
    SQCollectionViewSectionInfo* sectionInfo = [SQCollectionViewSectionInfo new];
    sectionInfo.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    sectionInfo.minLineSpace = fitToWidth(4.f);
    kWeakSelf(self);
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* cur in [[self itemModel] arrangeElements]) {
        if([cur.programType isEqualToString:PROGRAMTYPE_ARRANGE])
            continue;
        WVRLiveRecReBannerItemCellInfo * cellInfo = [WVRLiveRecReBannerItemCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRLiveRecReBannerItemCell class]);
        cellInfo.cellSize = CGSizeMake(fitToWidth(225.f), fitToWidth(180.0f));
        cellInfo.itemModel = cur;
        cellInfo.gotoNextBlock = ^(id args){
            [weakself cellInfoNextBlock:cur];
        };
        [cellInfos addObject:cellInfo];
    }
    
    sectionInfo.cellDataArray = cellInfos;
    
    sectionInfo.footerInfo = [self getMoreFooterInfo];
    return sectionInfo;
}

- (SQCollectionViewFooterInfo*)getMoreFooterInfo {
    
    kWeakSelf(self);
    SQCollectionViewFooterInfo * moreCellInfo = [SQCollectionViewFooterInfo new];
    moreCellInfo.cellNibName = NSStringFromClass([WVRLiveRecReBannerItemFooter class]);
    moreCellInfo.cellSize = CGSizeMake(fitToWidth(128.f), fitToWidth(180.f));
    moreCellInfo.gotoNextBlock = ^(id args){
        [weakself cellInfoNextBlock:self.itemModel];
    };
    return moreCellInfo;
}

- (void)cellInfoNextBlock:(WVRItemModel *)model {
    
    [WVRGotoNextTool gotoNextVC:model nav:[UIViewController getCurrentVC].navigationController];
}

- (void)updateCollectionView {
    
    [self.collectionDelegate loadData:self.collectionVOriginDic];
    [self.mCollectionV reloadData];
}

@end

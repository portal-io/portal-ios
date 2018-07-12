//
//  WVRBannerViewRouter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecommendHotViewSection.h"
#import "WVRSQBannerReusableHeader.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveRecommendBannerCell.h"
#import "WVRLiveRecTitleHeader.h"
#import "WVRLiveCell.h"

#define MIN_SPACE_ITEM (1.0f)

@implementation WVRLiveRecommendHotViewSection

#pragma mark - Banner section

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeLiveRecommendHot]), NSStringFromClass([WVRLiveRecommendHotViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRLiveRecommendBannerCell class], [WVRLiveCell class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    NSArray* allHeaderClass = @[[WVRLiveRecTitleHeader class]];
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel{
    
    if (sectionModel.itemModels.count==0) {
        return self;
    }
    WVRBaseViewSection * sectionInfo = self;
    WVRLiveRecTitleHeaderInfo * headerInfo = [WVRLiveRecTitleHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRLiveRecTitleHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(60.f));
    headerInfo.title = sectionModel.name;//@"火热直播";
    NSMutableArray * cellInfos = [NSMutableArray array];
    
    for (WVRLiveItemModel* itemModel in sectionModel.itemModels) {
        if ([itemModel.type isEqualToString:@"1"]) {
            continue;
        }
        [cellInfos addObject:[self getCellInfo:itemModel]];
    }
    if (cellInfos.count==0) {
        return self;
    }
    sectionInfo.headerInfo = headerInfo;
    sectionInfo.minItemSpace = MIN_SPACE_ITEM;
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (WVRLiveCellInfo*)getCellInfo:(WVRLiveItemModel*)itemModel {
    
    WVRLiveCellInfo * cellInfo = [WVRLiveCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRLiveCell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(266.f));
    cellInfo.itemModel = itemModel;
    cellInfo.gotoNextBlock = ^(id args){
        [self gotoNextItemVC:itemModel];
    };
    
    return cellInfo;
}

@end

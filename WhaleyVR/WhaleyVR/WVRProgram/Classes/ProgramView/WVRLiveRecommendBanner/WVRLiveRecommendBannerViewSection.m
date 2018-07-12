//
//  WVRBannerViewRouter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecommendBannerViewSection.h"
#import "WVRSQBannerReusableHeader.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveRecommendBannerCell.h"

@implementation WVRLiveRecommendBannerViewSection

#pragma mark - Banner section

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeLiveRecommendBanner]), NSStringFromClass([WVRLiveRecommendBannerViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRLiveRecommendBannerCell class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    NSArray* allHeaderClass = @[[WVRSQBannerReusableHeader class]];
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel
{
    WVRBaseViewSection * sectionInfo = self;
    WVRLiveRecommendBannerCellInfo * cellInfo = [WVRLiveRecommendBannerCellInfo new];
    
    cellInfo.cellNibName = NSStringFromClass([WVRLiveRecommendBannerCell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(250.f));
    cellInfo.itemModels = sectionModel.itemModels;
    NSMutableArray * array = [NSMutableArray new];
    
    [array addObject:cellInfo];
    
    sectionInfo.cellDataArray = array;
    
    sectionInfo.footerInfo = [self getSplitFooterInfo];
    return sectionInfo;
}

@end

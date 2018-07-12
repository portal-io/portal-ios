//
//  WVRBrandViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBrandViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRSQMoreReusableHeader.h"
#import "WVRSQBrandCell.h"

@implementation WVRBrandViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeBrand]), NSStringFromClass([WVRBrandViewSection class]))

-(instancetype)init
{
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView*)collectionView
{
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRSQBrandCell class]];
    NSArray* allHeaderClass = @[[WVRSQMoreReusableHeader class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

- (WVRBaseViewSection*)getSectionInfo:(WVRSectionModel*)sectionModel
{
    kWeakSelf(self)
    WVRBaseViewSection * sectionInfo = self;//[WVRCollectionViewSectionInfo new];
    
    WVRSQMoreReusableHeaderInfo * headerInfo = [WVRSQMoreReusableHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRSQMoreReusableHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_FIND_HEADER));
    headerInfo.sectionModel = sectionModel;
    headerInfo.gotoNextBlock = ^(WVRSQMoreReusableHeaderInfo * args){
        [weakself gotoNextSectionVC:sectionModel];
    };
    sectionInfo.headerInfo = headerInfo;
    sectionInfo.originDataArray = [weakself getBrandCellInfos:sectionModel];
    if (sectionModel.itemModels.count>=COUNT_ITEMS*2) {
        sectionInfo.footerInfo = [weakself getFooterInfo:sectionModel.footerModel sectionInfo:sectionInfo];
        sectionInfo.cellDataArray = [[sectionInfo.originDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, COUNT_ITEMS)]] mutableCopy];
    }else{
        sectionInfo.cellDataArray = [sectionInfo.originDataArray mutableCopy];
        sectionInfo.footerInfo = [weakself getGotoChannelFooterInfo:sectionModel.footerModel];
    }
    return sectionInfo;
}


- (NSMutableArray*)getBrandCellInfos:(WVRSectionModel*)sectionModel
{
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in sectionModel.itemModels) {
        
        
        [cellInfos addObject:[self getBrandCellInfo:model]];
    }
    
    return cellInfos;
}

- (WVRSQBrandCellInfo*)getBrandCellInfo:(WVRItemModel* )model
{
    kWeakSelf(self);
    WVRSQBrandCellInfo * brandCellInfo = [WVRSQBrandCellInfo new];
    brandCellInfo.cellNibName = NSStringFromClass([WVRSQBrandCell class]);
    brandCellInfo.cellSize = CGSizeMake(WIDTH_DEFAULT_CELL, fitToWidth(HEIGHT_DEFAULT_CELL));
    brandCellInfo.gotoNextBlock = ^(id args){
        [weakself gotoNextItemVC:model];
    };
    brandCellInfo.name = model.name;
    brandCellInfo.intrDesc = model.intrDesc;
    brandCellInfo.subTitle = model.subTitle;
    brandCellInfo.thubImage = model.thubImageUrl;
    brandCellInfo.unitConut = model.unitConut;
    brandCellInfo.logoImageUrl = model.logoImageUrl;
    return brandCellInfo;
}


@end

//
//  WVRArrangeViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRArrangeViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVR3DArrangeCell.h"
#import "WVRSQClassifyCell.h"

@implementation WVRArrangeViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeArrange]), NSStringFromClass([WVRArrangeViewSection class]))

- (instancetype)init
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
    NSArray* allCellClass = @[[WVR3DArrangeCell class], [WVRSQClassifyCell class]];
    NSArray* allHeaderClass = @[];
    
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
    WVRBaseViewSection * sectionInfo = self;//[WVRCollectionViewSectionInfo new];
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    //    if (self.mVInfo.sectionModel.videoType_ != WVRModelVideoTypeVR) {
    for (WVRItemModel* model in sectionModel.itemModels) {
        if (model.videoType_ != WVRModelVideoTypeVR) {
            [cellInfos addObject:[self get3DArrangeCellInfo:model]];
        }else{
            [cellInfos addObject:[self getVRArrangeCellInfo:model]];
        }
    }
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

- (WVR3DArrangeCellInfo*)get3DArrangeCellInfo:(WVRItemModel* )model
{
    kWeakSelf(self);
    WVR3DArrangeCellInfo * cellInfo = [WVR3DArrangeCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVR3DArrangeCell class]);
    cellInfo.cellSize = CGSizeMake(WIDTH_3DANDTV_CELL, fitToWidth(HEIGHT_3DARRANGE_CELL));
    cellInfo.gotoNextBlock = ^(id args){
        [weakself gotoDetail:model];
    };
    cellInfo.videoModel = [WVRVideoModel new];
    cellInfo.videoModel.name = model.name;
    cellInfo.videoModel.itemId = model.code;
    cellInfo.videoModel.thubImage = model.thubImageUrl;
    cellInfo.videoModel.subTitle = model.subTitle;
    cellInfo.videoModel.intrDesc = model.intrDesc;
    
    return cellInfo;
}

- (WVRSQClassifyCellInfo *)getVRArrangeCellInfo:(WVRItemModel* )model
{
    kWeakSelf(self);
    WVRSQClassifyCellInfo * clafCellInfo = [WVRSQClassifyCellInfo new];
    clafCellInfo.cellNibName = NSStringFromClass([WVRSQClassifyCell class]);
    
    clafCellInfo.cellSize = CGSizeMake(WIDTH_DEFAULT_CELL, fitToWidth(HEIGHT_DEFAULT_CELL));
    
    clafCellInfo.gotoNextBlock = ^(id args) {
        [weakself gotoDetail:model];
    };
    clafCellInfo.args = model;
//    clafCellInfo.videoModel = [WVRVideoModel new];
//    clafCellInfo.videoModel.name = model.name;
//    clafCellInfo.videoModel.itemId = model.code;
//    clafCellInfo.videoModel.thubImage = model.thubImageUrl;
//    clafCellInfo.videoModel.subTitle = model.subTitle;
//    clafCellInfo.videoModel.intrDesc = model.intrDesc;
    return clafCellInfo;
}

@end

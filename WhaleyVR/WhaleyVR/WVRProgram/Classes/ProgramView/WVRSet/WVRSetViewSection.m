//
//  WVRAllChannelViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSetViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRLiveReviewCell.h"

@implementation WVRSetViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeSet]), NSStringFromClass([WVRSetViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView*)collectionView
{
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRLiveReviewCell class]];
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

- (SQCollectionViewSectionInfo *)getSectionInfo:(WVRSectionModel *)sectionModel
 {
     
    self.cellDataArray = [self getCellInfos:sectionModel.itemModels];
    return self;
}

-(NSArray*)getCellInfos:(NSArray*)itemModels
{
    kWeakSelf(self);
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRSectionModel* model in itemModels) {
        WVRLiveReviewCellInfo * cellInfo = [WVRLiveReviewCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRLiveReviewCell class]);
        cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(214.0f));
        cellInfo.itemModel = model;
        cellInfo.gotoNextBlock = ^(id args){
            [weakself gotoNextItemVC:model];
        };
        [cellInfos addObject:cellInfo];
    }

    return cellInfos;
}


-(void)moreItems:(id)itemModels
{
    NSArray * moreCellInfos = [self getCellInfos:itemModels];
    NSArray * preCellInfos = self.cellDataArray;
    self.cellDataArray = [preCellInfos arrayByAddingObjectsFromArray:moreCellInfos];
}

@end

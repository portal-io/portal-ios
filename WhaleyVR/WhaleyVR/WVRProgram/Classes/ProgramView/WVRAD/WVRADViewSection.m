//
//  WVRADViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRADViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSQADCell.h"
#import "WVRSectionModel.h"
#import "WVRSQFindSplitCell.h"

@implementation WVRADViewSection

@section(@"3", NSStringFromClass([WVRADViewSection class]))

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
    NSArray* allCellClass = @[[WVRSQADCell class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
}

- (WVRBaseViewSection*)getSectionInfo:(WVRSectionModel *)sectionModel
{
    kWeakSelf(self);
    WVRBaseViewSection * sectionInfo = self;//[WVRCollectionViewSectionInfo new];
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* itemModel in sectionModel.itemModels) {
        WVRSQADCellInfo * adCellInfo = [WVRSQADCellInfo new];
        adCellInfo.cellNibName = NSStringFromClass([WVRSQADCell class]);
        adCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_AD_CELL));
        adCellInfo.thubImageUrl = itemModel.thubImageUrl;
        adCellInfo.gotoNextBlock = ^(id args){
            [weakself gotoNextItemVC:itemModel];
        };
        [cellInfos addObject:adCellInfo];
        WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
        splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
        splitCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SPLIT_CELL));
        [cellInfos addObject:splitCellInfo];
    }
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}
@end

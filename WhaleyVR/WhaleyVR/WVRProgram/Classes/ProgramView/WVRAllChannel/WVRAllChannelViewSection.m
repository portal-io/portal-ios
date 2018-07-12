//
//  WVRAllChannelViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRAllChannelCell.h"

@implementation WVRAllChannelViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeAllChannel]), NSStringFromClass([WVRAllChannelViewSection class]))

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
    NSArray* allCellClass = @[[WVRAllChannelCell class]];
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

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel
{
    WVRBaseViewSection * sectionInfo = self; // [WVRCollectionViewSectionInfo new];
    sectionInfo.edgeInsets = UIEdgeInsetsMake(fitToWidth(10.f), fitToWidth(25.f/2), 0, fitToWidth(25.f/2));
    NSMutableArray * cellInfos = [NSMutableArray new];
    for (WVRItemModel* itemModel in sectionModel.itemModels) {
        WVRAllChannelCellInfo * cellInfo = [WVRAllChannelCellInfo new];
        cellInfo.cellNibName = NSStringFromClass([WVRAllChannelCell class]);
        cellInfo.cellSize = CGSizeMake((SCREEN_WIDTH-fitToWidth(25.f))/4, fitToWidth(92.f));
        cellInfo.itemModel = itemModel;
        kWeakSelf(self);
        cellInfo.gotoNextBlock = ^(WVRAllChannelCellInfo* args){
            [weakself gotoNextItemVC:args.itemModel];
        };
        [cellInfos addObject:cellInfo];
    }
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

@end

//
//  WVRHorizontal_HotViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHorizontal_HotViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSQTagHorCell.h"
#import "WVRTagHotCell.h"
#import "WVRSectionModel.h"
#import "WVRSQTagMoreCell.h"
#import "WVRSQFindSplitCell.h"


@implementation WVRHorizontal_HotViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeHot]), NSStringFromClass([WVRHorizontal_HotViewSection class]))

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView*)collectionView
{
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRSQTagHorCell class]];
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
    WVRSQTagHorCellInfo * tagCellInfo = [WVRSQTagHorCellInfo new];
    tagCellInfo.cellNibName = NSStringFromClass([WVRSQTagHorCell class]);
    tagCellInfo.cellSize = CGSizeMake(MIN(SCREEN_WIDTH,SCREEN_HEIGHT), fitToWidth(95.f));
    tagCellInfo.originDic = [self getSubTagCollectionDic:sectionModel];
    tagCellInfo.cellNibNames = [self getSubTagCollectionCellNibNames];
    
    [cellInfos addObject:tagCellInfo];
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

- (NSDictionary*)getSubTagCollectionDic:(WVRSectionModel*)sectionModel
{
    NSMutableDictionary * originDic = [NSMutableDictionary dictionary];
    originDic[@(0)] = [self getSubTagSectionInfo:sectionModel];
    return originDic;
}

- (NSArray*)getSubTagCollectionCellNibNames
{
    return @[NSStringFromClass([WVRTagHotCell class]),NSStringFromClass([WVRSQTagMoreCell class])];
}


- (WVRCollectionViewSectionInfo*)getSubTagSectionInfo:(WVRSectionModel*)sectionModel
{
    
    WVRCollectionViewSectionInfo * sectionInfo = [WVRCollectionViewSectionInfo new];
    sectionInfo.edgeInsets = UIEdgeInsetsMake(fitToWidth(0), fitToWidth(MARGIN_LEFT_TAG_SECTION), fitToWidth(0), fitToWidth(MARGIN_LEFT_TAG_SECTION));
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in [sectionModel.itemModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(5, sectionModel.itemModels.count))]]) {
        
        [cellInfos addObject:[self getTagCellInfo:model]];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (WVRTagHotCellInfo*)getTagCellInfo:(WVRItemModel* )model
{
    kWeakSelf(self);
    WVRTagHotCellInfo * tagCellInfo = [WVRTagHotCellInfo new];
    tagCellInfo.cellNibName = NSStringFromClass([WVRTagHotCell class]);
    tagCellInfo.cellSize = CGSizeMake(WIDTH_TAG_CELL, fitToWidth(85.f));
    tagCellInfo.tagModel = [WVRTagModel new];
    tagCellInfo.tagModel.code = model.code;
    tagCellInfo.tagModel.name = model.name;
    tagCellInfo.tagModel.thubUrl = model.thubImageUrl;
    tagCellInfo.tagModel.linkArrangeValue = model.linkArrangeValue;
    tagCellInfo.tagModel.linkArrangeType = model.linkArrangeType;
    tagCellInfo.gotoNextBlock = ^(WVRTagHotCellInfo* args){
        [weakself gotoNextItemVC:model];
    };
    return tagCellInfo;
}

//- (void)tagCellNextBlock:(WVRItemModel *)model
//{
//    [self gotoNextItemVC:model];
//}

- (WVRSQFindSplitCellInfo *)getTagSplitCellInfo
{
    WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
    splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
    splitCellInfo.cellSize = CGSizeMake((MIN(SCREEN_WIDTH,SCREEN_HEIGHT)-WIDTH_TAG_CELL*4.0)/2.0,fitToWidth(HEIGHT_TAG_CELL));
    splitCellInfo.bgColor = [UIColor whiteColor];
    return splitCellInfo;
}

- (WVRSQTagMoreCellInfo *)lastMoreCellInfo:(WVRItemModel*)model
{
    kWeakSelf(self);
    WVRSQTagMoreCellInfo * tagMoreCellInfo = [WVRSQTagMoreCellInfo new];
    tagMoreCellInfo.cellNibName = NSStringFromClass([WVRSQTagMoreCell class]);
    tagMoreCellInfo.cellSize = CGSizeMake(WIDTH_TAG_CELL, fitToWidth(HEIGHT_TAG_CELL));
    tagMoreCellInfo.tagModel = [WVRTagModel new];
    tagMoreCellInfo.tagModel.code = model.code;
    tagMoreCellInfo.tagModel.name = model.name;
    tagMoreCellInfo.tagModel.linkArrangeValue = model.linkArrangeValue;
    tagMoreCellInfo.tagModel.linkArrangeType = model.linkArrangeType;
    tagMoreCellInfo.gotoNextBlock = ^(WVRSQTagMoreCellInfo* args){
        [weakself gotoNextItemVC:model];
    };
    return tagMoreCellInfo;
}
@end

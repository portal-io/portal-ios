//
//  WVRHorizontal_LabelViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHorizontal_LabelViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRSQTagHorCell.h"
#import "WVRLabelCell.h"
#import "WVRSQTagMoreCell.h"
#import "WVRSQHorCell.h"
#import "WVRSQHorMoreCell.h"
#import "WVRTagHotCell.h"

@implementation WVRHorizontal_LabelViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeTag]), NSStringFromClass([WVRHorizontal_LabelViewSection class]))


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
    tagCellInfo.cellSize = CGSizeMake(MIN(SCREEN_WIDTH,SCREEN_HEIGHT), fitToWidth(65.f+10.f));
    tagCellInfo.originDic = [self getSubLabelCollectionDic:sectionModel];
    tagCellInfo.cellNibNames = [self getSubLabelCollectionCellNibNames];
    [cellInfos addObject:tagCellInfo];
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

- (NSArray*)getSubLabelCollectionCellNibNames
{
    return @[NSStringFromClass([WVRTagHotCell class]),NSStringFromClass([WVRSQTagMoreCell class]), NSStringFromClass([WVRLabelCell class])];
}

- (NSDictionary*)getSubLabelCollectionDic:(WVRSectionModel*)sectionModel
{
    NSMutableDictionary * originDic = [NSMutableDictionary dictionary];
    originDic[@(0)] = [self getSubLabelSectionInfo:sectionModel];
    return originDic;
}

- (SQCollectionViewSectionInfo*)getSubLabelSectionInfo:(WVRSectionModel*)sectionModel
{
    
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    sectionInfo.edgeInsets = UIEdgeInsetsMake(fitToWidth(0), fitToWidth(MARGIN_LEFT_TAG_SECTION*2), fitToWidth(0), fitToWidth(MARGIN_LEFT_TAG_SECTION*2));
    sectionInfo.minItemSpace = fitToWidth(10.f);
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in sectionModel.itemModels) {
        
        [cellInfos addObject:[self getLabelCellInfo:model totalNum:sectionModel.itemModels.count] ];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (WVRLabelCellInfo*)getLabelCellInfo:(WVRItemModel* )model totalNum:(NSInteger)totalNum
{
    kWeakSelf(self);
    WVRLabelCellInfo * tagCellInfo = [WVRLabelCellInfo new];
    tagCellInfo.cellNibName = NSStringFromClass([WVRLabelCell class]);
//    CGSize sizeL = [WVRComputeTool sizeOfString:model.name Size:CGSizeMake(2000.0, fitToWidth(30.f)) Font:kFontFitForSize(15.f)];
    NSInteger count = MIN(4, totalNum);
    tagCellInfo.cellSize = CGSizeMake((MIN(SCREEN_WIDTH,SCREEN_HEIGHT) - fitToWidth(20*2)-fitToWidth(10*(count-1)))/count, fitToWidth(HEIGHT_TAG_CELL));
//    NSLog(@"width:%f", tagCellInfo.cellSize.width);
    tagCellInfo.itemModel = model;
    tagCellInfo.gotoNextBlock = ^(WVRLabelCellInfo* args){
        [weakself gotoNextItemVC:model];
    };
    return tagCellInfo;
}

- (NSDictionary*)getSubCollectionDic:(WVRSectionModel*)sectionModel
{
    NSMutableDictionary * originDic = [NSMutableDictionary dictionary];
    originDic[@(0)] = [self subHorizontalCellSectionInfo:sectionModel];
    return originDic;
}

- (NSArray*)getSubCollectionCellNibNames
{
    return @[NSStringFromClass([WVRSQHorCell class]),NSStringFromClass([WVRSQHorMoreCell class])];
}

- (SQCollectionViewSectionInfo*)subHorizontalCellSectionInfo:(WVRSectionModel*)sectionModel
{
    kWeakSelf(self);
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in sectionModel.itemModels) {
        WVRSQHorCellInfo * subCellInfo = [WVRSQHorCellInfo new];
        subCellInfo.cellNibName = NSStringFromClass([WVRSQHorCell class]);
        subCellInfo.cellSize = CGSizeMake(fitToWidth(HEIGHT_HORCELL_SUBCELL), fitToWidth(HEIGHT_HORCELL_SUBCELL));
        subCellInfo.thubImage = model.thubImageUrl;
        subCellInfo.name = model.name;
        subCellInfo.gotoNextBlock = ^(id args){
            [weakself gotoNextItemVC:model];
        };
        [cellInfos addObject:subCellInfo];
    }
    WVRSQHorMoreCellInfo * subCellInfo = [WVRSQHorMoreCellInfo new];
    subCellInfo.cellNibName = NSStringFromClass([WVRSQHorMoreCell class]);
    subCellInfo.cellSize = CGSizeMake(fitToWidth(HEIGHT_HORCELL_SUBCELL/2), fitToWidth(HEIGHT_HORCELL_SUBCELL));
    subCellInfo.name = sectionModel.footerModel.name;
    subCellInfo.gotoNextBlock = ^(id args){
        [weakself gotoNextSectionVC:sectionModel.footerModel];
    };
    [cellInfos addObject:subCellInfo];
    sectionInfo.cellDataArray = cellInfos;
    
    return sectionInfo;
}

@end

//
//  WVRDefaultCollectionViewRouting.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRDefaultViewSection.h"
#import "WVRSQClassifyCell.h"
#import "WVRSectionModel.h"
#import "WVRSQMoreReusableHeader.h"
#import "WVRBaseCollectionView.h"
#import "WVRCollectionViewSectionInfo.h"

#import "WVRGotoNextTool.h"

@interface WVRDefaultViewSection ()

@end


@implementation WVRDefaultViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeDefault]),NSStringFromClass([WVRDefaultViewSection class]))
//+ (void)load
//{
//    [WVRRouterDispatcher registerPage:@"1" className:NSStringFromClass([WVRDefaultViewSection class])];
//}

- (instancetype)init {
    
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView*)collectionView {
    
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRSQClassifyCell class]];
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

- (BOOL)prepare {
    
    return YES;
}

#pragma mark - Classify

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel {
    WVRBaseViewSection * sectionInfo = self;
    if (sectionModel.itemModels.count==0) {
        return sectionInfo;
    }
    WVRSQMoreReusableHeaderInfo * headerInfo = [WVRSQMoreReusableHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRSQMoreReusableHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_FIND_HEADER));
    headerInfo.sectionModel = sectionModel;
    kWeakSelf(self);
    headerInfo.gotoNextBlock = ^(WVRSQMoreReusableHeaderInfo * args) {
        [weakself gotoDetail:sectionModel];
    };
    sectionInfo.headerInfo = headerInfo;
    sectionInfo.originDataArray = [self getClassifyCellInfos:sectionModel sectionInfo:sectionInfo];
    if (sectionModel.itemModels.count >= COUNT_ITEMS * 2) {
        sectionInfo.footerInfo = [self getFooterInfo:sectionModel.footerModel sectionInfo:sectionInfo];
        sectionInfo.cellDataArray = [[sectionInfo.originDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, COUNT_ITEMS)]] mutableCopy];
    } else {
        if (sectionModel.itemModels.count > COUNT_ITEMS) {
            sectionInfo.cellDataArray = [[sectionInfo.originDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, COUNT_ITEMS)]] mutableCopy];
        } else {
            sectionInfo.cellDataArray = [sectionInfo.originDataArray mutableCopy];
        }
        sectionInfo.footerInfo = [self getGotoChannelFooterInfo:sectionModel.footerModel];
    }
    
    return sectionInfo;
}

- (NSMutableArray *)getClassifyCellInfos:(WVRSectionModel *)sectionModel sectionInfo:(WVRCollectionViewSectionInfo*)sectionInfo {
    
//    kWeakSelf(sectionInfo)
    NSMutableArray * cellInfos = [NSMutableArray array];
    kWeakSelf(self);
    for (WVRItemModel *model in sectionModel.itemModels) {
        WVRSQClassifyCellInfo * clafCellInfo = [[WVRSQClassifyCellInfo alloc] init];
        clafCellInfo.cellNibName = NSStringFromClass([WVRSQClassifyCell class]);
        clafCellInfo.cellSize = CGSizeMake(WIDTH_DEFAULT_CELL, fitToWidth(HEIGHT_DEFAULT_CELL));
        clafCellInfo.gotoNextBlock = ^(id args) {
                [weakself gotoDetail:model];
//            [weakself.delegate gotoNextItemVC:model];
//            [WVRGotoNextTool gotoNextVC:model nav:weaksectionInfo.viewController.navigationController];
        };
        clafCellInfo.args = model;
//        clafCellInfo.videoModel = [WVRVideoModel new];
//        clafCellInfo.videoModel.itemId = model.code;
//        clafCellInfo.videoModel.name = model.name;
//        clafCellInfo.videoModel.intrDesc = model.intrDesc;
//        clafCellInfo.videoModel.subTitle = model.subTitle;
//        clafCellInfo.videoModel.thubImage = model.thubImageUrl;
        
        [cellInfos addObject:clafCellInfo];
    }
    
    return cellInfos;
}

@end

//
//  WVRBannerViewRouter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecommendDefaultViewSection.h"
#import "WVRSQBannerReusableHeader.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveRecommendBannerCell.h"
#import "WVRLiveRecTitleHeader.h"
#import "WVRLiveRecReviewCell.h"
#import "WVRLiveRecReBannerCell.h"
#import "WVRSQFindSplitCell.h"

#define MIN_SPACE_ITEM (1.0f)

@implementation WVRLiveRecommendDefaultViewSection

#pragma mark - Banner section

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeLiveRecommendDefault]), NSStringFromClass([WVRLiveRecommendDefaultViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRLiveRecommendBannerCell class],[WVRLiveRecReviewCell class], [WVRSQFindSplitCell class], [WVRLiveRecReBannerCell class]];
    
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

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel {
    
    if (sectionModel.itemModels.count==0) {
        return self;
    }
    WVRBaseViewSection * sectionInfo = self;
    WVRLiveRecTitleHeaderInfo * headerInfo = [WVRLiveRecTitleHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRLiveRecTitleHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(60.f));
    headerInfo.title = sectionModel.name;//@"直播回顾";

    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in sectionModel.itemModels) {
        if ([model.type isEqualToString:@"1"]) {
            continue;
        }
        [cellInfos addObject:[self getCellInfo:model]];
        if ([model.arrangeShowFlag boolValue]&&[self haveSubProgram:model.arrangeElements]) {
            WVRLiveRecReBannerCellInfo * bCellInfo = [WVRLiveRecReBannerCellInfo new];
            
            bCellInfo.cellNibName = NSStringFromClass([WVRLiveRecReBannerCell class]);
            bCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(180.f));
            bCellInfo.itemModel = model;
            [cellInfos addObject:bCellInfo];
        }
        if (model != sectionModel.itemModels.lastObject) {
            [cellInfos addObject:[self getSplitCellInfo]];
        }
    }
    if (cellInfos.count==0) {
        return self;
    }
    sectionInfo.headerInfo = headerInfo;
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

-(BOOL)haveSubProgram:(NSArray*)arrangeElements
{
    for (WVRItemModel* cur in arrangeElements) {
        if([cur.programType isEqualToString:PROGRAMTYPE_ARRANGE]){
            continue;
        }
        else{
            return YES;
        }
    }
    return NO;
}
    
- (WVRLiveReviewCellInfo*)getCellInfo:(WVRItemModel*)model {
    
    WVRLiveReviewCellInfo * cellInfo = [WVRLiveReviewCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRLiveRecReviewCell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(214.0f));
    WVRSectionModel * cursecM = [WVRSectionModel new];
    cursecM.name = model.name;
    cursecM.subTitle = model.subTitle;
    cursecM.thubImageUrl = model.thubImageUrl;
    cursecM.linkArrangeType = model.linkArrangeType;
    cursecM.linkArrangeValue = model.linkArrangeValue;
    cursecM.itemCount = model.unitConut;
    cursecM.arrangeShowFlag = model.arrangeShowFlag;
    cursecM.duration = model.duration;
    cursecM.playCount = model.playCount;
    cursecM.detailCount = model.detailCount;
    cellInfo.itemModel = cursecM;
    kWeakSelf(self);
    cellInfo.gotoNextBlock = ^(id args){
        [weakself gotoNextItemVC:cursecM];
    };
    
    return cellInfo;
}

- (WVRSQFindSplitCellInfo*)getSplitCellInfo {
    
    WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
    splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
    splitCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SPLIT_CELL));
    return splitCellInfo;
}

@end

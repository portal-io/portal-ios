//
//  WVRFootballReviewViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballReviewViewSection.h"
#import "WVRSectionModel.h"
#import "WVRFootballModel.h"
#import "WVRFootballRecordCell.h"
#import "WVRBIModel.h"
//#import "WVRLoginTool.h"
#import "WVRSQFindSplitCell.h"
#import "WVRLiveRecReviewCell.h"
#import "WVRLiveRecReBannerCell.h"

@implementation WVRFootballReviewViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeFootballRecord]), NSStringFromClass([WVRFootballReviewViewSection class]))

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
    NSArray* allCellClass = @[[WVRFootballRecordCell class], [WVRSQFindSplitCell class], [WVRLiveRecReviewCell class], [WVRLiveRecReBannerCell class]];
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


- (WVRCollectionViewSectionInfo*)getSectionInfo:(WVRSectionModel*)sectionModel
{
//    NSMutableArray * cellInfos = [NSMutableArray array];
//    for (WVRFootballModel* model in sectionModel.itemModels) {
//        if ([model.type isEqualToString:@"1"]) {
//            continue;
//        }
//        [self addCellInfoTo:cellInfos withModel:model];
//    }
//
    @weakify(self);
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in sectionModel.itemModels) {
        if ([model.type isEqualToString:@"1"]) {
            continue;
        }
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
        cellInfo.gotoNextBlock = ^(id args){
            @strongify(self);
            [self gotoNextItemVC:cursecM];
        };
        [cellInfos addObject:cellInfo];
        if ([model.arrangeShowFlag boolValue]) {
            WVRLiveRecReBannerCellInfo * bCellInfo = [WVRLiveRecReBannerCellInfo new];
            
            bCellInfo.cellNibName = NSStringFromClass([WVRLiveRecReBannerCell class]);
            bCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(180.f));
            bCellInfo.itemModel = model;
//            bCellInfo.controller = [UIViewController getCurrentVC];
            [cellInfos addObject:bCellInfo];
        }
        if (model != sectionModel.itemModels.lastObject) {
            [cellInfos addObject:[self getSplitCellInfo]];
        }
    }
    self.cellDataArray = cellInfos;
    
    return self;
}

- (WVRSQFindSplitCellInfo*)getSplitCellInfo {
    
    WVRSQFindSplitCellInfo * splitCellInfo = [WVRSQFindSplitCellInfo new];
    splitCellInfo.cellNibName = NSStringFromClass([WVRSQFindSplitCell class]);
    splitCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SPLIT_CELL));
    return splitCellInfo;
}


//- (void)addCellInfoTo:(NSMutableArray *)cellInfos withModel:(WVRFootballModel *)model {
//    
//    kWeakSelf(self);
//    WVRFootballRecordCellInfo * cellInfo = [WVRFootballRecordCellInfo new];
//    cellInfo.cellNibName = NSStringFromClass([WVRFootballRecordCell class]);
//    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(266.f));
//    cellInfo.gotoNextBlock = ^(id args) {
//        [weakself gotoDetail:model];
//    };
//    cellInfo.itemModel = model;
//    [cellInfos addObject:cellInfo];
//}

@end

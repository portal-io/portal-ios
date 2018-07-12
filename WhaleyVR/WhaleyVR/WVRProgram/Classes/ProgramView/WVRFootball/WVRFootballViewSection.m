//
//  WVRFootballViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballViewSection.h"
#import "WVRSectionModel.h"
#import "WVRFootballModel.h"
#import "WVRFootballLiveCell.h"
#import "WVRBIModel.h"
//#import "WVRLoginTool.h"

#define HEIGHT_HEADER_IMAGE (211.f)
#define HEIGHT_HEADER_OTHER (89.f)

#define HEIGHT_CELL (258.f)

@interface WVRFootballViewSection ()

@property (nonatomic, strong) WVRSectionModel * gSectionModel;

@end


@implementation WVRFootballViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeFootballLive]), NSStringFromClass([WVRFootballViewSection class]))

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
    NSArray* allCellClass = @[[WVRFootballLiveCell class]];
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
    self.gSectionModel = sectionModel;
    NSMutableArray * cellInfos = [NSMutableArray array];
    int num = 1;
    for (WVRFootballModel *model in sectionModel.itemModels) {
        if ([model.type isEqualToString:@"1"]) {
            continue;
        }
        model.itemId = num;
        [self addCellInfoTo:cellInfos withModel:model];
        num ++;
    }
    
    self.cellDataArray = cellInfos;
    
    return self;
}

- (void)addCellInfoTo:(NSMutableArray *)cellInfos withModel:(WVRFootballModel *)model {
    
    kWeakSelf(self);
    WVRFootballLiveCellInfo * cellInfo = [WVRFootballLiveCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRFootballLiveCell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(266.f));
    cellInfo.gotoNextBlock = ^(id args) {
        [weakself gotoDetail:model];
    };
    cellInfo.itemModel = model;
    [cellInfos addObject:cellInfo];
}



@end

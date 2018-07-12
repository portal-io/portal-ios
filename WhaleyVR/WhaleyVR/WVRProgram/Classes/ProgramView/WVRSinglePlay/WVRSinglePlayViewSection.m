//
//  WVRSinglePlayViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSinglePlayViewSection.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRRecommendPlayerHeader.h"
#import "WVRSectionModel.h"


@implementation WVRSinglePlayViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeSinglePlay]),NSStringFromClass([WVRSinglePlayViewSection class]))


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
    NSArray* allCellClass = @[];
    NSArray* allHeaderClass = @[[WVRRecommendPlayerHeader class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}


-(void)reloadPlayer:(NSNotification*)nof
{
    if (nof.object == self) {
        WVRRecommendPlayerHeaderInfo* headerInfo = (WVRRecommendPlayerHeaderInfo*)self.headerInfo;
        if (headerInfo.reloadPlayerBlock) {
            headerInfo.reloadPlayerBlock();
        }    
    }else{
        NSLog(@"%@：不是当前的page",[self class]);
    }
    
}

- (WVRBaseViewSection*)getSectionInfo:(WVRSectionModel*)sectionModel
{
    kWeakSelf(self);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPlayer:) name:NAME_NOTF_RELOAD_PLAYER object:nil];
    WVRBaseViewSection * sectionInfo = self;//[WVRCollectionViewSectionInfo new];
    //    sectionInfo.edgeInsets = UIEdgeInsetsMake(fitToWidth(0), fitToWidth(MARGIN_LEFT_TAG_SECTION), fitToWidth(0), fitToWidth(MARGIN_LEFT_TAG_SECTION));
    WVRRecommendPlayerHeaderInfo * headerInfo = [WVRRecommendPlayerHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRRecommendPlayerHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(300.f));
    headerInfo.args = [sectionModel.itemModels firstObject];
    headerInfo.needRload = YES;
//    headerInfo.controller = self.viewController;
    headerInfo.gotoNextBlock = ^(WVRRecommendPlayerHeaderInfo* args){
        [weakself gotoNextItemVC:args.args];
    };
    sectionInfo.headerInfo = headerInfo;
    return sectionInfo;
}

-(void)dealloc
{
    DDLogInfo(@"");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

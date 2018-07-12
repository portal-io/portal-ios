//
//  WVRBaseCollectionViewRouting.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseViewSection.h"
#import "WVRItemModel.h"
#import "WVRSectionModel.h"
#import "WVRSQMore2ReusableFooter.h"
#import "WVRSQFindSplitFooter.h"
#import "WVRBaseCollectionView.h"
#import "WVRSQMoreReusableFooter.h"

#import "WVRGotoNextTool.h"
#import "WVRSQFindSplitCell.h"
#import "WVRSQMoreInReusableFooter.h"

@implementation WVRBaseViewSection

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)moreItems:(id)itemModels {

}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    
    NSArray* allCellClass = @[[WVRSQFindSplitCell class]];
    
    NSArray* allHeaderClass = @[];
    
    NSArray* allFooterClass = @[[WVRSQMoreReusableFooter class],[WVRSQMore2ReusableFooter class],[WVRSQFindSplitFooter class],[WVRSQMoreInReusableFooter class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
    
    for (Class class in allFooterClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:name];
    }
}

- (BOOL)prepare {
    
    return YES;
}

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel {
    
    NSAssert(false, @"must implementation");
    return nil;
}

- (SQCollectionViewFooterInfo*)getRefereshFooterInfo:(WVRSectionModel*)footerModel sectionInfo:(SQCollectionViewSectionInfo *)sectionInfo {
    kWeakSelf(self);
    WVRSQMore2ReusableFooterInfo * footerInfo = [WVRSQMore2ReusableFooterInfo new];
    footerInfo.cellNibName = NSStringFromClass([WVRSQMore2ReusableFooter class]);
    footerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, HEIGHT_FIND_FOOTER);
    footerInfo.sectionModel = footerModel;
    footerInfo.btnTitle = @"换一批";
    footerInfo.btnIcon = @"icon_find_refrsh";
    footerInfo.refreshBlock = ^(id args){
        [weakself refreshBlock:sectionInfo];
    };
    return footerInfo;
}

- (void)refreshBlock:(SQCollectionViewSectionInfo *)sectionInfo {
    
    SQCollectionViewCellInfo * cellInfo = [sectionInfo.cellDataArray lastObject];
    NSInteger curLocalIndex = [sectionInfo.originDataArray indexOfObject:cellInfo];
    if (curLocalIndex < sectionInfo.originDataArray.count-COUNT_ITEMS) {
        sectionInfo.cellDataArray = [[sectionInfo.originDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(curLocalIndex+1, COUNT_ITEMS)]] mutableCopy];
    } else {
        sectionInfo.cellDataArray = [[sectionInfo.originDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, COUNT_ITEMS)]] mutableCopy];
    }
    if (self.refreshBlock) {
        self.refreshBlock();
    }
//    [(WVRBaseCollectionView *)self.collectionView updateWithSectionIndex:sectionInfo.sectionIndex];
}

- (SQCollectionViewFooterInfo *)getGotoChannelFooterInfo:(WVRSectionModel *)footerModel {
    if (footerModel) {
        WVRSQMoreInReusableFooterInfo * footerInfo = [WVRSQMoreInReusableFooterInfo new];
        footerInfo.cellNibName = NSStringFromClass([WVRSQMoreInReusableFooter class]);
        footerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, HEIGHT_FIND_FOOTER);
        footerInfo.sectionModel = footerModel;
        footerInfo.btnTitle = @"进入频道";
        footerInfo.btnIcon = @"icon_find_movie_more";
        footerInfo.refreshBlock = ^(WVRSQMore2ReusableFooterInfo* args){
//            [weakself gotoNextSectionVC:footerModel];
            [WVRGotoNextTool gotoNextVC:args.sectionModel module:@"home" nav:[UIViewController getCurrentVC].navigationController];
        };
        return footerInfo;
    }
    return [self getSplitFooterInfo];
}

- (SQCollectionViewFooterInfo *)getSplitFooterInfo {
    
    SQCollectionViewFooterInfo * footerInfo = [[SQCollectionViewFooterInfo alloc] init];
    footerInfo.cellNibName = NSStringFromClass([WVRSQFindSplitFooter class]);
    footerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SPLIT_CELL));
    return footerInfo;
}

- (SQCollectionViewFooterInfo *)getFooterInfo:(WVRSectionModel*)footerModel sectionInfo:(SQCollectionViewSectionInfo *)sectionInfo {
        
    if (!footerModel) {
        return [self getRefereshFooterInfo:footerModel sectionInfo:sectionInfo];
    }
    kWeakSelf(self);
    WVRSQMoreReusableFooterInfo * footerInfo = [WVRSQMoreReusableFooterInfo new];
    footerInfo.cellNibName = NSStringFromClass([WVRSQMoreReusableFooter class]);
    footerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, HEIGHT_FIND_FOOTER);
    footerInfo.sectionModel = footerModel;
    footerInfo.gotoBlock = ^(WVRSQMoreReusableFooterInfo* args) {
//        [weakself.delegate gotoNextSectionVC:footerModel];
        [WVRGotoNextTool gotoNextVC:args.sectionModel module:@"home" nav:[UIViewController getCurrentVC].navigationController];
    };
    
    footerInfo.refreshBlock = ^(id args) {
        [weakself refreshBlock:sectionInfo];
    };
    return footerInfo;
}

#pragma push

- (void)gotoNextSectionVC:(WVRSectionModel *)sectionModel {
    
    [WVRGotoNextTool gotoNextVC:sectionModel module:@"home" nav:[UIViewController getCurrentVC].navigationController];
}

- (void)gotoNextItemVC:(WVRItemModel *)itemModel {
    
//    if ([itemModel.programType isEqualToString:PROGRAMTYPE_LIVE]) {
//        if (itemModel.liveStatus == WVRLiveStatusEnd) {
//            SQToastInKeyWindow(@"直播已结束");
//            return;
//        }
//    }
    [WVRGotoNextTool gotoNextVC:itemModel module:@"home" nav:[UIViewController getCurrentVC].navigationController];
}

- (void)gotoDetail:(WVRItemModel *)itemModel {
    
    [WVRGotoNextTool gotoNextVC:itemModel nav:[UIViewController getCurrentVC].navigationController];
}

@end

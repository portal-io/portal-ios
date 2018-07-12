//
//  WVRBannerViewRouter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBannerViewSection.h"
#import "WVRSQBannerReusableHeader.h"
#import "WVRCollectionViewSectionInfo.h"
#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"

@implementation WVRBannerViewSection

#pragma mark - Banner section

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeBanner]), NSStringFromClass([WVRBannerViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    
    [super registerNibForCollectionView:collectionView];
    NSArray* allHeaderClass = @[[WVRSQBannerReusableHeader class]];
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

- (WVRBaseViewSection*)getSectionInfo:(WVRSectionModel *)sectionModel
{
//    kWeakSelf(self);
    WVRBaseViewSection * sectionInfo = self;//[WVRCollectionViewSectionInfo new];
    WVRSQBannerReusableHeaderInfo * headerInfo = [WVRSQBannerReusableHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRSQBannerReusableHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_FIND_BANNER));
    NSMutableArray * bannerModels = [NSMutableArray array];
    for (WVRItemModel* itemModel in sectionModel.itemModels) {
        WVRBannerModel * model = [WVRBannerModel new];
        model.videoModel = [WVRVideoModel new];
        model.videoModel.name = itemModel.name;
        model.videoModel.itemId = itemModel.code;
        model.videoModel.thubImage = itemModel.thubImageUrl;
        [bannerModels addObject:model];
    }
    headerInfo.bannerModels = bannerModels;
    kWeakSelf(self);
    headerInfo.onClickItemBlock = ^(NSInteger index) {
        [weakself gotoDetail:sectionModel.itemModels[index]];
//MARK: - banner 可能是合集
//        [weakself.delegate gotoNextItemVC:sectionModel.itemModels[index]];
//        [WVRGotoNextTool gotoNextVC:sectionModel.itemModels[index] module:@"home" nav:self.viewController.navigationController];
    };
    sectionInfo.headerInfo = headerInfo;
    return sectionInfo;
}

@end

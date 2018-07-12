//
//  WVRBaseCollectionViewRouting.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionViewSectionInfo.h"
#import "WVRSQFindUIStyleHeader.h"
#import "WVRViewModelDispatcher.h"

@class WVRSectionModel, WVRItemModel, WVRBaseCollectionView;


@interface WVRBaseViewSection : WVRCollectionViewSectionInfo

//@property (nonatomic, weak) UIViewController * viewController;
//@property (nonatomic, weak) WVRBaseCollectionView* collectionView;

@property (nonatomic, copy) void(^refreshBlock)(void);


- (void)registerNibForCollectionView:(UICollectionView *)collectionView;

- (BOOL)prepare;

- (WVRCollectionViewSectionInfo *)getSectionInfo:(WVRSectionModel *)sectionModel;

- (SQCollectionViewFooterInfo *)getFooterInfo:(WVRSectionModel *)footerModel sectionInfo:(SQCollectionViewSectionInfo *)sectionInfo;

- (SQCollectionViewFooterInfo *)getGotoChannelFooterInfo:(WVRSectionModel *)footerModel;

- (SQCollectionViewFooterInfo *)getRefereshFooterInfo:(WVRSectionModel *)footerModel sectionInfo:(SQCollectionViewSectionInfo *)sectionInfo;
- (void)refreshBlock:(SQCollectionViewSectionInfo *)sectionInfo;

- (SQCollectionViewFooterInfo *)getSplitFooterInfo;

- (void)gotoNextSectionVC:(WVRSectionModel *)sectionModel;
- (void)gotoNextItemVC:(WVRItemModel *)itemModel;
- (void)gotoDetail:(WVRItemModel *)itemModel;

- (void)moreItems:(id)itemModels;

@end

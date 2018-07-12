//
//  WVRSiteItemView.h
//  WhaleyVR
//
//  Created by Snailvr on 16/7/25.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRSortItemCell.h"
#import "WVRSortItemModel.h"

@class WVRSortItemView;

@protocol WVRSortItemViewDelegate <NSObject>

@required
- (void)sortItemView:(WVRSortItemView *)itemView didSelectItem:(NSIndexPath *)indexPath;

@optional
- (void)sortItemViewPulldownRefreshData:(WVRSortItemView *)itemView;
- (void)sortItemViewPullupLoadMoreData:(WVRSortItemView *)itemView;

@end


@protocol WVRSortItemViewDataSource <NSObject>

@required
- (NSArray *)cellModelsForItemView:(WVRSortItemView *)itemView;

@end


@interface WVRSortItemView : UICollectionViewCell

@property (nonatomic, weak  ) id<WVRSortItemViewDelegate>   realDelegate;
@property (nonatomic, weak  ) id<WVRSortItemViewDataSource> realDataSource;

@property (nonatomic, strong) NSArray                         *dataArray;
@property (nonatomic, assign) WVRItemCellStyle                 cellStyle;
@property (nonatomic, weak  ) UICollectionView                *collectionView;

- (void)reloadDataWithArray:(NSArray<WVRSortItemModel *> *)dataArray;

- (void)beginRefresh;
- (void)endRefresh;

/// 此步骤必须在设置dataArray之前
- (void)setCellStyle:(WVRItemCellStyle)cellStyle;

@end

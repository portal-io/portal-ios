//
//  WVRPublisherListView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPublisherListModel.h"
@class WVRPublisherListView;

@protocol WVRPublisherListViewDelegate <NSObject>

- (void)listViewDidSelectItemAtIndex:(NSInteger)index itemModel:(WVRPublisherListItemModel *)model;
- (void)listViewPullUpLoadMore:(WVRPublisherListView *)listView;

- (BOOL)mainScrollViewResponsePanGestrue;

@end


@interface WVRPublisherListView : UICollectionView

@property (nonatomic, weak) id<WVRPublisherListViewDelegate> realDelegate;

@property (nonatomic, strong) NSArray<WVRPublisherListItemModel *> *dataArray;
@property (nonatomic, assign) PublisherSortType viewType;

- (void)endRefreshing:(BOOL)isEnd;

@end

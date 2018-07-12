//
//  WVRSearchView.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WVRSortItemView;
@protocol WVRSearchViewDelegate <NSObject>

- (void)searchDataWithKeyWord:(NSString *)keyword;

@optional
- (void)pullDownRefreshForType:(NSInteger)type;
- (void)PullupLoadMoreDataForType:(NSInteger)type;

@end


@interface WVRSearchView : UIView

@property (nonatomic, weak) id<WVRSearchViewDelegate> delegate;

@property (nonatomic, assign) BOOL resultsIsNull;
@property (nonatomic, assign) BOOL isShow3DResult;
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;
@property (nonatomic, strong) NSArray *searchResultsFor3DArray;

@property (nonatomic, strong) WVRSortItemView *searchResultsView;
@property (nonatomic, strong) UITableView *tableView;

- (UICollectionView *)getSearchResultsCollectionView;
- (void)setSearchBarHolder:(NSString *)holderStr;

- (void)showKeyboard;

@end

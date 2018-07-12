//
//  WVRSiteItemView.m
//  WhaleyVR
//
//  Created by Snailvr on 16/7/25.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSortItemView.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRVideoDetailVC.h"

@interface WVRSortItemView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@end


@implementation WVRSortItemView

static NSString *const sortCellIdentifier = @"sortCellIdentifier";

- (void)createMainView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    // WVRCollectionViewFlowLayout  // UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection             = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
    collectionView.mj_header = [SQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshData)];
    collectionView.mj_footer = [SQRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupLoadMoreData)];  // MJRefreshAutoNormalFooter    // MJRefreshBackNormalFooter
    
    // 注册cell、sectionHeader
    [_collectionView registerClass:[WVRSortItemCell class] forCellWithReuseIdentifier:sortCellIdentifier];
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    
    if (!_cellStyle) {                  // 还未设置cell样式，无法创建视图
        return;
    }
    
    if (self.collectionView) {
        
        [_collectionView reloadData];
        
    } else {
        
        [self createMainView];
    }
    
    if (_dataArray.count < kHTTPPageSize)
    {
        self.collectionView.mj_footer.hidden = YES;
    } else {
        self.collectionView.mj_footer.hidden = NO;
    }
}

- (void)setCellStyle:(WVRItemCellStyle)cellStyle {
    
    _cellStyle = cellStyle;
}

- (void)reloadDataWithArray:(NSArray *)dataArray {
    if (!dataArray) {
        return;
    }
    [self setDataArray:dataArray];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogInfo(@"did select item: %ld at section %ld", (long)indexPath.item, (long)indexPath.section);
    
    // 将触发事件传递给代理对象
    [self.realDelegate sortItemView:self didSelectItem:indexPath];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRSortItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sortCellIdentifier forIndexPath:indexPath];
    cell.style = _cellStyle;
    
    WVRSortItemModel *model = nil;
    model = _dataArray[indexPath.item];
    
    cell.titleLabel.text = model.title;
    cell.detailLabel.text = model.desc;
    
    [cell.imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:model.image] placeholderImage:[UIImage imageNamed:@"defaulf_holder_image"]];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_cellStyle == WVRItemCellStyleMovie) {
        float width = [WVRAppModel sharedInstance].movieItemWidth;
        float height = [WVRAppModel sharedInstance].movieItemHeight;
        
        return CGSizeMake(width, height);
    }
    
    // WVRItemCellStyleNormal (VR)
    float cellWidth = [WVRAppModel sharedInstance].normalItemWidth;
    float cellHeight = [WVRAppModel sharedInstance].normalItemHeight;
    
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kItemDistance, 0, kItemDistance);        // 0
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kListCellDistance;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kItemDistance;
}

#pragma mark - pull to refresh

// 下拉更新数据
- (void)pulldownRefreshData {
    if ([_realDelegate respondsToSelector:@selector(sortItemViewPulldownRefreshData:)]) {
        [_realDelegate sortItemViewPulldownRefreshData:self];
    }
}

// 上拉加载更多
- (void)pullupLoadMoreData {
    if ([_realDelegate respondsToSelector:@selector(sortItemViewPullupLoadMoreData:)]) {
        [_realDelegate sortItemViewPullupLoadMoreData:self];
    }
}

- (void)beginRefresh {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)endRefresh {
    if ([self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header endRefreshing];
    }
    if ([self.collectionView.mj_footer isRefreshing]) {
        [self.collectionView.mj_footer endRefreshing];
    }
}


@end

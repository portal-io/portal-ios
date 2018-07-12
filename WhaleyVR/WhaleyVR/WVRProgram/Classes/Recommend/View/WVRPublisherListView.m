//
//  WVRPublisherListView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPublisherListView.h"
#import "SQRefreshFooter.h"
#import "WVRPublisherListCell.h"

@interface WVRPublisherListView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@end


@implementation WVRPublisherListView

static NSString *const publisherListCellId   = @"publisherListCellId";

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(frame.size.width, adaptToWidth(262));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return [self initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        [self configureSelf];
    }
    return self;
}

- (void)configureSelf {
    
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    self.panGestureRecognizer.delegate = self;
    
    [self registerClass:[WVRPublisherListCell class] forCellWithReuseIdentifier:publisherListCellId];
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpLoadMore)];
}

#pragma mark - setter

- (void)setDataArray:(NSArray<WVRPublisherListItemModel *> *)dataArray {
    
    _dataArray = dataArray;
    
    [self reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.contentOffset.y < 0) {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.item;
    WVRPublisherListItemModel *model = self.dataArray[index];
    
    [self.realDelegate listViewDidSelectItemAtIndex:index itemModel:model];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRPublisherListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:publisherListCellId forIndexPath:indexPath];
    
    WVRPublisherListItemModel *model = _dataArray[indexPath.item];
    
    cell.title = model.displayName;
    cell.picUrl = model.smallPic;
    [cell setDuration:model.duration AndPlayCount:model.stat.playCount];
    
    return cell;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    BOOL mineShouldBegin = (self.contentOffset.y != 0);
    if (gestureRecognizer == self.panGestureRecognizer) {
        BOOL result = [self.realDelegate mainScrollViewResponsePanGestrue];
        
        return (!result) || mineShouldBegin;
    }
    return YES;
}

//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return (self.contentOffset.y == 0);
    
//    if (gestureRecognizer == self.panGestureRecognizer) {
//        
//        if (self.contentOffset.y <= 0) {
//            CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
//            if (point.y > 0) {
//                return YES;
//            }
//        }
//        
//        return [self.realDelegate mainScrollViewResponsePanGestrue];
//    }
//    return NO;
}

#pragma mark - func

- (void)pullUpLoadMore {
    
    [self.realDelegate listViewPullUpLoadMore:self];
}

- (void)endRefreshing:(BOOL)isEnd {
    
    if (isEnd) {
        [self.mj_footer endRefreshingWithNoMoreData];
//        SQToastInKeyWindow(kNoMoreData);
    } else {
        [self.mj_footer endRefreshing];
    }
}

@end

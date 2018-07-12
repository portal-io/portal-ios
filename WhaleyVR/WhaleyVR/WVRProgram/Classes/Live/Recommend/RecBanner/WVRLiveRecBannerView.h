//
//  WVRLiveRecommendBannerView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewPagedFlowViewDataSource;
@protocol NewPagedFlowViewDelegate;

/******************************
 
 页面滚动的方向分为横向和纵向
 
 Version 1.0:
 目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
 
 特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效
 
 问题:考虑到轮播图的数量不会太大,暂时未做重用处理;对设备性能影响不明显,后期版本会考虑添加重用标识模仿tableview的重用
 
 ******************************/
/*if (delta < _pageSize.width) {
 
 cell.coverView.alpha = (delta / _pageSize.width) * _minimumPageAlpha;
 
 CGFloat inset = (_pageSize.width * (1 - _minimumPageScale)) * (delta / _pageSize.width)/2.0;//fitToWidth(9/2/2);//
 CGFloat inset_Hor = (_pageSize.width * (1 - _minimumPageScale_Hor)) * (delta / _pageSize.width)/2.0;//fitToWidth(9/2/2);//
 cell.layer.transform = CATransform3DMakeScale((_pageSize.width-inset*2)/_pageSize.width,(_pageSize.height-inset_Hor*2)/_pageSize.height, 1.0);
 cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset_Hor, inset, inset_Hor, inset));
 
 } else {
 
 cell.coverView.alpha = _minimumPageAlpha;
 CGFloat inset = _pageSize.width * (1 - _minimumPageScale) / 2.0 ;//fitToWidth(27/2/2);//
 CGFloat inset_Hor = _pageSize.width * (1 - _minimumPageScale_Hor) / 2.0;//fitToWidth(9/2/2);//
 cell.layer.transform = CATransform3DMakeScale((_pageSize.width-inset*2)/_pageSize.width,(_pageSize.height-inset_Hor*2)/_pageSize.height, 1.0);
 cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset_Hor, inset, inset_Hor, inset));
 }*/
typedef enum{
    NewPagedFlowViewOrientationHorizontal = 0,
    NewPagedFlowViewOrientationVertical
}NewPagedFlowViewOrientation;

@interface WVRLiveRecBannerView : UIView<UIScrollViewDelegate>

/**
 *  默认为横向
 */
@property (nonatomic,assign) NewPagedFlowViewOrientation orientation;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,assign) BOOL needsReload;

/**
 *  一页的尺寸
 */
@property (nonatomic,assign) CGSize pageSize;
/**
 *  总页数
 */
@property (nonatomic,assign) NSInteger pageCount;

@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) NSRange visibleRange;
/**
 *  如果以后需要支持reuseIdentifier，这边就得使用字典类型了
 */
@property (nonatomic,strong) NSMutableArray *reusableCells;

@property (nonatomic,assign)   id <NewPagedFlowViewDataSource> dataSource;
@property (nonatomic,assign)   id <NewPagedFlowViewDelegate>   delegate;

/**
 *  指示器
 */
@property (nonatomic,retain)  UIPageControl *pageControl;

/**
 *  非当前页的透明比例
 */
@property (nonatomic, assign) CGFloat minimumPageAlpha;

/**
 *  非当前页的缩放比例
 */
@property (nonatomic, assign) CGFloat minimumPageScale; //横向

/**
 *  非当前页的缩放比例
 */
@property (nonatomic, assign) CGFloat minimumPageScale_Hor;//纵向
/**
 *  是否开启自动滚动,默认为开启
 */
@property (nonatomic, assign) BOOL isOpenAutoScroll;

/**
 *  是否开启无限轮播,默认为开启
 */
@property (nonatomic, assign) BOOL isCarousel;

/**
 *  当前是第几页
 */
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/**
 *  定时器
 */
@property (nonatomic, weak) NSTimer *timer;

/**
 *  自动切换视图的时间,默认是5.0
 */
@property (nonatomic, assign) CGFloat autoTime;

/**
 *  原始页数
 */
@property (nonatomic, assign) NSInteger orginPageCount;

/**
 *  刷新视图
 */
- (void)reloadData;

/**
 *  获取可重复使用的Cell
 *
 *  @return <#return value description#>
 */
- (UIView *)dequeueReusableCell;

/**
 *  滚动到指定的页面
 *
 *  @param pageNumber <#pageNumber description#>
 */
- (void)scrollToPage:(NSUInteger)pageNumber;

/**
 *  开启定时器,废弃
 */
//- (void)startTimer;

/**
 *  关闭定时器,关闭自动滚动
 */
- (void)stopTimer;

@end


@protocol  NewPagedFlowViewDelegate<NSObject>

/**
 *  单个子控件的Size
 *
 *  @param flowView <#flowView description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeForPageInFlowView:(WVRLiveRecBannerView *)flowView;

@optional
/**
 *  滚动到了某一列
 *
 *  @param pageNumber <#pageNumber description#>
 *  @param flowView   <#flowView description#>
 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WVRLiveRecBannerView *)flowView;

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 *
 *  @return <#return value description#>
 */
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@protocol NewPagedFlowViewDataSource <NSObject>

/**
 *  返回显示View的个数
 *
 *  @param flowView <#flowView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfPagesInFlowView:(WVRLiveRecBannerView *)flowView;

/**
 *  给某一列设置属性
 *
 *  @param flowView <#flowView description#>
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)flowView:(WVRLiveRecBannerView *)flowView cellForPageAtIndex:(NSInteger)index;

@end

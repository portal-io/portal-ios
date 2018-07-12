//
//  WVRPageView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//


@class WVRPageView;

@protocol WVRPageViewDelegate <UIScrollViewDelegate>


@end

@protocol WVRPageViewDataSource <NSObject>


-(NSInteger)numberOfPage:(WVRPageView*)pageView;

-(UIView*)subView:(WVRPageView*)pageView forIndex:(NSInteger)index;


@end

@interface WVRPageView : UIScrollView

@property (nonatomic, weak) id<WVRPageViewDelegate> delegate;
@property (nonatomic, weak) id<WVRPageViewDataSource> dataSource;

-(void)reloadData;

@end

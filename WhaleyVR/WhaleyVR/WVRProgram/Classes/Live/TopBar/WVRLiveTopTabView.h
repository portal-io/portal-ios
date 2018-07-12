//
//  WVRLiveTopTabView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRLiveTopTabView_h
#define WVRLiveTopTabView_h

@class SQBasePresenter;
@protocol WVRLiveTopTabView <NSObject>

+ (instancetype)loadViewWithFrame:(CGRect)frame viewPresenter:(SQBasePresenter*)viewPresenter;

-(void)updateData:(UIScrollView*)scrollView;

-(void)updateSegmentSelectIndex:(NSInteger)index;

-(NSInteger)getSelectIndex;

@end

#endif /* WVRLiveTopTabView_h */

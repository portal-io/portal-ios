//
//  WVRTVDetailView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseView.h"
#import "WVRTVItemModel.h"
#import "WVRVideoDetailBottomView.h"
@class WVRHalfScreenPlayView;

@protocol WVRTVDetailViewDelegate <NSObject>

- (void)didSelectItemModel:(WVRTVItemModel*)itemModel;

- (void)onClickItemType:(WVRVideoDBottomViewType)type bottomView:(WVRVideoDetailBottomView *)view;

@end


@interface WVRTVDetailViewInfo : NSObject

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic) CGRect frame;
@property (nonatomic) WVRTVItemModel * itemModel;
@property (nonatomic) WVRTVItemModel * parentModel;

@end


@interface WVRTVDetailView : SQBaseView

+ (instancetype)createWithInfo:(WVRTVDetailViewInfo*)vInfo;

@property (nonatomic, weak) id<WVRTVDetailViewDelegate> delegate;
@property (nonatomic, weak) WVRHalfScreenPlayView *halfScreenPlayView;
- (void)reloadData;
- (void)selectNextItem;
//- (void)updateCollectionStatus:(BOOL)isCollection;

@end

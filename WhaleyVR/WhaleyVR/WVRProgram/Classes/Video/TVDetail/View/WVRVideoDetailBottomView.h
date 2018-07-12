//
//  WVRVideoDetailBottomView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseView.h"
@class WVRVideoDetailBottomView;

typedef NS_ENUM(NSInteger, WVRVideoDBottomViewType) {
    
    WVRVideoDBottomViewTypeDown,
    WVRVideoDBottomViewTypeCollection,
    WVRVideoDBottomViewTypeShare,
};

typedef NS_ENUM(NSInteger, WVRVideoDBottomVDownStatus) {
    
    WVRVideoDBottomVDownStatusEnable,
    WVRVideoDBottomVDownStatusNeedCharge,
    WVRVideoDBottomVDownStatusDown,
};

@protocol WVRVideoDBottomViewDelegate <NSObject>

- (void)onClickItemType:(WVRVideoDBottomViewType)type bottomView:(WVRVideoDetailBottomView *)view;

@end


@interface WVRCenterButton : UIButton

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage tag:(NSInteger)tag containerView:(UIView *)containerView;

- (void)setStatus:(WVRVideoDBottomVDownStatus)status;

@end


@interface WVRVideoDetailBottomView : SQBaseView

@property (nonatomic, weak) id<WVRVideoDBottomViewDelegate> delegate;

- (void)updateCollectionDone:(BOOL)done;
- (void)updateDownBtnStatus:(WVRVideoDBottomVDownStatus)status;

@end

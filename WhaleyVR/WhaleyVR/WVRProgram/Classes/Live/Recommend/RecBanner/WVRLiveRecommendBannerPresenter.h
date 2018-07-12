//
//  WVRLiveRecommendBannerPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenter.h"
@class WVRItemModel;

@interface WVRLiveRecommendBannerPresenter : WVRPresenter

@property (nonatomic) NSArray<WVRItemModel*>* itemModels;

+ (instancetype)createPresenter:(id)createArgs;

- (UIView *)getView;
- (void)setFrameForView:(CGRect)frame;

@end

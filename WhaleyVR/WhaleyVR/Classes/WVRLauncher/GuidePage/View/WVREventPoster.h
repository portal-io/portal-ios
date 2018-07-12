//
//  WVREventPoster.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/19.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 活动海报图

#import <UIKit/UIKit.h>
#import "WVRRecommendItemModel.h"

@interface WVREventPoster : UIView

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithModel:(WVRRecommendItemModel *)viewModel;

- (void)show;

@end

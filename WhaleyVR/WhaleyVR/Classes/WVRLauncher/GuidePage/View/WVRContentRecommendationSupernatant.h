//
//  WVRContentRecommendationSupernatant.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/19.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 内容推荐浮层

#import <UIKit/UIKit.h>
#import "WVRRecommendItemModel.h"

@interface WVRContentRecommendationSupernatant : UIView

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithModel:(WVRRecommendItemModel *)viewModel;

- (void)show;

@end

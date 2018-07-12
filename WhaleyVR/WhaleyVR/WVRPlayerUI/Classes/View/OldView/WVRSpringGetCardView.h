//
//  WVRSpringGetCardView.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 获得福卡 弹出框

#import <UIKit/UIKit.h>
#import "WVRSpringCardModel.h"

@protocol WVRSpringGetCardViewDelegate <NSObject>

- (void)cardClosed;
- (void)gotoMyCardVC;

@end


@interface WVRSpringGetCardView : UIView

@property (nonatomic, strong, readonly) WVRSpringCardModel *dataModel;

@property (nonatomic, weak) id<WVRSpringGetCardViewDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithModel:(WVRSpringCardModel *)dataModel;

@end

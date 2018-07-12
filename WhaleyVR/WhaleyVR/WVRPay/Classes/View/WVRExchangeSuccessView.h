//
//  WVRExchangeSuccessView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRMyTicketListModel.h"

@interface WVRExchangeSuccessView : UIView

- (instancetype)initWithDataModel:(WVRMyTicketItemModel *)dataModel;

@property (nonatomic, readonly) WVRMyTicketItemModel *dataModel;
@property (nonatomic, copy) void(^lookupDetailBlock)(void);

- (void)showWithAnimate;
- (void)dissmissWithAnimate;

// 兑换页面专用
- (void)successIconAnimate;

@end


@interface WVRExchangeSuccessCenterView : UIView

@property (nonatomic, strong) WVRMyTicketItemModel *dataModel;

@end


@interface UIView (BLAnimation)

/// 弹性动画 iOS9 later
- (void)springAnimation NS_AVAILABLE_IOS(9_0);

@end

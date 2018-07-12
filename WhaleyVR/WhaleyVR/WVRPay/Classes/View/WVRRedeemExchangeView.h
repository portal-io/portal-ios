//
//  WVRRedeemExchangeView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/20.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 兑换码兑换

#import <UIKit/UIKit.h>
@class WVRMyTicketItemModel;

@protocol WVRRedeemExchangeViewDelegate <NSObject>

@optional
- (void)viewControllerNeedUpdateStatusBar:(BOOL)hidden;

- (void)showSuccessResultWithModel:(WVRMyTicketItemModel *)model;

@end


@interface WVRRedeemExchangeView : UIView

@property (nonatomic, weak) id<WVRRedeemExchangeViewDelegate> realDelegate;

- (instancetype)initWithTextFieldOrigin:(CGPoint)originPoint size:(CGSize)originSize;

- (void)showWithAnimate;

@end


@interface WVRExchangeTextField : UITextField

@end

//
//  WVRUnityPaymentTempVC.h
//  WhaleyVR
//
//  Created by Bruce on 2017/7/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// Unity跳转支付界面的时候的背景视图控制器

#import "WVRBaseViewController.h"
@class WVRPayModel;

@interface WVRUnityPaymentTempVC : WVRBaseViewController

- (instancetype)initWithData:(NSDictionary *)dict payModel:(WVRPayModel *)payModel;

@end

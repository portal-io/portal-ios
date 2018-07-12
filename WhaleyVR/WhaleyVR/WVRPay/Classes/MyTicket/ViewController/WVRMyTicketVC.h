//
//  WVRMyTicketVC.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 我的券/兑换码

#import "WVRBaseViewController.h"

@interface WVRMyTicketVC : WVRBaseViewController

@property (nonatomic, assign) BOOL isFromUnity;
@property (nonatomic, copy) void(^backUnityBlock)(void);

@end

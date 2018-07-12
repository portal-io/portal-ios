//
//  SNBaseViewController.h
//  soccernotes
//
//  Created by sqb on 15/6/25.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

//#import "ViewController.h"
#import "BaseBackForResultDelegate.h"
#import "SQTableViewDelegate.h"
#import "SQKeyboardTool.h"
#import "WVRBaseViewCProtocol.h"

@interface WVRBaseViewController : UIViewController<BaseBackForResultDelegate, WVRBaseViewCProtocol>

@property (nonatomic, strong) SQKeyboardTool * keyTool;

@property (nonatomic, strong) id createArgs;
@property (nonatomic, strong) id backArgs;
@property (nonatomic, weak) id<BaseBackForResultDelegate> backDelegate;

@property (nonatomic, assign) NSInteger backCode;

@property (nonatomic, assign) BOOL hiddenStatusBar;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/// 需要隐藏导航栏，默认为NO
@property (nonatomic, assign) BOOL needHideNav;

- (void)initTitleBar;

- (void)pushViewController:(WVRBaseViewController *)vc animated:(BOOL)animated;

- (void)showCancleLeftBtn;

- (void)backOnClick;

// 网络出错无数据时展示的页面
//@property (nonatomic, weak  ) UIView<WVRErrorViewProtocol> *netErrorView;

@end

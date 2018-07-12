//
//  WVRWebViewController.h
//  VRManager
//
//  Created by Snailvr on 16/7/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// WVRHybrid 耦合了登录、抽奖（可以通过路由的方式解耦）、Image、Share 等模块

#import <UIKit/UIKit.h>
#import "WVRWebView.h"
#import "WVRNavigationBar.h"
#import "WVRBaseViewController.h"
#import "WVRUMShareView.h"

@interface WVRWebViewController : WVRBaseViewController<WVRWebViewDelegate>

@property (copy, nonatomic) NSString *URLStr;
@property (nonatomic, assign) BOOL isNews;

/// 用来上报查看次数
@property (nonatomic, copy) NSString *code;

// MARK: - 子类继承, 外部谨慎调用

@property (nonatomic, strong) WVRUMShareView *shareV;

@property (nonatomic, weak) WVRWebView *webView;

@property (nonatomic, assign, getter = isLoadOver) BOOL loadOver;

@property (nonatomic, copy) NSString *shareCallBackId;
@property (nonatomic, copy) NSString *userInfoCallBackId;

@property (nonatomic, assign) BOOL isHybridPage;

@property (nonatomic, assign) BOOL topBarTransparent;

@property (nonatomic, weak) WVRDetailNavigationBar *navBar;

- (void)createNavBar ;

@end


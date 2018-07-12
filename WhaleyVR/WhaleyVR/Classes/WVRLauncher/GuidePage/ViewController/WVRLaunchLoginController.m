//
//  WVRLaunchLoginController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLaunchLoginController.h"
#import "WVRLaunchLoginView.h"
#import "WVRLoginTool.h"
#import "UnityAppController.h"
#import "WVRLaunchImageVC.h"

@interface WVRLaunchLoginController ()<WVRLaunchLoginDelegate>

@end


@implementation WVRLaunchLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WVRLaunchLoginView *view = (WVRLaunchLoginView *)VIEW_WITH_NIB(NSStringFromClass([WVRLaunchLoginView class]));
    view.loginDelegate = self;
    view.frame = self.view.bounds;
    
    [self.view addSubview:view];
    [view configPanoView:self];
    
    kWeakSelf(self);
    self.loginSuccessBlock = ^{
        [weakself gotoMainView];
    };
}

- (void)configSelf {
    
}

-(void)configSubviews
{

}

//-(void)initLoginRAC
//{
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - WVRLaunchLoginDelegate

- (void)onClickItem:(WVRLaunchLoginType)type btn:(UIButton *)btn {
    
    switch (type) {
        case WVRLaunchLoginTypeGoTry:
            [WVRTrackEventMapping trackingWelcome:@"skip"];
            [self gotoMainView];
            break;
        case WVRLaunchLoginTypeLogin:
            [WVRTrackEventMapping trackingWelcome:@"login"];
            [self gotoLoginVC];
            break;
        case WVRLaunchLoginTypeRegister:
            [WVRTrackEventMapping trackingWelcome:@"register"];
            [self gotoRegisterVC];
            break;
        case WVRLaunchLoginTypeQQ:
            [WVRTrackEventMapping trackingWelcome:@"qq"];
            [self thirtyPClick:QQ_btn_tag];
            break;
        case WVRLaunchLoginTypeWX:
            [WVRTrackEventMapping trackingWelcome:@"wechat"];
            [self thirtyPClick:WX_btn_tag];
            break;
        case WVRLaunchLoginTypeWB:
            [WVRTrackEventMapping trackingWelcome:@"weibo"];
            [self thirtyPClick:WB_btn_tag];
            break;
            
        default:
            break;
    }
}

- (void)gotoMainView {
    
    [self displayLaunchImage:NO];
}

- (void)displayLaunchImage:(BOOL)isFirstLaunch {
    
    WVRLaunchImageVC *vc = [[WVRLaunchImageVC alloc] init];
    vc.onlyShowLaunchImage = YES;       // [WVRLaunchImageVC canShowLaunchImage];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
}


- (void)gotoLoginVC {
    
    kWeakSelf(self);
    [WVRLoginTool toGoLogin:^{
        [weakself gotoMainView];
    } loginCanceledBlock:^{}];
}

- (void)gotoRegisterVC {
    
    kWeakSelf(self);
    [WVRLoginTool toGoRegister:^{
        [weakself gotoMainView];
    } registerCanceledBlock:^{}];
}

#pragma mark - status bar

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end

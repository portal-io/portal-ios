//
//  WVRRNGoldViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNGoldViewController.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "WVRRNConfig.h"

@interface WVRRNGoldViewController ()

@end

@implementation WVRRNGoldViewController

-(void)loadView
{
    [self loadReactNativeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self showProgress];
}

-(void)loadReactNativeView
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.createArgs];
    dic[@"routeName"] = @"ContributionTab";
    dic[@"isTest"] = @([WVRUserModel sharedInstance].isTest);
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[WVRRNConfig sharedInstance].gBridge moduleName:@"whaley_react_native" initialProperties:dic];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    self.view = rootView;
}

- (void)backForResult:(id)info resultCode:(NSInteger)resultCode {
//    [self.backDelegate backForResult:info resultCode:resultCode];
    
    [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self presentingViewController]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (BOOL)prefersStatusBarHidden {
    
    return self.hiddenStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

-(void)dealloc{
    DebugLog(@"");
}

@end

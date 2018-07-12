//
//  WVRRNDemoViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNDemoViewController.h"
//#import <React/RCTBundleURLProvider.h>
//#import <React/RCTRootView.h>
@interface WVRRNDemoViewController ()

@end

@implementation WVRRNDemoViewController
-(void)loadView
{
    [self loadReactNativeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadReactNativeView
{
//    NSURL *jsCodeLocation;
//    jsCodeLocation = [NSURL
//                      URLWithString:@"http://172.29.2.1.xip.io:8081/index.bundle?platform=ios&dev=true&minify=false"];
//    //    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//    
//    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
//                                                        moduleName:@"whaley_react_native"
//                                                 initialProperties:self.createArgs
//                                                     launchOptions:nil];
//    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
//    self.view = rootView;
    //    [self.view addSubview:rootView];
    //    [self.view bringSubviewToFront:rootView];
    //    rootView.frame = self.view.bounds;
}

@end

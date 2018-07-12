//
//  WVRWKWebViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRWKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WVRWKWebViewController ()

@property (nonatomic, strong) WKWebView * gWKWebView;

@end

@implementation WVRWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gWKWebView];
    [self.gWKWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:self.urlStr]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (WKWebView *)gWKWebView {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsInlineMediaPlayback=true;
    
    if (!_gWKWebView) {
        _gWKWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration: configuration];
    }
    return _gWKWebView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.gWKWebView.bounds = self.view.bounds;
    self.gWKWebView.center = self.view.center;
}

@end

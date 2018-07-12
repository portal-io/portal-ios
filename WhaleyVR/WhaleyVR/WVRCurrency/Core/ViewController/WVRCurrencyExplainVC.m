//
//  WVRCurrencyExplainVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyExplainVC.h"
#import <WebKit/WebKit.h>

@interface WVRCurrencyExplainVC ()

@end

@implementation WVRCurrencyExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"鲸币说明";
    
    CGRect rect = CGRectMake(0, kNavBarHeight, self.view.width, self.view.height - kNavBarHeight);
    WKWebView *web = [[WKWebView alloc] initWithFrame:rect];
    [self.view addSubview:web];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"currency.html" withExtension:@"nil"];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"currency"
                                                          ofType:@"html"];
    
//    assert(htmlPath != nil);
    
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [web loadHTMLString:htmlCont baseURL:baseURL];
}

@end

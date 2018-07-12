//
//  WVRAgreementVC.m
//  VRManager
//
//  Created by Snailvr on 16/7/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAgreementVC.h"

@interface WVRAgreementVC ()
{
    UIWebView *webView_;
}
@end


@implementation WVRAgreementVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self bulidUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    webView_.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

- (void)bulidUI {
    
    self.navigationItem.title = @"用户协议";
    
    webView_ = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView_ setScalesPageToFit:YES];
    
    [self.view addSubview:webView_];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    
    NSURLRequest *reuqest = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        [webView_ loadRequest:reuqest];
    }
}

- (void)backClick:(UIButton *)btn {
    
    [WVRTrackEventMapping trackEvent:@"protocol" flag:@"back"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

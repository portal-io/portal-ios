//
//  WVRSQHelperController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/25.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQHelperController.h"

@interface WVRSQHelperController ()<UIWebViewDelegate>

@property (nonatomic) UIWebView * mWebView;

@end


@implementation WVRSQHelperController

+ (instancetype)createViewController:(id)createArgs
{
    WVRSQHelperController * vc =[[WVRSQHelperController alloc] init];
    vc.createArgs = createArgs;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.mWebView.delegate = self;
    [self.view addSubview:self.mWebView];
    SQShowProgress;
    if (self.createArgs) {
        self.title = @"问题反馈";
        [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.createArgs]]];
    } else {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"app-help-h5/helper"
                                                              ofType:@"html"];
        
        if (htmlPath == nil) {
#if (kAppEnvironmentTest == 1)
            SQToastInKeyWindow(@"请检查资源文件是否以资源文件形式添加到项目，特别是Unity混合工程");
#endif
            return;
        }
        
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [self.mWebView loadHTMLString:htmlCont baseURL:baseURL];
        self.title = @"使用帮助";
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.mWebView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

- (void)initTitleBar
{
    [super initTitleBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    SQHideProgress;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    SQHideProgress;
}

@end

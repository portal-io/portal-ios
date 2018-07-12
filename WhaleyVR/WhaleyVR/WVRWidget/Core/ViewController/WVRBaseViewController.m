//
//  SNBaseViewController.m
//  soccernotes
//
//  Created by sqb on 15/6/25.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "WVRBaseViewController.h"
#import "WVREmptyViewProtocol.h"
#import "WVRBaseEmptyView.h"

@interface WVRBaseViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property UINavigationController *nav;
@property (nonatomic, strong) UIView<WVREmptyViewProtocol> *gEmptyView;


@end


@implementation WVRBaseViewController

- (SQKeyboardTool *)keyTool
{
    if (!_keyTool) {
        _keyTool = [[SQKeyboardTool alloc] init];
    }
    return _keyTool;
}

- (void)bindViewModel:(id)viewModel {

}

- (UIView<WVREmptyViewProtocol> *)gEmptyView {
    
    if (!_gEmptyView) {
//        Class cls = NSClassFromString(@"WVRBaseEmptyView");
        _gEmptyView = [[WVRBaseEmptyView alloc] initWithFrame:CGRectZero];
    }
    return _gEmptyView;
}

- (UIView<WVREmptyViewProtocol> *)getEmptyView {
    
    return self.gEmptyView;
}

#pragma mark - WVREmptyView

- (void)showLoadingWithText:(NSString *)text {
    
    SQShowProgress;
}

- (void)hidenLoading {
    
    SQHideProgress;
}

- (void)showNetErrorVWithreloadBlock:(void (^)(void))reloadBlock {
    [self.view bringSubviewToFront:self.gEmptyView];
    [self.gEmptyView showNetErrorVWithreloadBlock:reloadBlock];
}

- (void)showNullViewWithTitle:(NSString *)title icon:(NSString *)icon withreloadBlock:(void (^)(void))reloadBlock
{
    [self.view bringSubviewToFront:self.gEmptyView];
    [self.gEmptyView showNullViewWithTitle:title icon:icon withreloadBlock:reloadBlock];
}

- (void)clear {
    
    self.gEmptyView.hidden = YES;
}

#define kNavTitleFont           [UIFont systemFontOfSize:19.f]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hiddenStatusBar = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (self.navigationController.viewControllers.count > 1) {
        
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{ NSFontAttributeName:kNavTitleFont,
            NSForegroundColorAttributeName:[UIColor blackColor] }];
        
        UIImage *image = [[UIImage imageNamed:@"nav_icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    }
    [self.view addSubview:self.gEmptyView];
    
    [self initTitleBar];
    
//    [self.navigationController.interactivePopGestureRecognizer setValue:@([UIScreen mainScreen].bounds.size.width) forKeyPath:@"_recognizer._settings._edgeSettings._edgeRegionSize"];
}

- (void)leftBarButtonClick {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.gEmptyView.frame = self.view.bounds;
//    self.gEmptyView.frame = CGRectMake(0, kNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavBarHeight-kTabBarHeight);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - WVRToastView

- (void)showToast:(NSString *)content {
    
    if (content) {
        SQToast(content);
    }
}

- (void)showAlert {
    
}

#pragma mark - WVREmptyView

- (void)pushViewController:(WVRBaseViewController *)vc animated:(BOOL)animated {
    vc.backDelegate = self;
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)receiveNtf:(NSNotification *)ntf {
    
    void(^block)(void) = ntf.object;
    block();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initTitleBar {
    
    [self defaultBackButtonItem];
}

- (void)initTitleBarColor {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20], NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (UIBarButtonItem *)leftBarButtonItem {
    return nil;
}

- (void)defaultBackButtonItem {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.tintColor =  [UIColor blackColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

- (void)backForResult:(id)info resultCode:(NSInteger)resultCode {
    
    NSLog(@"Base backForResult");
}

// MARK: - external func

- (void)showCancleLeftBtn {
    if ([self presentingViewController]) {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 44);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [leftButton addTarget:self action:@selector(backOnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
}

- (void)backOnClick {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - WVRBaseViewCProtocol

- (void)requestInfo
{
    NSAssert(![NSStringFromClass([self class]) isEqualToString:@"WVRBaseViewController"], @"must over requestInfo");
}

- (void)detailLoadFail:(id)args
{
    @weakify(self);
    if ([WVRReachabilityModel isNetWorkOK]) {
        [self showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    } else {
        [self showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    }
}

- (void)subHandleFail:(NSString *)toast
{
    [self showToast:toast];
}

#pragma mark - status bar

/* 设置Statue Bar的状态 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

#pragma mark - orientation

- (BOOL)shouldAutorotate {
    
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif 
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

-(BOOL)prefersHomeIndicatorAutoHidden
{
    BOOL autoHidden = [WVRAppContext sharedInstance].gHomeIndicatorAutoHidden;
    return autoHidden;
}
@end

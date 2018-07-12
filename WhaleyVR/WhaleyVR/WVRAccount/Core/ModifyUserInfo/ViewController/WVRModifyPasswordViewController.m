//
//  WVRModifyPasswordViewController.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRModifyPasswordViewController.h"
#import "WVRUserInfoViewController.h"
#import "WVRLoginViewController.h"
#import "WVRUserModel.h"
#import "WVRAccountAlertView.h"
#import "WVRLoginTool.h"

#import "WVRForgotPWVC.h"

#import "WVRModifyPWViewModel.h"
//#import "WVRMineController.h"

@interface WVRModifyPasswordViewController ()<WVRAccountAlertViewDelegate>

@property (nonatomic, strong) WVRModifyPasswordView *contentView;
@property (nonatomic, strong) WVRAccountAlertView *accountAlertView;

@property (nonatomic, strong) WVRModifyPWViewModel * gModifyPWViewModel;

@end


@implementation WVRModifyPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configSelf];
    [self configSubviews];
    [self setUpRAC];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.contentView showInputBoard];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)configSelf
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0f]} forState:UIControlStateNormal];
    [self.navigationItem setTitle:@"修改密码"];
}

- (void)configSubviews
{
    __block WVRModifyPasswordViewController * blockSelf = self;
    _contentView = [[WVRModifyPasswordView alloc] init];

    _contentView.frame = CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavBarHeight);
    _contentView.forgotLabelOnClickBlock = ^{
        [blockSelf forgotPW];
    };
    [self.view addSubview:_contentView];
    
    if (_isFindOldPWMode) {
        [_contentView changeToFindOldPWMode];
    }
    
    _accountAlertView = [[WVRAccountAlertView alloc] init];
    [_accountAlertView setEnableBgTouchDisappear:YES];
    [_accountAlertView setDelegate:self];
}

- (void)forgotPW
{
    WVRForgotPWVC *securityLoginVC = [[WVRForgotPWVC alloc] init];
    securityLoginVC.viewStyle = WVRRegisterViewStyleFindOldPassword;
    [self.navigationController pushViewController:securityLoginVC animated:YES];
}

-(WVRModifyPWViewModel *)gModifyPWViewModel
{
    if (!_gModifyPWViewModel) {
        _gModifyPWViewModel = [[WVRModifyPWViewModel alloc] init];
    }
    return _gModifyPWViewModel;
}

-(void)setUpRAC
{
    @weakify(self);
    [self.gModifyPWViewModel.mCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpChangePWSuccessBlock:x];
    }];
    [self.gModifyPWViewModel.mFailSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self requestFaild:x];
    }];
    [self.gModifyPWViewModel.fCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpForgotPWSuccessBlock:x];
    }];
    [self.gModifyPWViewModel.fFailSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self requestFaild:x];
    }];
}

- (void)rightButtonClick
{
    [self.view endEditing:YES];
    if (!_isFindOldPWMode) {
        if ([[_contentView getOldPassword] isEqualToString:@""])
        {
            [self showMessageToWindow:@"请输入原密码"];
            return;
        }
        if (![WVRGlobalUtil validatePassword:[_contentView getOldPassword]])
        {
            [self showMessageToWindow:@"原密码格式不对"];
            return;
        }
    }
    if ([[_contentView getNewPassword] isEqualToString:@""])
    {
        [self showMessageToWindow:@"请输入新密码"];
        return;
    }
    
    if (![WVRGlobalUtil validatePassword:[_contentView getNewPassword]])
    {
        [self showMessageToWindow:@"新密码格式不对"];
        return;
    }
    
    if ([[_contentView getConfirmNewPassword] isEqualToString:@""])
    {
        [self showMessageToWindow:@"请确认新密码"];
        return;
    }
    
    if (![_contentView isPasswordSame]) {
        [_contentView updateTextFieldBgSelected:YES];
        [self showMessageToWindow:@"两次密码输入不一致"];
        return;
    }else{
        [_contentView updateTextFieldBgSelected:NO];
    }
    
    if (WVRModifyPasswordViewStyleFindOldPW == _contentView.style) {
//        [self httpForgotPW];
        self.gModifyPWViewModel.inputPW = [self.contentView getNewPassword];
        self.gModifyPWViewModel.inputCode = _smsCode;
        [[self.gModifyPWViewModel forgotPWCmd] execute:nil];
    }else if(WVRModifyPasswordViewStyleModifyPW == _contentView.style){
        
        [_accountAlertView setTitle:@"修改密码需要重新登录，确定继续吗？"];
        [_accountAlertView showOnView:self.view];
    }
}

- (void)requestFaild:(NSString *) errorStr
{
    [self hideProgress];
    [self showMessageToWindow:errorStr];
}

#pragma mark - WVRAccountAlertViewDelegate
- (void)ensureView:(WVRAccountAlertView *)ensureView buttonDidClickedAtIndex:(NSInteger)index
{
    NSLog(@"Click %ld", (long)index);
    
    [_accountAlertView disappearHandle];
    
    if (0 == index) {
        self.gModifyPWViewModel.oldPW = [self.contentView getOldPassword];
        self.gModifyPWViewModel.inputPW = [self.contentView getNewPassword];
        [[self.gModifyPWViewModel modifyPWCmd] execute:nil];
    } else if (1 == index) {
    }
}

- (void)httpForgotPWSuccessBlock:(NSString *)successStr
{
    [self hideProgress];
    [WVRUserModel sharedInstance].isLogined = NO;
    [WVRUserModel sharedInstance].firstLogin = NO;
    
    UIViewController *rootVC = nil;
    for (UIViewController *vc in [self.navigationController viewControllers]) {
        if ([vc isKindOfClass:[WVRLoginViewController class]]) {
            rootVC = vc;
        }
    }
    if ([successStr isKindOfClass:[NSString class]]) {
        SQToast(successStr);
    }
    if (rootVC) {
        
        [self.navigationController popToViewController:rootVC animated:NO];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)httpChangePWSuccessBlock:(NSString *)successStr {
    
    [WVRUserModel sharedInstance].isLogined = NO;
    [WVRUserModel sharedInstance].firstLogin = NO;
    [WVRUserModel sharedInstance].loginAvatar = @"";
    
    [WVRLoginTool clearLocalAvatar];
    
    NSString *message = successStr;
    
    UIViewController *rootVC = [self.navigationController.viewControllers firstObject];//nil;
    
    WVRLoginViewController *loginVC = [[WVRLoginViewController alloc] init];
    loginVC.viewStyle = WVRLoginViewViewStyleNormalLogin;
    loginVC.hidesBottomBarWhenPushed = YES;
    if ([successStr isKindOfClass:[NSString class]]) {
        [loginVC showMessageToWindow:message];
    }
    if(rootVC){
        [self.navigationController popToViewController:rootVC animated:NO];
        [rootVC.navigationController pushViewController:loginVC animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end

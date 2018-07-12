//
//  WVRModifyPhoneNumViewController.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRModifyPhoneNumViewController.h"
#import "WVRModifyPhoneNumView.h"
#import "WVRUserModel.h"
#import "WVRModifyPhoneNViewModel.h"

@interface WVRModifyPhoneNumViewController ()

@property (nonatomic, strong) WVRModifyPhoneNumView *contentView;

@property (nonatomic) NSString * mCaptcha;

@property (nonatomic, strong) WVRModifyPhoneNViewModel * gMPhoneNViewModel;

@end

@implementation WVRModifyPhoneNumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpRAC];
    [self configSelf];
    [self configSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

- (void)configSelf
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0f]} forState:UIControlStateNormal];
    [self.navigationItem setTitle:@"修改手机"];
}

- (void)configSubviews
{
    _contentView = [[WVRModifyPhoneNumView alloc] init];
    [self.view addSubview:_contentView];
    _contentView.frame = self.view.bounds;
    __block WVRModifyPhoneNumViewController* blockSelf = self;
    _contentView.getCodeBlock = ^{
//        [blockSelf httpSMS_token];
        [blockSelf sendSMS];
    };
    _contentView.getCaptchaBlock = ^{
        [blockSelf getNewCaptcha];
    };
    
}

- (void)getNewCaptcha {
    
    [_contentView setCaptcha:self.mCaptcha];
}

-(WVRModifyPhoneNViewModel *)gMPhoneNViewModel
{
    if (!_gMPhoneNViewModel) {
        _gMPhoneNViewModel = [[WVRModifyPhoneNViewModel alloc] init];
    }
    return _gMPhoneNViewModel;
}

-(void)setUpRAC
{
    @weakify(self);
    [self.gMPhoneNViewModel.completeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpChangePhoneNumSuccessBlock:@"手机号修改成功"];
    }];
    
    [[RACObserve(self.gMPhoneNViewModel, responseCaptcha) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.mCaptcha = self.gMPhoneNViewModel.responseCaptcha;
        [self.contentView displayVeryfyCodeInputView];
        [self.contentView setCaptcha:self.gMPhoneNViewModel.responseCaptcha];
    }];
    
    [[RACObserve(self.gMPhoneNViewModel, responseMsg) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        SQHideProgress;
        SQToast(x);
    }];
    [[RACObserve(self.gMPhoneNViewModel, responseCode) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.contentView startTimer];
    }];

}


- (void)rightButtonClick
{
    NSString * phoneNum = [_contentView getNewPhoneNum];
    if (![WVRGlobalUtil validateMobileNumber:phoneNum])
    {
        [self showMessageToWindow:@"请输入正确手机号"];
        return;
    }
    
    if ([_contentView getPhoneCode].length == 0)
    {
        [self showMessageToWindow:@"请输入验证码"];
        return;
    }
    
    if (![WVRReachabilityModel isNetWorkOK])
    {
        [self showMessageToWindow:kNetError];
        return;
    }
    self.gMPhoneNViewModel.inputPhoneNum = [self.contentView getNewPhoneNum];
    self.gMPhoneNViewModel.inputCode = [self.contentView getPhoneCode];
    [[self.gMPhoneNViewModel modifyPhoneCmd] execute:nil];
//    [self httpChangePhoneNum];
}

- (void)sendSMS
{
    //    NSString *deviceId= [WVRUserModel sharedInstance].deviceId;
    NSString *phoneNum = [self.contentView getNewPhoneNum];
    
    if (![WVRGlobalUtil validateMobileNumber:phoneNum])
    {
        [self showMessageToWindow:@"请输入正确手机号"];
        return;
    }
    
    if (![WVRReachabilityModel isNetWorkOK])
    {
        [self showMessageToWindow:kNetError];
        return;
    }
    self.gMPhoneNViewModel.inputPhoneNum = [self.contentView getNewPhoneNum];
    self.gMPhoneNViewModel.inputCaptcha = [self.contentView getCaptchaCode];
    [[self.gMPhoneNViewModel validateCmd] execute:nil];
//    [self httpSendSMSCode];
}

#pragma http changePW

- (void)httpChangePhoneNumSuccessBlock:(NSString *)successStr
{
    [WVRUserModel sharedInstance].isLogined = NO;
    [WVRUserModel sharedInstance].firstLogin = NO;
    
    NSString *message = successStr;
    [self showMessageToWindow:message];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

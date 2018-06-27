//
//  WVRForgotPWVC.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRForgotPWVC.h"

//#import "WVRHttpForgotPWSMSCode.h"
//#import "WVRHttpForgotPWValidateCode.h"
#import "WVRModifyPasswordViewController.h"
//#import "WVRHttpSMSToken.h"
#import "WVRUserModel.h"
//#import "WVRHttpSMSCode.h"
//#import "WVRHttpSMSLogin.h"
#import "WVRForgotPWViewModel.h"

@interface WVRForgotPWVC ()

@property (nonatomic, strong) WVRForgotPWViewModel* gForgotViewModel;

@end
@implementation WVRForgotPWVC

-(void)initRegisterRAC
{
    @weakify(self);
    [self.gForgotViewModel.gSendCodeCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpForgotPWSMSCodeSuccessBlock:x];
    }];
    [self.gForgotViewModel.gValidCodeCompleteSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpForgotPWValidateCodeSuccessBlock:x];
    }];
    
    [[RACObserve(self.gForgotViewModel, responseCaptcha) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.captcha = self.gForgotViewModel.responseCaptcha;
        [self.contentView displayVeryfyCodeInputView];
        [self.contentView setCaptcha:self.gForgotViewModel.responseCaptcha];
    }];
    
    [[RACObserve(self.gForgotViewModel, responseMsg) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[self keyTool] hideKeyboard];
        SQToastBottom(x);
    }];
    [[RACObserve(self.gForgotViewModel, responseCode) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.contentView startTimer];
    }];
    
    [[RACObserve(self.gForgotViewModel, errorModel) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[self keyTool] hideKeyboard];
        SQToastBottom(kNoNetAlert);
    }];
}

-(WVRForgotPWViewModel *)gForgotViewModel
{
    if (!_gForgotViewModel) {
        _gForgotViewModel = [[WVRForgotPWViewModel alloc] init];
    }
    return _gForgotViewModel;
}

- (void)sendSMSForFindOldPW
{
    NSString *phoneNum = [self.contentView getPhoneNum];
    [[self keyTool] hideKeyboard];
    if (![WVRGlobalUtil validateMobileNumber:phoneNum])
    {
        SQToastBottom(@" 请输入正确手机号");
        return;
    }
    [self showProgress];
//    [self httpUser:phoneNum];
    self.gForgotViewModel.inputPhoneNum = phoneNum;
    [[self.gForgotViewModel sendCodeCmd] execute:nil];
}

-(void)loginBtnOnClickFindOldPassword
{
    NSString *phoneNum = [self.contentView getPhoneNum];
    NSString *securityCode = [self.contentView getSecurityCode];
    NSString *captcha = [self.contentView getCaptcha];
    [[self keyTool] hideKeyboard];
    if (![WVRGlobalUtil validateMobileNumber:phoneNum])
    {
        [self showMessageToWindow:@"请输入正确手机号"];
        return;
    }
    
    if (!self.contentView.verifyCodeViewIsHidden) {
        if ([WVRGlobalUtil isEmpty:captcha]) {
            SQToastBottom(@"请输入验证码");
            return;
        }
    }
    
    if (self.codeHasbeenGot) {
        
        if ([WVRGlobalUtil isEmpty:securityCode])
        {
            SQToastBottom(@"请输入安全码");
            return;
        }
        
        self.gForgotViewModel.inputCode = [self.contentView getSecurityCode];
        
        [[self.gForgotViewModel validCmd] execute:nil];
//        [self httpForgotPWValidateCode];
        
    }else{
        
        SQToastBottom(@"请获取安全码");
        return;
    }
    
}

-(void)httpForgotPWSMSCodeSuccessBlock:(NSString*)successStr
{
    [self hideProgress];
    self.codeHasbeenGot = YES;
    [self.contentView startTimer];
}


-(void)httpForgotPWValidateCodeSuccessBlock:(NSString*)successStr
{
    NSString *securityCode = [self.contentView getSecurityCode];
    WVRModifyPasswordViewController *modifyPasswordVC = [[WVRModifyPasswordViewController alloc] init];
    modifyPasswordVC.isFindOldPWMode = YES;
    modifyPasswordVC.smsCode = securityCode;
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
    
}

@end

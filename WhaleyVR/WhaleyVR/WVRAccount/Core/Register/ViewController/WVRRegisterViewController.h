//
//  WVRRegisterViewController.h
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRBaseUserController.h"
#import "WVRRegisterView.h"

@interface WVRRegisterViewController : WVRBaseUserController

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) WVRRegisterViewStyle viewStyle;
@property (nonatomic, strong) WVRRegisterView *contentView;
@property (nonatomic, assign) BOOL codeHasbeenGot;
@property (nonatomic, strong) NSString *captcha;

@property (nonatomic, copy) NSString *phoneNum;

- (void)requestFaild:(NSString *)errorStr;

- (void)httpSMSLoginWithOpenId:(NSString *)openId;


-(BOOL)checkParmasValid;
//sms find old pw
- (void)sendSMSForFindOldPW;
- (void)loginBtnOnClickFindOldPassword;

//bind whaley acoount
- (void)loginBtnInputPhoneNumAndPDForThirdPartyBind;

//login with name and pw
- (void)loginBtnOnClickInputNameAndPD;

- (BOOL)isNewUserWithRegType:(NSString*) regType userName:(NSString*) userName;

- (void)initRegisterRAC;
@end

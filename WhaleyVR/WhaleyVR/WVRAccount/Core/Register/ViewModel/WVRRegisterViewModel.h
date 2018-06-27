//
//  WVRRegisterViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "RACCommand.h"
#import "WVRModelUserInfo.h"
#import "WVRThirtyPLoginModel.h"

@interface WVRRegisterViewModel : WVRViewModel

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSString * inputCaptcha;
@property (nonatomic, strong) NSString * responseCaptcha;
@property (nonatomic, strong) NSString * responseMsg;
@property (nonatomic, strong) NSString * responseCode;

@property (nonatomic, assign) NSInteger origin;

@property(nonatomic, strong) WVRModelUserInfo *userInfo;

@property (nonatomic, strong) WVRThirtyPLoginModel * tpLoginModel;

@property (nonatomic, strong) NSString * reg_type;

- (RACCommand *)sendCodeCmd;

- (RACCommand *)registerCmd;

- (RACCommand *)thirtyPartyLoginCmd;
@end

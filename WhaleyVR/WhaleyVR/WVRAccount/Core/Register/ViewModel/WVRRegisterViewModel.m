//
//  WVRRegisterViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRegisterViewModel.h"
#import "WVRUserModel.h"
#import "WVRRegisterUseCase.h"
#import "WVRThirtyPLoginUseCase.h"
#import "WVRThirtyPLoginModel.h"
#import "WVRSendPhoneCodeUseCase.h"
#import "WVRGetPhoneCodeTokenUseCase.h"

@interface WVRRegisterViewModel ()

@property (nonatomic, strong) WVRRegisterUseCase * gRegisterUC;

@property (nonatomic, strong) WVRThirtyPLoginUseCase * gTPLoginUC;

@property (nonatomic, strong) WVRSendPhoneCodeUseCase * gSendPCodeUC;

@property (nonatomic, strong) WVRGetPhoneCodeTokenUseCase * gGetCodeTokenUC;

@end
@implementation WVRRegisterViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

-(WVRRegisterUseCase *)gRegisterUC
{
    if (!_gRegisterUC) {
        _gRegisterUC = [[WVRRegisterUseCase alloc] init];
    }
    return _gRegisterUC;
}

-(WVRThirtyPLoginUseCase *)gTPLoginUC
{
    if (!_gTPLoginUC) {
        _gTPLoginUC = [[WVRThirtyPLoginUseCase alloc] init];
    }
    return _gTPLoginUC;
}

-(WVRSendPhoneCodeUseCase *)gSendPCodeUC
{
    if (!_gSendPCodeUC) {
        _gSendPCodeUC = [[WVRSendPhoneCodeUseCase alloc] init];
    }
    return _gSendPCodeUC;
}

-(WVRGetPhoneCodeTokenUseCase *)gGetCodeTokenUC
{
    if (!_gGetCodeTokenUC) {
        _gGetCodeTokenUC = [[WVRGetPhoneCodeTokenUseCase alloc] init];
    }
    return _gGetCodeTokenUC;
}

- (void)setupRAC {
    @weakify(self);
    RAC(self.gSendPCodeUC, mobile) = RACObserve(self, mobile);
    RAC(self.gSendPCodeUC, inputCaptcha) = RACObserve(self, inputCaptcha);
    RAC(self.gSendPCodeUC, smsToken) = RACObserve(self.gGetCodeTokenUC, smsToken);
//    RACObserve(self.gSendPCodeUC, <#KEYPATH#>)
    [[self.gSendPCodeUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
        @strongify(self);
        NSInteger code = [value.content[@"code"] integerValue];
        NSString *msg = value.content[@"msg"];
        NSDictionary *dataDic = value.content[@"data"];
        
        if (141 == code)
        {
            self.responseCaptcha = (NSString *)[dataDic objectForKey:@"url"];
            msg = @"请输入图形验证码";
            
        } else if (000 == code)
        {
            msg = @"安全码发送成功";
            self.responseCode = [NSString stringWithFormat:@"%d",(int)code];
        } else if(103 == code)
        {
            msg = @"验证码验证失败";
        }else if(101 == code){
            msg = @"图形验证码验证失败";
        }
        self.responseMsg = msg;
    }];
    [[self.gGetCodeTokenUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[self.gSendPCodeUC getRequestCmd] execute:nil];
    }];
    RAC(self.gRegisterUC, mobile) = RACObserve(self, mobile);
    RAC(self.gRegisterUC, code) = RACObserve(self, code);
    
    [[self.gRegisterUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
        @strongify(self);
        NSInteger code = [value.content[@"code"] integerValue];
        NSString *msg = value.content[@"msg"];
        NSDictionary *dataDic = value.content[@"data"];
        if (000 == code)
        {
            WVRModelUserInfo* modelUserInfo = [WVRModelUserInfo yy_modelWithDictionary:dataDic];
            
            if (modelUserInfo.username)
                [WVRUserModel sharedInstance].username = modelUserInfo.username;
            if (modelUserInfo.heliosid || modelUserInfo.account_id)
                [WVRUserModel sharedInstance].accountId = modelUserInfo.heliosid.length > 0 ? modelUserInfo.heliosid : modelUserInfo.account_id;
            if (modelUserInfo.accesstoken)
                [WVRUserModel sharedInstance].sessionId = modelUserInfo.accesstoken;
            if (modelUserInfo.expiretime)
                [WVRUserModel sharedInstance].expiration_time = modelUserInfo.expiretime;
            if (modelUserInfo.refreshtoken)
                [WVRUserModel sharedInstance].refreshtoken = modelUserInfo.refreshtoken;
            if (modelUserInfo.mobile)
                [WVRUserModel sharedInstance].mobileNumber = modelUserInfo.mobile;
            if (modelUserInfo.avatar)
                [WVRUserModel sharedInstance].loginAvatar = modelUserInfo.avatar;
            self.reg_type = dataDic[@"reg_type"];
            [WVRUserModel sharedInstance].isLogined = YES;
            [WVRUserModel sharedInstance].firstLogin = YES;
        }else if (104 == code){
            msg = @"安全码错误";
            self.responseMsg = msg;
        }else{
            self.responseMsg = msg;
        }
    }];
    
    [[self.gRegisterUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
    

    RAC(self.gTPLoginUC, origin) = RACObserve(self, origin);
    [[RACObserve(self, origin) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gTPLoginUC.origin = self.origin;
        [[self thirtyPartyLoginCmd] execute:nil];
    }];
    [[self.gTPLoginUC buildUseCase] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[WVRThirtyPLoginModel class]]) {
            self.tpLoginModel = x;
        } else if ([x isKindOfClass:[WVRModelUserInfo class]]) {
            self.userInfo = x;
        } else {
            WVRNetworkingResponse* value = x;
//            NSInteger code = [value.content[@"code"] integerValue];
            NSString *msg = value.content[@"msg"];
//            if (104 == code)
//            {
//                msg = @"验证码错误";
//                
//            }
            self.responseMsg = msg;
        }
    }];
    [[self.gTPLoginUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
}



- (RACCommand *)sendCodeCmd
{
    return [self.gGetCodeTokenUC getRequestCmd];
}


- (RACCommand *)registerCmd
{
    return [self.gRegisterUC getRequestCmd];
}

- (RACCommand *)thirtyPartyLoginCmd {
    return [self.gTPLoginUC getRequestCmd];
}

@end

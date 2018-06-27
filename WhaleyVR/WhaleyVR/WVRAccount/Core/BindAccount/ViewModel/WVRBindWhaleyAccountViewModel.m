//
//  WVRBindWhaleyAccountViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBindWhaleyAccountViewModel.h"
#import "WVRBindWhaleyAccountUseCase.h"
//#import "WVRThirtyPUNBindUseCase.h"
#import "WVRSendPhoneCodeUseCase.h"
#import "WVRGetPhoneCodeTokenUseCase.h"
#import "WVRRegisterUseCase.h"

@interface WVRBindWhaleyAccountViewModel ()

@property (nonatomic, strong) WVRSendPhoneCodeUseCase * gSendPCodeUC;

@property (nonatomic, strong) WVRGetPhoneCodeTokenUseCase * gGetCodeTokenUC;

@property (nonatomic, strong) WVRBindWhaleyAccountUseCase * gBindWhaleyAUC;

@property (nonatomic, strong) WVRRegisterUseCase * gRegisterUC;


@end

@implementation WVRBindWhaleyAccountViewModel

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

-(WVRBindWhaleyAccountUseCase *)gBindWhaleyAUC
{
    if (!_gBindWhaleyAUC) {
        _gBindWhaleyAUC = [[WVRBindWhaleyAccountUseCase alloc] init];
    }
    return _gBindWhaleyAUC;
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
            msg = @"图形验证码验证码失败";
        }else if(101 == code)
        {
            msg = @"图形验证码错误";
        }
        self.responseMsg = msg;
    }];
    [[self.gGetCodeTokenUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[self.gSendPCodeUC getRequestCmd] execute:nil];
    }];
    
    RAC(self.gBindWhaleyAUC, origin) = RACObserve(self, origin);
    RAC(self.gBindWhaleyAUC, unionId) = RACObserve(self, unionId);
    RAC(self.gBindWhaleyAUC, openId) = RACObserve(self, openId);
    RAC(self.gBindWhaleyAUC, nickName) = RACObserve(self, nickName);
    RAC(self.gBindWhaleyAUC, avatar) = RACObserve(self, avatar);
    RAC(self.gBindWhaleyAUC, thirdId) = RACObserve(self, thirdId);
    [[self.gBindWhaleyAUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
        @strongify(self);
//        self.bind = YES;
        NSInteger code = [value.content[@"code"] integerValue];
        NSString *msg = value.content[@"msg"];
        NSDictionary *dataDic = value.content[@"data"];
        if (000 == code)
        {
            self.reg_type = dataDic[@"reg_type"];
        }else{
            self.responseMsg = msg;
        }
        
    }];
    
    [[self.gBindWhaleyAUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
    
    
    
    RAC(self.gRegisterUC, mobile) = RACObserve(self, mobile);
    RAC(self.gRegisterUC, code) = RACObserve(self, code);
    RAC(self.gRegisterUC, thirdId) = RACObserve(self.gBindWhaleyAUC, thirdId);
    [[RACObserve(self, thirdId) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gRegisterUC.thirdId = self.thirdId;
    }];
    
    [[self.gRegisterUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
        @strongify(self);
        NSInteger code = [value.content[@"code"] integerValue];
        NSString *msg = value.content[@"msg"];
        NSDictionary *dataDic = value.content[@"data"];
        if (000 == code)
        {
            self.reg_type = dataDic[@"reg_type"];
//            [[self bindAccountCmd] execute:nil];
        }else if(code == 104){
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
}

-(RACCommand*)sendCodeCmd
{
    return [self.gGetCodeTokenUC getRequestCmd];
}

- (RACCommand *)bindAccountCmd {
    return [self.gBindWhaleyAUC getRequestCmd];
}

-(RACCommand*)bindCmd
{
    return [self.gRegisterUC getRequestCmd];
}


@end

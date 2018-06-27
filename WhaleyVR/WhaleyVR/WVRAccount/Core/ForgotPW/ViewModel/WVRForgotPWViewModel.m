//
//  WVRForgotPWViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRForgotPWViewModel.h"
#import "WVRForgotPWSendCodeUseCase.h"
#import "WVRForgotPWValidCodeUseCase.h"
#import "WVRGetPhoneUserInfoUseCase.h"

@interface WVRForgotPWViewModel ()

@property (nonatomic, strong) WVRGetPhoneUserInfoUseCase * gGetPhoneUInfoUC;
@property (nonatomic, strong) WVRForgotPWSendCodeUseCase * gSendPCodeUC;
@property (nonatomic, strong) WVRForgotPWValidCodeUseCase * gValidCodeUC;

@property (nonatomic, strong) RACSubject * gSendPcodeSubject;
@property (nonatomic, strong) RACSubject * gValidCodeSubject;

@end
@implementation WVRForgotPWViewModel
@synthesize gSendCodeCompleteSignal = _gSendCodeCompleteSignal;
@synthesize gValidCodeCompleteSignal = _gValidCodeCompleteSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

-(WVRGetPhoneUserInfoUseCase *)gGetPhoneUInfoUC
{
    if (!_gGetPhoneUInfoUC) {
        _gGetPhoneUInfoUC = [[WVRGetPhoneUserInfoUseCase alloc] init];
    }
    return _gGetPhoneUInfoUC;
}

-(WVRForgotPWSendCodeUseCase *)gSendPCodeUC
{
    if (!_gSendPCodeUC) {
        _gSendPCodeUC = [[WVRForgotPWSendCodeUseCase alloc] init];
    }
    return _gSendPCodeUC;
}

-(WVRForgotPWValidCodeUseCase *)gValidCodeUC
{
    if (!_gValidCodeUC) {
        _gValidCodeUC = [[WVRForgotPWValidCodeUseCase alloc] init];
    }
    return _gValidCodeUC;
}


- (void)setupRAC {
    @weakify(self);
    RAC(self.gGetPhoneUInfoUC, inputPhoneNum) = RACObserve(self, inputPhoneNum);
    [[self.gGetPhoneUInfoUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[self.gSendPCodeUC getRequestCmd] execute:nil];
    }];
    [[self.gGetPhoneUInfoUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
    RAC(self.gSendPCodeUC, inputPhoneNum) = RACObserve(self, inputPhoneNum);
    
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
            [self.gSendPcodeSubject sendNext:msg];
        } else if(103 == code)
        {
            msg = @"验证码验证失败";
        }else if(101 == code){
            msg = @"图形验证码验证失败";
        }
        self.responseMsg = msg;
        
    }];
    [[self.gSendPCodeUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
    
    
    RAC(self.gValidCodeUC, inputCode) = RACObserve(self, inputCode);
    
    [[self.gValidCodeUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
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
//            msg = @"安全码验证成功";
            self.responseCode = [NSString stringWithFormat:@"%d",(int)code];
            [self.gValidCodeSubject sendNext:msg];
            return ;
        } else if(103 == code)
        {
            msg = @"验证码验证失败";
        }else if(101 == code){
            msg = @"图形验证码验证失败";
        }
        self.responseMsg = msg;
        
    }];
    
    [[self.gValidCodeUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
}

-(RACSignal *)gSendCodeCompleteSignal
{
    if (!_gSendCodeCompleteSignal) {
        @weakify(self);
        _gSendCodeCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gSendPcodeSubject = subscriber;
            return nil;
        }];
    }
    return _gSendCodeCompleteSignal;
}

-(RACSignal *)gValidCodeCompleteSignal
{
    if (!_gValidCodeCompleteSignal) {
        @weakify(self);
        _gValidCodeCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gValidCodeSubject = subscriber;
            return nil;
        }];
    }
    return _gValidCodeCompleteSignal;
}

-(RACCommand*)sendCodeCmd
{
    return [self.gGetPhoneUInfoUC getRequestCmd];
}


-(RACCommand*)validCmd
{
    return [self.gValidCodeUC getRequestCmd];
}


@end

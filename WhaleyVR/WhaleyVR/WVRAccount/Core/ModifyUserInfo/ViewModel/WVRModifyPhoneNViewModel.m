//
//  WVRModifyPhoneNViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModifyPhoneNViewModel.h"
#import "WVRModifyPhoneNUseCase.h"
#import "WVRUpdatePhoneSMSUseCase.h"
#import "WVRGetPhoneCodeTokenUseCase.h"
#import "WVRValidatePhoneUseCase.h"

@interface WVRModifyPhoneNViewModel ()

@property (nonatomic, strong) WVRValidatePhoneUseCase * gValidatePhoneUC;

@property (nonatomic, strong) WVRModifyPhoneNUseCase * gMPhoneNUC;


@property (nonatomic, strong) WVRUpdatePhoneSMSUseCase * gUpdatePSMSUC;

@property (nonatomic, strong) WVRGetPhoneCodeTokenUseCase * gGetCodeTokenUC;


@property (nonatomic, strong) RACSubject * gCompleteSubject;

@end
@implementation WVRModifyPhoneNViewModel
@synthesize completeSignal = _completeSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRValidatePhoneUseCase *)gValidatePhoneUC
{
    if (!_gValidatePhoneUC) {
        _gValidatePhoneUC = [[WVRValidatePhoneUseCase alloc] init];
    }
    return _gValidatePhoneUC;
}

-(WVRModifyPhoneNUseCase *)gMPhoneNUC
{
    if (!_gMPhoneNUC) {
        _gMPhoneNUC = [[WVRModifyPhoneNUseCase alloc] init];
    }
    return _gMPhoneNUC;
}

-(WVRUpdatePhoneSMSUseCase *)gUpdatePSMSUC
{
    if (!_gUpdatePSMSUC) {
        _gUpdatePSMSUC = [[WVRUpdatePhoneSMSUseCase alloc] init];
    }
    return _gUpdatePSMSUC;
}

-(WVRGetPhoneCodeTokenUseCase *)gGetCodeTokenUC
{
    if (!_gGetCodeTokenUC) {
        _gGetCodeTokenUC = [[WVRGetPhoneCodeTokenUseCase alloc] init];
    }
    return _gGetCodeTokenUC;
}

-(void)setUpRAC
{
    @weakify(self);
    RAC(self.gValidatePhoneUC, inputPhoneNum) = RACObserve(self, inputPhoneNum);
    
    [[self.gValidatePhoneUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
        @strongify(self);
        if (![value.content[@"code"] isEqualToString:@"000"]) {
            self.responseMsg = value.content[@"msg"];
        }else{
            [[self sendCodeCmd] execute:nil];
        }
    }];
    [[self.gValidatePhoneUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[WVRErrorViewModel class]]) {
            self.responseMsg = [(WVRErrorViewModel*)x errorMsg];
        }else if ([x isKindOfClass:[NSString class]]) {
            self.responseMsg = x;
        }else{
            self.responseMsg = kNoNetAlert;
        }
    }];
    
    RAC(self.gMPhoneNUC, inputCode) = RACObserve(self, inputCode);
    RAC(self.gMPhoneNUC, inputPhoneNum) = RACObserve(self, inputPhoneNum);
    
    
    [[self.gMPhoneNUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
        @strongify(self);
        if (![value.content[@"code"] isEqualToString:@"000"]) {
            self.responseMsg = value.content[@"msg"];
        }else{
            [self.gCompleteSubject sendNext:value.content[@"msg"]];
        }
    }];
    [[self.gMPhoneNUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[WVRErrorViewModel class]]) {
            self.responseMsg = [(WVRErrorViewModel*)x errorMsg];
        }else if ([x isKindOfClass:[NSString class]]) {
            self.responseMsg = x;
        }else{
            self.responseMsg = kNoNetAlert;
        }
        
    }];
    
    RAC(self.gUpdatePSMSUC, inputPhoneNum) = RACObserve(self, inputPhoneNum);
    RAC(self.gUpdatePSMSUC, inputCaptcha) = RACObserve(self, inputCaptcha);
    RAC(self.gUpdatePSMSUC, smsToken) = RACObserve(self.gGetCodeTokenUC, smsToken);
    
    [[self.gUpdatePSMSUC buildUseCase] subscribeNext:^(WVRNetworkingResponse* value) {
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
        [[self.gUpdatePSMSUC getRequestCmd] execute:nil];
    }];
}


-(RACSignal *)completeSignal
{
    if (!_completeSignal) {
        @weakify(self);
        _completeSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _completeSignal;
}

-(RACCommand*)modifyPhoneCmd
{
    return [self.gMPhoneNUC getRequestCmd];
}

- (RACCommand *)sendCodeCmd
{
    return [self.gGetCodeTokenUC getRequestCmd];
}

- (RACCommand *)validateCmd
{
    return [self.gValidatePhoneUC getRequestCmd];
}
@end

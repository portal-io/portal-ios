//
//  WVRModifyPWViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModifyPWViewModel.h"
#import "WVRModifyPWUseCase.h"
#import "WVRForgotPWUseCase.h"
#import "WVRErrorViewModel.h"

@interface WVRModifyPWViewModel ()

@property (nonatomic, strong) WVRModifyPWUseCase * gModifyPWUC;
@property (nonatomic, strong) RACSubject * gMCompleteSubject;
@property (nonatomic, strong) RACSubject * gMFailSubject;

@property (nonatomic, strong) WVRForgotPWUseCase * gForgotPWUC;
@property (nonatomic, strong) RACSubject * gFCompleteSubject;
@property (nonatomic, strong) RACSubject * gFFailSubject;

@end

@implementation WVRModifyPWViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;
@synthesize fCompleteSignal = _fCompleteSignal;
@synthesize fFailSignal = _fFailSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRModifyPWUseCase *)gModifyPWUC
{
    if (!_gModifyPWUC) {
        _gModifyPWUC = [[WVRModifyPWUseCase alloc] init];
    }
    return _gModifyPWUC;
}

-(WVRForgotPWUseCase *)gForgotPWUC
{
    if (!_gForgotPWUC) {
        _gForgotPWUC = [[WVRForgotPWUseCase alloc] init];
    }
    return _gForgotPWUC;
}

-(void)setUpRAC
{
    RAC(self.gModifyPWUC, oldPW) = RACObserve(self, oldPW);
    RAC(self.gModifyPWUC, inputPW) = RACObserve(self, inputPW);
    @weakify(self);
    [[self.gModifyPWUC buildUseCase] subscribeNext:^(WVRNetworkingResponse*  _Nullable x) {
        @strongify(self);
        if ([x.content[@"code"] isEqualToString:@"000"]) {
            [self.gMCompleteSubject sendNext:x.content[@"msg"]];
        }else{
            [self.gMFailSubject sendNext:x.content[@"msg"]];
        }
        
    }];
    [[self.gModifyPWUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        [self.gMFailSubject sendNext:x.errorMsg];
    }];
    
    RAC(self.gForgotPWUC, inputCode) = RACObserve(self, inputCode);
    RAC(self.gForgotPWUC, inputPW) = RACObserve(self, inputPW);
    
    [[self.gForgotPWUC buildUseCase] subscribeNext:^(WVRNetworkingResponse*  _Nullable x) {
        @strongify(self);
        if ([x.content[@"code"] isEqualToString:@"000"]) {
            [self.gFCompleteSubject sendNext:x.content[@"msg"]];
        }else{
            [self.gFFailSubject sendNext:x.content[@"msg"]];
        }
    }];
    [[self.gForgotPWUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        [self.gFFailSubject sendNext:x.errorMsg];
    }];
}

-(RACSignal *)mCompleteSignal
{
    if (!_mCompleteSignal) {
        @weakify(self);
        _mCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gMCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _mCompleteSignal;
}

-(RACSignal *)mFailSignal
{
    if (!_mFailSignal) {
        @weakify(self);
        _mFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gMFailSubject = subscriber;
            return nil;
        }];
    }
    return _mFailSignal;
}

-(RACSignal *)fCompleteSignal
{
    if (!_fCompleteSignal) {
        @weakify(self);
        _fCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gFCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _fCompleteSignal;
}

-(RACSignal *)fFailSignal
{
    if (!_fFailSignal) {
        @weakify(self);
        _fFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gFFailSubject = subscriber;
            return nil;
        }];
    }
    return _fFailSignal;
}

-(RACCommand*)modifyPWCmd
{
    return [self.gModifyPWUC getRequestCmd];
}

-(RACCommand*)forgotPWCmd
{
    return [self.gForgotPWUC getRequestCmd];
}

@end

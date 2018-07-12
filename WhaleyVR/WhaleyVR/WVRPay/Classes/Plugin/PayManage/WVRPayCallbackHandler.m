//
//  WVRPayCallbackHandler.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPayCallbackHandler.h"
#import "WVRPayCallbackUseCase.h"

@interface WVRPayCallbackHandler ()

@property (nonatomic, strong) WVRPayCallbackUseCase * gPayCallbackUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end

@implementation WVRPayCallbackHandler
@synthesize successSignal = _successSignal;
@synthesize failSignal = _failSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self installRAC];
    }
    return self;
}

-(void)installRAC
{
    RAC(self.gPayCallbackUC, orderNo) = RACObserve(self, orderNo);
    RAC(self.gPayCallbackUC, payMethod) = RACObserve(self, payMethod);
    @weakify(self);
    [[self.gPayCallbackUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gSuccessSubject sendNext:x];
    }];
    [[self.gPayCallbackUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
    }];
    
}

-(WVRPayCallbackUseCase *)gPayCallbackUC
{
    if (!_gPayCallbackUC) {
        _gPayCallbackUC = [[WVRPayCallbackUseCase alloc] init];
    }
    return _gPayCallbackUC;
}

-(RACCommand *)payCallbackCmd
{
    return [self.gPayCallbackUC payCallbackCmd];
}

-(RACSignal *)successSignal
{
    if (!_successSignal) {
        @weakify(self);
        _successSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gSuccessSubject = subscriber;
            return nil;
        }];
    }
    return _successSignal;
}

-(RACSignal *)failSignal
{
    if(!_failSignal){
        @weakify(self);
        _failSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gFailSubject = subscriber;
            return nil;
        }];
    }
    return _failSignal;
}
@end

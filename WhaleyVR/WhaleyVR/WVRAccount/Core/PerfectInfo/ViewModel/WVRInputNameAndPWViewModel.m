//
//  WVRInputNameAndPWViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRInputNameAndPWViewModel.h"
#import "WVRFinishNamePWUseCase.h"

@interface WVRInputNameAndPWViewModel()

@property (nonatomic, strong) WVRFinishNamePWUseCase * gFinishNamePWUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;

@end

@implementation WVRInputNameAndPWViewModel
@synthesize completeSignal = _completeSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(WVRFinishNamePWUseCase *)gFinishNamePWUC
{
    if(!_gFinishNamePWUC){
        _gFinishNamePWUC = [[WVRFinishNamePWUseCase alloc] init];
    }
    return _gFinishNamePWUC;
}

-(void)setUp
{
    RAC(self.gFinishNamePWUC, nickName) = RACObserve(self, nickName);
    RAC(self.gFinishNamePWUC, password) = RACObserve(self, password);
    @weakify(self);
    [[self.gFinishNamePWUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gFinishNamePWUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        SQToastInKeyWindow(x.errorMsg);
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

-(RACCommand*)finishNamePWCmd
{
    return [self.gFinishNamePWUC getRequestCmd];
}
@end

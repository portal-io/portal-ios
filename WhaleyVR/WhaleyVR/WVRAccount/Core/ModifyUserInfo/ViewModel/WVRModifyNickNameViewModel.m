//
//  WVRModifyNickNameViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRModifyNickNameViewModel.h"
#import "WVRModifyNickNameUseCase.h"

@interface WVRModifyNickNameViewModel ()

@property (nonatomic, strong) WVRModifyNickNameUseCase * gMNickNameUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;

@end
@implementation WVRModifyNickNameViewModel
@synthesize completeSignal = _completeSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRModifyNickNameUseCase *)gMNickNameUC
{
    if (!_gMNickNameUC) {
        _gMNickNameUC = [[WVRModifyNickNameUseCase alloc] init];
    }
    return _gMNickNameUC;
}

-(void)setUpRAC
{
    RAC(self.gMNickNameUC, nickName) = RACObserve(self, nickName);
    @weakify(self);
    [[self.gMNickNameUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gMNickNameUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[WVRErrorViewModel class]]) {
            self.responseMsg = [(WVRErrorViewModel*)x errorMsg];
        }else if ([x isKindOfClass:[NSString class]]) {
            self.responseMsg = x;
        }else{
            self.responseMsg = kNoNetAlert;
        }
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

-(RACCommand*)modifyNickNameCmd
{
    return [self.gMNickNameUC getRequestCmd];
}
@end

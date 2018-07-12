//
//  WVRUserRedeemCodeViewModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUserRedeemCodeViewModel.h"
#import "WVRUserRedeemCodeUseCase.h"

@interface WVRUserRedeemCodeViewModel ()

@property (nonatomic, strong) WVRUserRedeemCodeUseCase * redeemCodeUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end

@implementation WVRUserRedeemCodeViewModel
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self installRAC];
    }
    return self;
}

- (WVRUserRedeemCodeUseCase *)redeemCodeUC
{
    if (!_redeemCodeUC) {
        _redeemCodeUC = [[WVRUserRedeemCodeUseCase alloc] init];
    }
    return _redeemCodeUC;
}

- (void)installRAC {
    
    @weakify(self);
    [[self.redeemCodeUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        if (x) {
            [self.gSuccessSubject sendNext:x];
        } else {
            [self.gFailSubject sendNext:nil];
        }
    }];
    [[self.redeemCodeUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
    }];
}

- (RACSignal *)gSuccessSignal
{
    if (!_gSuccessSignal) {
        @weakify(self);
        _gSuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gSuccessSubject = subscriber;
            return nil;
        }];
    }
    return _gSuccessSignal;
}

- (RACSignal *)gFailSignal
{
    if (!_gFailSignal) {
        @weakify(self);
        _gFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gFailSubject = subscriber;
            return nil;
        }];
    }
    return _gFailSignal;
}

- (RACCommand *)requestCmd
{
    return self.redeemCodeUC.getRequestCmd;
}

@end

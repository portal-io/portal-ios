//
//  WVRTopBarViewModel.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRTopBarViewModel.h"
#import "WVRHomeTopBarListUseCase.h"

@interface WVRTopBarViewModel ()

@property (nonatomic, strong) WVRHomeTopBarListUseCase * gHomeTBarListUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRTopBarViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

- (WVRHomeTopBarListUseCase *)gHomeTBarListUC
{
    if (!_gHomeTBarListUC) {
        _gHomeTBarListUC = [[WVRHomeTopBarListUseCase alloc] init];
    }
    return _gHomeTBarListUC;
}


- (void)setUpRAC
{
    RAC(self.gHomeTBarListUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gHomeTBarListUC buildUseCase] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gHomeTBarListUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
        
    }];
    
}

- (RACSignal *)mCompleteSignal
{
    if (!_mCompleteSignal) {
        @weakify(self);
        _mCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _mCompleteSignal;
}

- (RACSignal *)mFailSignal
{
    if (!_mFailSignal) {
        @weakify(self);
        _mFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gFailSubject = subscriber;
            return nil;
        }];
    }
    return _mFailSignal;
}

- (RACCommand*)getTopBarListCmd
{
    return [self.gHomeTBarListUC getRequestCmd];
}

@end

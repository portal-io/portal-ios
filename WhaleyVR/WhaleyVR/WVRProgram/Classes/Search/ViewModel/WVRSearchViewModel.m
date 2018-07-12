//
//  WVRSearchViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSearchViewModel.h"
#import "WVRSearchUseCase.h"

@interface WVRSearchViewModel()

@property (nonatomic, strong) WVRSearchUseCase * gSearchUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRSearchViewModel
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

- (WVRSearchUseCase *)gSearchUC
{
    if (!_gSearchUC) {
        _gSearchUC = [[WVRSearchUseCase alloc] init];
    }
    return _gSearchUC;
}


- (void)setUpRAC
{
    RAC(self.gSearchUC, keyWord) = RACObserve(self, keyWord);
    RAC(self.gSearchUC, type) = RACObserve(self, type);
    @weakify(self);
    [[self.gSearchUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gSearchUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x.errorMsg];
        
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

- (RACCommand *)getSearchCmd
{
    return [self.gSearchUC getRequestCmd];
}

@end

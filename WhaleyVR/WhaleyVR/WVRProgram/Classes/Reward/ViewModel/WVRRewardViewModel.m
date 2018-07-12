//
//  WVREditAddressViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRewardViewModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRItemModel.h"
#import "WVRRewardUseCase.h"
#import "WVRErrorViewModel.h"


@interface WVRRewardViewModel ()

@property (nonatomic, strong) WVRRewardUseCase * gRewardUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRRewardViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRRewardUseCase *)gRewardUC
{
    if (!_gRewardUC) {
        _gRewardUC = [[WVRRewardUseCase alloc] init];
    }
    return _gRewardUC;
}


-(void)setUpRAC
{
    @weakify(self);
    [[self.gRewardUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gRewardUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x.errorMsg];
        
    }];
    
}

-(RACSignal *)mCompleteSignal
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

-(RACSignal *)mFailSignal
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

-(RACCommand*)getRewardCmd
{
    return [self.gRewardUC getRequestCmd];
}

@end

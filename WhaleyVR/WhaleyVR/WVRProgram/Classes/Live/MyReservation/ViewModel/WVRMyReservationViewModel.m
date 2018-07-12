//
//  WVRAllChannelViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyReservationViewModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRItemModel.h"
#import "WVRMyReservationUseCase.h"
#import "WVRErrorViewModel.h"

@interface WVRMyReservationViewModel ()

@property (nonatomic, strong) WVRMyReservationUseCase * gMyReservationUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRMyReservationViewModel
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

-(WVRMyReservationUseCase *)gMyReservationUC
{
    if (!_gMyReservationUC) {
        _gMyReservationUC = [[WVRMyReservationUseCase alloc] init];
    }
    return _gMyReservationUC;
}


-(void)setUpRAC
{
    @weakify(self);
    [[self.gMyReservationUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gMyReservationUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getMyReservationCmd
{
    return [self.gMyReservationUC getRequestCmd];
}

@end

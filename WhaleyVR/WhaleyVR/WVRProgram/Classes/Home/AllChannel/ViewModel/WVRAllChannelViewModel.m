//
//  WVRAllChannelViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelViewModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRItemModel.h"
#import "WVRAllChannelUseCase.h"
#import "WVRErrorViewModel.h"

@interface WVRAllChannelViewModel ()

@property (nonatomic, strong) WVRAllChannelUseCase * gAllChannelUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRAllChannelViewModel
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

-(WVRAllChannelUseCase *)gAllChannelUC
{
    if (!_gAllChannelUC) {
        _gAllChannelUC = [[WVRAllChannelUseCase alloc] init];
    }
    return _gAllChannelUC;
}


-(void)setUpRAC
{
    @weakify(self);
    [[self.gAllChannelUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gAllChannelUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getAllChannelCmd
{
    return [self.gAllChannelUC getRequestCmd];
}

@end

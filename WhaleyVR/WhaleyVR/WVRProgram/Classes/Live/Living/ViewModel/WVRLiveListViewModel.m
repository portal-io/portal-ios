//
//  WVRAllChannelViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveListViewModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRItemModel.h"
#import "WVRLiveListUseCase.h"
#import "WVRErrorViewModel.h"

@interface WVRLiveListViewModel ()

@property (nonatomic, strong) WVRLiveListUseCase * gLiveListUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRLiveListViewModel
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

-(WVRLiveListUseCase *)gLiveListUC
{
    if (!_gLiveListUC) {
        _gLiveListUC = [[WVRLiveListUseCase alloc] init];
    }
    return _gLiveListUC;
}


-(void)setUpRAC
{
    @weakify(self);
    [[self.gLiveListUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gLiveListUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getLiveListCmd
{
    return [self.gLiveListUC getRequestCmd];
}

@end

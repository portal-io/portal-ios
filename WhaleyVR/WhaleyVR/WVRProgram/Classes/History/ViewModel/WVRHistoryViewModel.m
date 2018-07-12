//
//  WVRHistoryViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHistoryViewModel.h"
#import "WVRHistoryUseCase.h"
#import "WVRHistoryDelUseCase.h"
#import "WVRHistoryDelAllUseCase.h"


@interface WVRHistoryViewModel ()
@property (nonatomic, strong) WVRHistoryUseCase * gHistoryUC;
@property (nonatomic, strong) WVRHistoryDelUseCase * gHistoryDelUC;
@property (nonatomic, strong) WVRHistoryDelAllUseCase * gHistoryDelAllUC;

@property (nonatomic, strong) RACSubject * gHistoryCompleteSubject;
@property (nonatomic, strong) RACSubject * gHistoryFailSubject;

@property (nonatomic, strong) RACSubject * gHistoryDelCompleteSubject;
@property (nonatomic, strong) RACSubject * gHistoryDelFailSubject;

@property (nonatomic, strong) RACSubject * gHistoryDelAllCompleteSubject;
@property (nonatomic, strong) RACSubject * gHistoryDelAllFailSubject;


@end
@implementation WVRHistoryViewModel
@synthesize gHistoryCompleteSignal = _gHistoryCompleteSignal;
@synthesize gHistoryFailSignal = _gHistoryFailSignal;

@synthesize gHistoryDelCompleteSignal = _gHistoryDelCompleteSignal;
@synthesize gHistoryDelFailSignal = _gHistoryDelFailSignal;

@synthesize gHistoryDelAllCompleteSignal = _gHistoryDelAllCompleteSignal;
@synthesize gHistoryDelAllFailSignal = _gHistoryDelAllFailSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

-(WVRHistoryUseCase *)gHistoryUC
{
    if (!_gHistoryUC) {
        _gHistoryUC = [[WVRHistoryUseCase alloc] init];
    }
    return _gHistoryUC;
}

-(WVRHistoryDelUseCase *)gHistoryDelUC
{
    if (!_gHistoryDelUC) {
        _gHistoryDelUC = [[WVRHistoryDelUseCase alloc] init];
    }
    return _gHistoryDelUC;
}

-(WVRHistoryDelAllUseCase *)gHistoryDelAllUC
{
    if (!_gHistoryDelAllUC) {
        _gHistoryDelAllUC = [[WVRHistoryDelAllUseCase alloc] init];
    }
    return _gHistoryDelAllUC;
}


-(void)setUpRAC
{
    @weakify(self);
    [[self.gHistoryUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gHistoryCompleteSubject sendNext:x];
    }];
    [[self.gHistoryUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gHistoryFailSubject sendNext:x.errorMsg];
        
    }];
    
    RAC(self.gHistoryDelUC, delIds) = RACObserve(self, delIds);
    [[self.gHistoryDelUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gHistoryDelCompleteSubject sendNext:x];
    }];
    [[self.gHistoryDelUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gHistoryDelFailSubject sendNext:x.errorMsg];
        
    }];
    [[self.gHistoryDelAllUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gHistoryDelAllCompleteSubject sendNext:x];
    }];
    [[self.gHistoryDelAllUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gHistoryDelAllFailSubject sendNext:x.errorMsg];
        
    }];
}

-(RACSignal *)gHistoryCompleteSignal
{
    if (!_gHistoryCompleteSignal) {
        @weakify(self);
        _gHistoryCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gHistoryCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gHistoryCompleteSignal;
}

-(RACSignal *)gHistoryFailSignal
{
    if (!_gHistoryFailSignal) {
        @weakify(self);
        _gHistoryFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gHistoryFailSubject = subscriber;
            return nil;
        }];
    }
    return _gHistoryFailSignal;
}

-(RACSignal *)gHistoryDelCompleteSignal
{
    if (!_gHistoryDelCompleteSignal) {
        @weakify(self);
        _gHistoryDelCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gHistoryDelCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gHistoryDelCompleteSignal;
}

-(RACSignal *)gHistoryDelFailSignal
{
    if (!_gHistoryDelFailSignal) {
        @weakify(self);
        _gHistoryDelFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gHistoryDelFailSubject = subscriber;
            return nil;
        }];
    }
    return _gHistoryDelFailSignal;
}

-(RACSignal *)gHistoryDelAllCompleteSignal
{
    if (!_gHistoryDelAllCompleteSignal) {
        @weakify(self);
        _gHistoryDelAllCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gHistoryDelAllCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gHistoryDelAllCompleteSignal;
}

-(RACSignal *)gHistoryDelAllFailSignal
{
    if (!_gHistoryDelAllFailSignal) {
        @weakify(self);
        _gHistoryDelAllFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gHistoryDelAllFailSubject = subscriber;
            return nil;
        }];
    }
    return _gHistoryDelAllFailSignal;
}

-(RACCommand*)getHistoryCmd
{
    return [self.gHistoryUC getRequestCmd];
}

-(RACCommand*)getHistoryDelCmd
{
    return [self.gHistoryDelUC getRequestCmd];
}

-(RACCommand*)getHistoryDelAllCmd
{
    return [self.gHistoryDelAllUC getRequestCmd];
}

-(void)dealloc
{
    DDLogInfo(@"");
}


@end

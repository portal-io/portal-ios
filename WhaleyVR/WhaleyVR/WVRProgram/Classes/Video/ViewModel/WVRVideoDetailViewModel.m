//
//  WVRVideoDetailViewModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRVideoDetailViewModel.h"
#import "WVRVideoDetailUseCase.h"

@interface WVRVideoDetailViewModel()

@property (nonatomic, strong) RACSubject * gCurSuccessSubject;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) RACSubject * gTVItemSuccessSubject;
@property (nonatomic, strong) RACSubject * gTVSeriesSuccessSubject;
@property (nonatomic, strong) RACSubject * gTVSelectSuccessSubject;
@end


@implementation WVRVideoDetailViewModel
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

@synthesize gTVItemSuccessSignal = _gTVItemSuccessSignal;
@synthesize gTVSeriesSuccessSignal = _gTVSeriesSuccessSignal;
@synthesize gTVSelectSuccessSignal = _gTVSelectSuccessSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpARC];
    }
    return self;
}

- (WVRVideoDetailUseCase *)gDetailUC {
    
    if (!_gDetailUC) {
        _gDetailUC = [[WVRVideoDetailUseCase alloc] init];
    }
    return _gDetailUC;
}

- (void)setUpARC {
    
    RAC(self.gDetailUC, code) = RACObserve(self, code);
    
    @weakify(self);
    [[self.gDetailUC buildUseCase] subscribeNext:^(WVRVideoDetailVCModel *_Nullable x) {
        @strongify(self);
        self.dataModel = x;
        [self.gCurSuccessSubject sendNext:x];
    }];
    [[self.gDetailUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        @strongify(self);
        self.errorModel = x;
        [self.gFailSubject sendNext:x];
    }];
    [self.gDetailUC getRequestCmd].allowsConcurrentExecution = YES;
}

- (RACSignal *)gSuccessSignal {
    
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

- (RACSignal *)gFailSignal {
    
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

- (RACSignal *)gTVItemSuccessSignal {
    
    if (!_gTVItemSuccessSignal) {
        @weakify(self);
        _gTVItemSuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gTVItemSuccessSubject = subscriber;
            return nil;
        }];
    }
    return _gTVItemSuccessSignal;
}

- (RACSignal *)gTVSeriesSuccessSignal {
    
    if (!_gTVSeriesSuccessSignal) {
        @weakify(self);
        _gTVSeriesSuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gTVSeriesSuccessSubject = subscriber;
            return nil;
        }];
    }
    return _gTVSeriesSuccessSignal;
}

- (RACSignal *)gTVSelectSuccessSignal {
    
    if (!_gTVSelectSuccessSignal) {
        @weakify(self);
        _gTVSelectSuccessSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gTVSelectSuccessSubject = subscriber;
            return nil;
        }];
    }
    return _gTVSelectSuccessSignal;
}

- (RACCommand *)gDetailCmd {
    
    self.gCurSuccessSubject = self.gSuccessSubject;
    return [self.gDetailUC getRequestCmd];
}

- (RACCommand *)gTVItemDetailCmd
{
    self.gCurSuccessSubject = self.gTVItemSuccessSubject;
    return [self.gDetailUC getRequestCmd];
}

- (RACCommand *)gTVseriesDetailCmd
{
    self.gCurSuccessSubject = self.gTVSeriesSuccessSubject;
    return [self.gDetailUC getRequestCmd];
}


- (RACCommand *)gTVSelectItemDetailCmd
{
    self.gCurSuccessSubject = self.gTVSelectSuccessSubject;
    return [self.gDetailUC getRequestCmd];
}


@end

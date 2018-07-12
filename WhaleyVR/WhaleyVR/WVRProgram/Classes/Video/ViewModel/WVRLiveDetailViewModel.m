//
//  WVRLiveDetailViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveDetailViewModel.h"
#import "WVRLiveDetailUseCase.h"
#import "WVRLiveItemModel.h"

@interface WVRLiveDetailViewModel()

@property (nonatomic, strong) WVRLiveDetailUseCase * gDetailUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRLiveDetailViewModel
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpARC];
    }
    return self;
}

- (WVRLiveDetailUseCase *)gDetailUC {
    
    if (!_gDetailUC) {
        _gDetailUC = [[WVRLiveDetailUseCase alloc] init];
    }
    return _gDetailUC;
}

- (void)setUpARC {
    
    RAC(self.gDetailUC, code) = RACObserve(self, code);
    
    @weakify(self);
    [[self.gDetailUC buildUseCase] subscribeNext:^(WVRLiveItemModel *_Nullable x) {
        @strongify(self);
        [self.gSuccessSubject sendNext:x];
    }];
    [[self.gDetailUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *_Nullable x) {
        @strongify(self);
        self.errorModel = x;
        [self.gFailSubject sendNext:x];
    }];
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

- (RACCommand *)gDetailCmd {
    
    return [self.gDetailUC getRequestCmd];
}


@end

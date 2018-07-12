//
//  WVRDramaDetailViewModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/9.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 互动剧ViewModel

#import "WVRDramaDetailViewModel.h"
#import "WVRDramaDetailUseCase.h"

@interface WVRDramaDetailViewModel()

@property (nonatomic, strong) RACSubject * gCurSuccessSubject;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRDramaDetailViewModel
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpARC];
    }
    return self;
}

- (WVRDramaDetailUseCase *)gDetailUC {
    
    if (!_gDetailUC) {
        _gDetailUC = [[WVRDramaDetailUseCase alloc] init];
    }
    return _gDetailUC;
}

- (void)setUpARC {
    
    RAC(self.gDetailUC, code) = RACObserve(self, sid);
    
    @weakify(self);
    [[self.gDetailUC buildUseCase] subscribeNext:^(WVRInteractiveDramaModel *_Nullable x) {
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

- (RACCommand *)gDetailCmd {
    
    self.gCurSuccessSubject = self.gSuccessSubject;
    return [self.gDetailUC getRequestCmd];
}

@end

//
//  WVRFeedBackViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFeedBackViewModel.h"
#import "WVRFeedBackUseCase.h"

@interface WVRFeedBackViewModel()

@property (nonatomic, strong) WVRFeedBackUseCase * gFeedBackUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRFeedBackViewModel
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpARC];
    }
    return self;
}

- (WVRFeedBackUseCase *)gFeedBackUC {
    
    if (!_gFeedBackUC) {
        _gFeedBackUC = [[WVRFeedBackUseCase alloc] init];
    }
    return _gFeedBackUC;
}

- (void)setUpARC {
    
    RAC(self.gFeedBackUC, params) = RACObserve(self, params);
    
    @weakify(self);
    [[self.gFeedBackUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gSuccessSubject sendNext:x];
    }];
    [[self.gFeedBackUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
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

- (RACCommand *)gFeedBackCmd {
    
    return [self.gFeedBackUC getRequestCmd];
}

@end

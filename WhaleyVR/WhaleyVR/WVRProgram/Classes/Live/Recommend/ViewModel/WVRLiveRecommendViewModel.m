//
//  WVRTopBarViewModel.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRLiveRecommendViewModel.h"
#import "WVRFixRecommendUseCase.h"
#import "WVRRecommendPageReformer.h"
#import "WVRRecommendPageModel.h"

@interface WVRLiveRecommendViewModel ()

@property (nonatomic, strong) WVRFixRecommendUseCase * gFixRecommendUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end
@implementation WVRLiveRecommendViewModel
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

- (WVRFixRecommendUseCase *)gFixRecommendUC
{
    if (!_gFixRecommendUC) {
        _gFixRecommendUC = [[WVRFixRecommendUseCase alloc] init];
    }
    return _gFixRecommendUC;
}

- (void)setUpRAC {
    
    RAC(self.gFixRecommendUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gFixRecommendUC buildUseCase] subscribeNext:^(WVRRecommendPageModel*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x.sectionModels];
    }];
    [[self.gFixRecommendUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
        
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

- (RACCommand *)getLiveRecommendCmd
{
    return [self.gFixRecommendUC getRequestCmd];
}

@end

//
//  WVRTopBarViewModel.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRPageRecommendViewModel.h"
#import "WVRPageRecommendUseCase.h"
#import "WVRRecommendPageReformer.h"
#import "WVRRecommendPageModel.h"

@interface WVRPageRecommendViewModel ()

@property (nonatomic, strong) WVRPageRecommendUseCase * gPageRecommendUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end
@implementation WVRPageRecommendViewModel
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

-(WVRPageRecommendUseCase *)gPageRecommendUC
{
    if (!_gPageRecommendUC) {
        _gPageRecommendUC = [[WVRPageRecommendUseCase alloc] init];
    }
    return _gPageRecommendUC;
}


-(void)setUpRAC
{
    RAC(self.gPageRecommendUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gPageRecommendUC buildUseCase] subscribeNext:^(WVRRecommendPageModel*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x.sectionModels];
    }];
    [[self.gPageRecommendUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
        
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

-(RACCommand*)getPageRecommendCmd
{
    return [self.gPageRecommendUC getRequestCmd];
}

@end

//
//  WVRTopBarViewModel.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRArrangeViewModel.h"
#import "WVRArrangeUseCase.h"
#import "WVRRecommendPageReformer.h"
#import "WVRRecommendPageModel.h"

@interface WVRArrangeViewModel ()

@property (nonatomic, strong) WVRArrangeUseCase * gArrangeUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end
@implementation WVRArrangeViewModel
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

-(WVRArrangeUseCase *)gArrangeUC
{
    if (!_gArrangeUC) {
        _gArrangeUC = [[WVRArrangeUseCase alloc] init];
    }
    return _gArrangeUC;
}


-(void)setUpRAC
{
    RAC(self.gArrangeUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gArrangeUC buildUseCase] subscribeNext:^(WVRRecommendPageModel*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x.sectionModels];
    }];
    [[self.gArrangeUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getArrangeCmd
{
    return [self.gArrangeUC getRequestCmd];
}

@end

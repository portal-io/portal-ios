//
//  WVRSQDefaultFindMoreModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRMixRecommendPageViewModel.h"

#import "WVRMixRecommendPageUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRSectionModel.h"

@interface WVRMixRecommendPageViewModel ()


@property (nonatomic, strong) WVRMixRecommendPageUseCase * gMixRecommendPageUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) WVRSectionModel * gSectionModel;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation WVRMixRecommendPageViewModel
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

-(WVRMixRecommendPageUseCase *)gMixRecommendPageUC
{
    if (!_gMixRecommendPageUC) {
        _gMixRecommendPageUC = [[WVRMixRecommendPageUseCase alloc] init];
    }
    return _gMixRecommendPageUC;
}


-(void)setUpRAC
{
    RAC(self.gMixRecommendPageUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gMixRecommendPageUC buildUseCase] subscribeNext:^(NSMutableDictionary*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gMixRecommendPageUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getMixRecommendPageCmd
{
    return [self.gMixRecommendPageUC getRequestCmd];
}

@end

//
//  WVRSQDefaultFindMoreModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRTitleRecommendPageViewModel.h"
#import "WVRTitleRecommendPageUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRSectionModel.h"

@interface WVRTitleRecommendPageViewModel ()

@property (nonatomic, strong) WVRTitleRecommendPageUseCase * gTitleRecommendPageUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) WVRSectionModel * gSectionModel;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@end


@implementation WVRTitleRecommendPageViewModel
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

- (WVRTitleRecommendPageUseCase *)gTitleRecommendPageUC
{
    if (!_gTitleRecommendPageUC) {
        _gTitleRecommendPageUC = [[WVRTitleRecommendPageUseCase alloc] init];
    }
    return _gTitleRecommendPageUC;
}


- (void)setUpRAC
{
    RAC(self.gTitleRecommendPageUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gTitleRecommendPageUC buildUseCase] subscribeNext:^(NSMutableDictionary*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gTitleRecommendPageUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

- (RACCommand *)getTitleRecommendPageCmd
{
    return [self.gTitleRecommendPageUC getRequestCmd];
}

@end

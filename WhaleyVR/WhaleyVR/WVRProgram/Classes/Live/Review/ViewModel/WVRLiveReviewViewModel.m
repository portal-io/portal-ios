//
//  WVRTopBarViewModel.m
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRLiveReviewViewModel.h"
#import "WVRLiveReviewUseCase.h"
#import "WVRRecommendPageReformer.h"
#import "WVRSectionModel.h"

@interface WVRLiveReviewViewModel ()

@property (nonatomic, strong) WVRLiveReviewUseCase * gLiveReviewUC;

@property (nonatomic, strong) WVRSectionModel * gSectionModel;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;


@end
@implementation WVRLiveReviewViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 0;
        self.pageSize = 10;
        [self setUpRAC];
    }
    return self;
}

-(WVRLiveReviewUseCase *)gLiveReviewUC
{
    if (!_gLiveReviewUC) {
        _gLiveReviewUC = [[WVRLiveReviewUseCase alloc] init];
    }
    return _gLiveReviewUC;
}

-(WVRSectionModel *)gSectionModel
{
    if (!_gSectionModel) {
        _gSectionModel = [[WVRSectionModel alloc] init];
        _gSectionModel.itemModels = [[NSMutableArray alloc] init];
    }
    return _gSectionModel;
}

-(void)setUpRAC
{
//    self.gLiveReviewUC.pageNum = @"0";
//    self.gLiveReviewUC.pageSize = @"50";
    RAC(self.gLiveReviewUC, code) = RACObserve(self, code);
    RAC(self.gLiveReviewUC, subCode) = RACObserve(self, subCode);
    RAC(self.gLiveReviewUC, pageNum) = RACObserve(self, pageNum);
    RAC(self.gLiveReviewUC, pageSize) = RACObserve(self, pageSize);
    @weakify(self);
    [[self.gLiveReviewUC buildUseCase] subscribeNext:^(WVRSectionModel*  _Nullable x) {
        @strongify(self);
        NSMutableArray * temArray = [NSMutableArray arrayWithArray:self.gSectionModel.itemModels];
        [temArray addObjectsFromArray:x.itemModels];
        x.itemModels = temArray;
        self.gSectionModel = x;
        self.gSectionModel.pageNum = self.pageNum;
        [self.gCompleteSubject sendNext:self.gSectionModel];
    }];
    [[self.gLiveReviewUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getLiveReviewCmd
{
    self.pageNum = 0;
    [self.gSectionModel.itemModels removeAllObjects];
    return [self.gLiveReviewUC getRequestCmd];
}

-(RACCommand*)getLiveReviewMoreCmd
{
    self.pageNum ++;
    return [self.gLiveReviewUC getRequestCmd];
}

@end

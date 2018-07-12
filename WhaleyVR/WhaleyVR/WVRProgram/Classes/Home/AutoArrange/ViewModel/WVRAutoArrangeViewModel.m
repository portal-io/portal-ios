//
//  WVRSQDefaultFindMoreModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAutoArrangeViewModel.h"
#import "WVRAutoArrangeUseCase.h"
#import "WVRErrorViewModel.h"
#import "WVRSectionModel.h"

@interface WVRAutoArrangeViewModel ()


@property (nonatomic, strong) WVRAutoArrangeUseCase * gAutoArrangeUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@property (nonatomic, strong) WVRSectionModel * gSectionModel;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation WVRAutoArrangeViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 0;
        self.pageSize = 12;
        [self setUpRAC];
//        self.sectionModel.pageSize = 18;
//        self.sectionModel.pageNum = 0;
    }
    return self;
}

-(WVRSectionModel *)gSectionModel
{
    if (!_gSectionModel) {
        _gSectionModel = [[WVRSectionModel alloc] init];
        _gSectionModel.itemModels = [[NSMutableArray alloc] init];
    }
    return _gSectionModel;
}

-(WVRAutoArrangeUseCase *)gAutoArrangeUC
{
    if (!_gAutoArrangeUC) {
        _gAutoArrangeUC = [[WVRAutoArrangeUseCase alloc] init];
    }
    return _gAutoArrangeUC;
}


-(void)setUpRAC
{
    RAC(self.gAutoArrangeUC, code) = RACObserve(self, code);
    RAC(self.gAutoArrangeUC, pageNum) = RACObserve(self, pageNum);
    RAC(self.gAutoArrangeUC, pageSize) = RACObserve(self, pageSize);
    @weakify(self);
    [[self.gAutoArrangeUC buildUseCase] subscribeNext:^(WVRSectionModel*  _Nullable x) {
        @strongify(self);
        NSMutableArray * temArray = [NSMutableArray arrayWithArray:self.gSectionModel.itemModels];
        [temArray addObjectsFromArray:x.itemModels];
        x.itemModels = temArray;
        self.gSectionModel = x;
        self.gSectionModel.pageNum = self.pageNum;
        [self.gCompleteSubject sendNext:self.gSectionModel];
    }];
    [[self.gAutoArrangeUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x.errorMsg];
        
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

-(RACCommand*)getAutoArrangeCmd
{
    self.pageNum = 0;
    [self.gSectionModel.itemModels removeAllObjects];
    return [self.gAutoArrangeUC getRequestCmd];
}

-(RACCommand*)getAutoArrangeMoreCmd
{
    self.pageNum ++;
    return [self.gAutoArrangeUC getRequestCmd];
}
@end

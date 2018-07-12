//
//  WVRGiftTempViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftTempViewModel.h"
#import "WVRGiftTempInfoUseCase.h"

@interface WVRGiftTempViewModel ()
@property (nonatomic, strong) WVRGiftTempInfoUseCase * gGiftTempUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRGiftTempViewModel
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

-(WVRGiftTempInfoUseCase *)gGiftTempUC
{
    if (!_gGiftTempUC) {
        _gGiftTempUC = [[WVRGiftTempInfoUseCase alloc] init];
    }
    return _gGiftTempUC;
}


-(void)setUpRAC
{
    RAC(self.gGiftTempUC, tempCode) = RACObserve(self, tempCode);
    self.gGiftTempUC.pageNum = @"0";
    self.gGiftTempUC.pageSize = @"1000";
    @weakify(self);
    [[self.gGiftTempUC buildUseCase] subscribeNext:^(NSArray<WVRGiftModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gGiftTempUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getGiftTemoCmd
{
    return [self.gGiftTempUC getRequestCmd];
}

@end

//
//  WVRCurrencyCostViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyCostViewModel.h"
#import "WVRCurrencyCostUseCase.h"

@interface WVRCurrencyCostViewModel()

@property (nonatomic, strong) WVRCurrencyCostUseCase * gCurrencyCostUC;
@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRCurrencyCostViewModel
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

- (WVRCurrencyCostUseCase *)gCurrencyCostUC
{
    if (!_gCurrencyCostUC) {
        _gCurrencyCostUC = [[WVRCurrencyCostUseCase alloc] init];
    }
    return _gCurrencyCostUC;
}

- (void)setUpRAC
{
    RAC(self.gCurrencyCostUC, buyParams) = RACObserve(self, buyParams);
    RAC(self.gCurrencyCostUC, bizParams) = RACObserve(self, bizParams);

    @weakify(self);
    [[self.gCurrencyCostUC buildUseCase] subscribeNext:^(WVRNetworkingResponse*  value) {
        @strongify(self);
        NSInteger code = [value.content[@"code"] integerValue];
        NSString *msg = value.content[@"msg"];
        if (200 == code){
            [self.gCompleteSubject sendNext:value];
        }else{
           [self.gFailSubject sendNext:msg];
        }
    }];
    [[self.gCurrencyCostUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getCurrencyCostCmd
{
    return [self.gCurrencyCostUC getRequestCmd];
}
@end

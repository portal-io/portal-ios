//
//  WVRUserCouponOrderListViewModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUserCouponOrderListViewModel.h"
#import "WVRUserCouponOrderListUC.h"

@interface WVRUserCouponOrderListViewModel ()

@property (nonatomic, strong) WVRUserCouponOrderListUC * gUserCouponUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end

@implementation WVRUserCouponOrderListViewModel
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self installRAC];
    }
    return self;
}

- (WVRUserCouponOrderListUC *)gUserCouponUC
{
    if (!_gUserCouponUC) {
        _gUserCouponUC = [[WVRUserCouponOrderListUC alloc] init];
    }
    return _gUserCouponUC;
}

- (void)installRAC {
    RAC(self.gUserCouponUC, page) = RACObserve(self, page);
    RAC(self.gUserCouponUC, size) = RACObserve(self, size);
    
    @weakify(self);
    [[self.gUserCouponUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        if (x) {
            [self.gSuccessSubject sendNext:x];
        } else {
            [self.gFailSubject sendNext:nil];
        }
    }];
    [[self.gUserCouponUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
    }];
}

- (RACSignal *)gSuccessSignal
{
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

-(RACSignal *)gFailSignal
{
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

- (RACCommand *)requestCmd
{
    return self.gUserCouponUC.getRequestCmd;
}

@end

//
//  WVRUpdateAdressHandle.m
//  WVRProgram
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRUpdateAdressHandle.h"
#import "WVRUpdateAdressUseCase.h"

NSString * const kHttpParams_UpdateAddress_whaleyuid = @"whaleyuid";
NSString * const kHttpParams_UpdateAddress_username = @"name";
NSString * const kHttpParams_UpdateAddress_province = @"province";
NSString * const kHttpParams_UpdateAddress_city = @"city";
NSString * const kHttpParams_UpdateAddress_county = @"county";
NSString * const kHttpParams_UpdateAddress_address = @"address";
NSString * const kHttpParams_UpdateAddress_mobile = @"mobile";

@interface WVRUpdateAdressHandle ()

@property (nonatomic, strong) WVRUpdateAdressUseCase * gHttpUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRUpdateAdressHandle
@synthesize gSuccessSignal = _gSuccessSignal;
@synthesize gFailSignal = _gFailSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpARC];
    }
    return self;
}

- (WVRUpdateAdressUseCase *)gHttpUC {
    
    if (!_gHttpUC) {
        _gHttpUC = [[WVRUpdateAdressUseCase alloc] init];
    }
    return _gHttpUC;
}

- (void)setUpARC {
    
    RAC(self.gHttpUC, params) = RACObserve(self, params);
    
    @weakify(self);
    [[self.gHttpUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gSuccessSubject sendNext:x];
    }];
    [[self.gHttpUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x];
    }];
}

- (RACSignal *)gSuccessSignal {
    
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

- (RACSignal *)gFailSignal {
    
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

- (RACCommand *)gHttpCmd {
    
    return [self.gHttpUC getRequestCmd];
}

@end

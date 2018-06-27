//
//  WVRSetAvatarViewModel.m
//  WVRAccount
//
//  Created by qbshen on 2017/9/13.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "WVRSetAvatarViewModel.h"
#import "WVRSetAvatarUseCase.h"


@interface WVRSetAvatarViewModel ()

@property (nonatomic, strong) WVRSetAvatarUseCase * gSetAvatarUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end
@implementation WVRSetAvatarViewModel
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

-(WVRSetAvatarUseCase *)gSetAvatarUC
{
    if (!_gSetAvatarUC) {
        _gSetAvatarUC = [[WVRSetAvatarUseCase alloc] init];
    }
    return _gSetAvatarUC;
}


-(void)setUpRAC
{
    RAC(self.gSetAvatarUC, fileData) = RACObserve(self, fileData);
    RAC(self.gSetAvatarUC, keyName) = RACObserve(self, keyName);
    RAC(self.gSetAvatarUC, fileName) = RACObserve(self, fileName);
    @weakify(self);
    [[self.gSetAvatarUC buildUseCase] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:self.gSetAvatarUC.gResponseMsg];
    }];
    [[self.gSetAvatarUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)setAvatarCmd
{
    return [self.gSetAvatarUC getRequestCmd];
}

@end

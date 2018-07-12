//
//  WVRGiftRewardViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftRewardViewModel.h"
#import "WVRProgramMembersUseCase.h"

@interface WVRGiftRewardViewModel()

@property (nonatomic, strong) WVRProgramMembersUseCase * gProgramMemberUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end

@implementation WVRGiftRewardViewModel
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

-(WVRProgramMembersUseCase *)gProgramMemberUC
{
    if (!_gProgramMemberUC) {
        _gProgramMemberUC = [[WVRProgramMembersUseCase alloc] init];
    }
    return _gProgramMemberUC;
}


-(void)setUpRAC
{
    RAC(self.gProgramMemberUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gProgramMemberUC buildUseCase] subscribeNext:^(NSArray<WVRProgramMemberModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gProgramMemberUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
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

-(RACCommand*)getProgramMembersCmd
{
    return [self.gProgramMemberUC getRequestCmd];
}

@end

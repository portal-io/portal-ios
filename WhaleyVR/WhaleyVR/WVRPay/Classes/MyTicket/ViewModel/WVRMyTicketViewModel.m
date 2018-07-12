//
//  WVRMyTicketViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyTicketViewModel.h"
#import "WVRMyTicketUseCase.h"

@interface WVRMyTicketViewModel ()

@property (nonatomic, strong) WVRMyTicketUseCase * gMyTicketUC;

@property (nonatomic, strong) RACSubject * gSuccessSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end

@implementation WVRMyTicketViewModel
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

- (WVRMyTicketUseCase *)gMyTicketUC
{
    if (!_gMyTicketUC) {
        _gMyTicketUC = [[WVRMyTicketUseCase alloc] init];
    }
    return _gMyTicketUC;
}

- (void)installRAC {
    RAC(self.gMyTicketUC, page) = RACObserve(self, page);
    RAC(self.gMyTicketUC, size) = RACObserve(self, size);
    
    @weakify(self);
    [[self.gMyTicketUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        if (x) {
            [self.gSuccessSubject sendNext:x];
        } else {
            [self.gFailSubject sendNext:nil];
        }
    }];
    [[self.gMyTicketUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
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

- (RACCommand *)myTicketCmd
{
    return self.gMyTicketUC.getRequestCmd;
}

@end

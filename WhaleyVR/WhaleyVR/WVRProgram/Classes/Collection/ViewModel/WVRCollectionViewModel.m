//
//  WVRCollectionViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionViewModel.h"
#import "WVRCollectionUseCase.h"
#import "WVRCollectionDelUseCase.h"
#import "WVRCollectionStatusUseCase.h"
#import "WVRCollectionSaveUseCase.h"
#import "WVRCollectionModel.h"


@interface WVRCollectionViewModel ()
@property (nonatomic, strong) WVRCollectionUseCase * gCollectionUC;
@property (nonatomic, strong) WVRCollectionDelUseCase * gCollectionDelUC;
@property (nonatomic, strong) WVRCollectionStatusUseCase * gCollectionStatusUC;
@property (nonatomic, strong) WVRCollectionSaveUseCase * gCollectionSaveUC;

@property (nonatomic, strong) RACSubject * gCollectionCompleteSubject;
@property (nonatomic, strong) RACSubject * gCollectionFailSubject;

@property (nonatomic, strong) RACSubject * gCollectionDelCompleteSubject;
@property (nonatomic, strong) RACSubject * gCollectionDelFailSubject;

@property (nonatomic, strong) RACSubject * gCollectionStatusCompleteSubject;
@property (nonatomic, strong) RACSubject * gCollectionStatusFailSubject;

@property (nonatomic, strong) RACSubject * gCollectionSaveCompleteSubject;
@property (nonatomic, strong) RACSubject * gCollectionSaveFailSubject;

@end
@implementation WVRCollectionViewModel
@synthesize gCollectionCompleteSignal = _gCollectionCompleteSignal;
@synthesize gCollectionFailSignal = _gCollectionFailSignal;

@synthesize gCollectionDelCompleteSignal = _gCollectionDelCompleteSignal;
@synthesize gCollectionDelFailSignal = _gCollectionDelFailSignal;

@synthesize gCollectionStatusCompleteSignal = _gCollectionStatusCompleteSignal;
@synthesize gCollectionStatusFailSignal = _gCollectionStatusFailSignal;

@synthesize gCollectionSaveCompleteSignal = _gCollectionSaveCompleteSignal;
@synthesize gCollectionSaveFailSignal = _gCollectionSaveFailSignal;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

- (WVRCollectionUseCase *)gCollectionUC
{
    if (!_gCollectionUC) {
        _gCollectionUC = [[WVRCollectionUseCase alloc] init];
    }
    return _gCollectionUC;
}

- (WVRCollectionDelUseCase *)gCollectionDelUC
{
    if (!_gCollectionDelUC) {
        _gCollectionDelUC = [[WVRCollectionDelUseCase alloc] init];
    }
    return _gCollectionDelUC;
}

- (WVRCollectionStatusUseCase *)gCollectionStatusUC
{
    if (!_gCollectionStatusUC) {
        _gCollectionStatusUC = [[WVRCollectionStatusUseCase alloc] init];
    }
    return _gCollectionStatusUC;
}

- (WVRCollectionSaveUseCase *)gCollectionSaveUC
{
    if (!_gCollectionSaveUC) {
        _gCollectionSaveUC = [[WVRCollectionSaveUseCase alloc] init];
    }
    return _gCollectionSaveUC;
}


- (void)setUpRAC
{
    RAC(self.gCollectionStatusUC, code) = RACObserve(self, delIds);
    @weakify(self);
    [[self.gCollectionUC buildUseCase] subscribeNext:^(NSArray<WVRCollectionModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCollectionCompleteSubject sendNext:x];
    }];
    [[self.gCollectionUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gCollectionFailSubject sendNext:x.errorMsg];
        
    }];
    
    RAC(self.gCollectionDelUC, delIds) = RACObserve(self, delIds);
    [[self.gCollectionDelUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gCollectionDelCompleteSubject sendNext:x];
    }];
    [[self.gCollectionDelUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gCollectionDelFailSubject sendNext:x.errorMsg];
        
    }];
    [[self.gCollectionStatusUC buildUseCase] subscribeNext:^(NSNumber*  _Nullable x) {
        @strongify(self);
        [self.gCollectionStatusCompleteSubject sendNext:x];
    }];
    [[self.gCollectionStatusUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gCollectionStatusFailSubject sendNext:x.errorMsg];
        
    }];
    [[RACObserve(self, saveModel) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gCollectionSaveUC.code = self.saveModel.code;
        self.gCollectionSaveUC.programType = self.saveModel.programType;
        self.gCollectionSaveUC.programName = self.saveModel.name;
        self.gCollectionSaveUC.videoType = self.saveModel.videoType;
        self.gCollectionSaveUC.duration = self.saveModel.duration;
        self.gCollectionSaveUC.status = @"1";
        self.gCollectionSaveUC.picUrl = self.saveModel.thubImageUrl;
    }];
    [[self.gCollectionSaveUC buildUseCase] subscribeNext:^(WVRNetworkingResponse*  _Nullable x) {
        @strongify(self);
        NSString * code = x.content[@"code"];
        if ([code isEqualToString:@"500"]) {
            [self.gCollectionSaveFailSubject sendNext:@"加入播单失败"];
        } else {
            [self.gCollectionSaveCompleteSubject sendNext:x];
        }
    }];
    [[self.gCollectionSaveUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gCollectionSaveFailSubject sendNext:x.errorMsg];
    }];
}

- (RACSignal *)gCollectionCompleteSignal
{
    if (!_gCollectionCompleteSignal) {
        @weakify(self);
        _gCollectionCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionCompleteSignal;
}

- (RACSignal *)gCollectionFailSignal
{
    if (!_gCollectionFailSignal) {
        @weakify(self);
        _gCollectionFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionFailSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionFailSignal;
}

- (RACSignal *)gCollectionDelCompleteSignal
{
    if (!_gCollectionDelCompleteSignal) {
        @weakify(self);
        _gCollectionDelCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionDelCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionDelCompleteSignal;
}

- (RACSignal *)gCollectionDelFailSignal
{
    if (!_gCollectionDelFailSignal) {
        @weakify(self);
        _gCollectionDelFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionDelFailSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionDelFailSignal;
}

- (RACSignal *)gCollectionStatusCompleteSignal
{
    if (!_gCollectionStatusCompleteSignal) {
        @weakify(self);
        _gCollectionStatusCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionStatusCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionStatusCompleteSignal;
}

- (RACSignal *)gCollectionStatusFailSignal
{
    if (!_gCollectionStatusFailSignal) {
        @weakify(self);
        _gCollectionStatusFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionStatusFailSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionStatusFailSignal;
}

- (RACSignal *)gCollectionSaveCompleteSignal
{
    if (!_gCollectionSaveCompleteSignal) {
        @weakify(self);
        _gCollectionSaveCompleteSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionSaveCompleteSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionSaveCompleteSignal;
}

- (RACSignal *)gCollectionSaveFailSignal
{
    if (!_gCollectionSaveFailSignal) {
        @weakify(self);
        _gCollectionSaveFailSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            self.gCollectionSaveFailSubject = subscriber;
            return nil;
        }];
    }
    return _gCollectionSaveFailSignal;
}

- (RACCommand *)getCollectionCmd
{
    return [self.gCollectionUC getRequestCmd];
}

- (RACCommand *)getCollectionDelCmd
{
    return [self.gCollectionDelUC getRequestCmd];
}

- (RACCommand *)getCollectionStatusCmd
{
    return [self.gCollectionStatusUC getRequestCmd];
}

- (RACCommand *)getCollectionSaveCmd
{
    return [self.gCollectionSaveUC getRequestCmd];
}

- (void)dealloc
{
    DDLogInfo(@"");
}


@end

//
//  WVRAllChannelViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRManualArrangeViewModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRItemModel.h"
#import "WVRManualArrangeUseCase.h"
#import "WVRErrorViewModel.h"


@interface WVRManualArrangeViewModel ()

@property (nonatomic, strong) WVRManualArrangeUseCase * gManualArrangeUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;

@end


@implementation WVRManualArrangeViewModel
@synthesize mCompleteSignal = _mCompleteSignal;
@synthesize mFailSignal = _mFailSignal;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpRAC];
    }
    return self;
}

- (WVRManualArrangeUseCase *)gManualArrangeUC
{
    if (!_gManualArrangeUC) {
        _gManualArrangeUC = [[WVRManualArrangeUseCase alloc] init];
    }
    return _gManualArrangeUC;
}

- (void)setUpRAC {
    
    RAC(self.gManualArrangeUC, code) = RACObserve(self, code);
    @weakify(self);
    [[self.gManualArrangeUC buildUseCase] subscribeNext:^(NSArray<WVRItemModel*>*  _Nullable x) {
        @strongify(self);
        [self.gCompleteSubject sendNext:x];
    }];
    [[self.gManualArrangeUC buildErrorCase] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        @strongify(self);
        [self.gFailSubject sendNext:x.errorMsg];
        
    }];
    
}

- (RACSignal *)mCompleteSignal
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

- (RACSignal *)mFailSignal
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

- (RACCommand*)getManualArrangeCmd
{
    return [self.gManualArrangeUC getRequestCmd];
}

//+ (void)http_recommendPageWithCode:(NSString *)code successBlock:(void(^)(WVRSectionModel *))successBlock failBlock:(void(^)(NSString *))failBlock {
//    
//    WVRHttpArrangeEleFindBycode *cmd = [[WVRHttpArrangeEleFindBycode alloc] init];
//    cmd.treeNodeCode = code;
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[@"v"] = @"1";
//    params[@"containArrange"] = @(YES);
//    cmd.bodyParams = params;
//    cmd.successedBlock = ^(WVRHttpArrangeEleFindBycodeModel* args) {
//        [self httpSuccessBlock:args successBlock:^(WVRSectionModel *args) {
//            successBlock(args);
//        }];
//    };
//    
//    cmd.failedBlock = ^(id args){
//        if ([args isKindOfClass:[NSString class]]) {
//            failBlock(args);
//        }
//    };
//    [cmd execute];
//}
//
//+ (void)httpSuccessBlock:(WVRHttpArrangeEleFindBycodeModel *)args successBlock:(void(^)(WVRSectionModel *))successBlock {
//    
//    WVRSectionModel * sectionModel = [args convertToSectionModel];
//    
//    successBlock(sectionModel);
//}

@end

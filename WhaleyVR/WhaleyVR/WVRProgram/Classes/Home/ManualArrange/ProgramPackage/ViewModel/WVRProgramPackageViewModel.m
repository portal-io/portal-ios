//
//  WVRProgramPackageViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramPackageViewModel.h"
#import "WVRProgramPackageUseCase.h"
#import "WVRSectionModel.h"


@interface WVRProgramPackageViewModel()

@property (nonatomic, strong) WVRProgramPackageUseCase * gManualArrangeUC;

@property (nonatomic, strong) RACSubject * gCompleteSubject;
@property (nonatomic, strong) RACSubject * gFailSubject;


@end


@implementation WVRProgramPackageViewModel
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

-(WVRProgramPackageUseCase *)gManualArrangeUC
{
    if (!_gManualArrangeUC) {
        _gManualArrangeUC = [[WVRProgramPackageUseCase alloc] init];
    }
    return _gManualArrangeUC;
}


-(void)setUpRAC
{
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

-(RACCommand*)getManualArrangeCmd
{
    return [self.gManualArrangeUC getRequestCmd];
}

@end


//+ (void)http_programPackageWithCode:(NSString *)code successBlock:(void(^)(WVRSectionModel *))successBlock failBlock:(void(^)(NSString *))failBlock
//{
//    WVRHttpProgramPackage *api = [[WVRHttpProgramPackage alloc] init];
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    params[kHttpParam_programPackage_code] = code;
//    params[kHttpParam_programPackage_size] = @"100";
//    params[kHttpParam_programPackage_page] = @"0";
//    params[@"uid"] = [WVRUserModel sharedInstance].accountId;
//    
//    api.bodyParams = params;
//    api.successedBlock = ^(WVRSectionModel *data) {
//        successBlock(data);
//    };
//    api.failedBlock = ^(WVRNetworkingResponse *data) {
//        failBlock(@"");
//    };
//    [api loadData];
//}

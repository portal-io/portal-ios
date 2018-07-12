//
//  WVRMyOrderViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyOrderViewModel.h"
#import "WVRMyOrderListUseCase.h"

@interface WVRMyOrderViewModel ()

@property (nonatomic, strong) WVRMyOrderListUseCase * gMyOrderListUC;


@property (nonatomic, strong) NSString * gSize;

@end
@implementation WVRMyOrderViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupRAC];
    }
    return self;
}

-(NSString *)gSize
{
    return @"40";
}

-(WVRMyOrderListUseCase *)gMyOrderListUC
{
    if (!_gMyOrderListUC) {
        _gMyOrderListUC = [[WVRMyOrderListUseCase alloc] init];
    }
    return _gMyOrderListUC;
}

- (void)setupRAC {
    @weakify(self);
    RAC(self.gMyOrderListUC, page) = RACObserve(self, gPage);
    RAC(self.gMyOrderListUC, size) = RACObserve(self, gSize);
    
    [[self.gMyOrderListUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gResponseModel = x;
    }];
    
    [[self.gMyOrderListUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
}

- (RACCommand *)myOrderListCmd {
    return self.gMyOrderListUC.getRequestCmd;
}

@end


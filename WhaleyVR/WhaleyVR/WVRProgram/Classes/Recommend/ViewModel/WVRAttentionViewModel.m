//
//  WVRAttentionViewModel.m
//  WVRProgram
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRAttentionViewModel.h"
#import "WVRMyFollowListUseCase.h"

@interface WVRAttentionViewModel ()

@property (nonatomic, strong) WVRMyFollowListUseCase *httpUC;

@end

@implementation WVRAttentionViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.httpUC = [[WVRMyFollowListUseCase alloc] init];
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
//    RAC(self.httpUC, username) = RACObserve(self, username);
//    RAC(self.httpUC, password) = RACObserve(self, password);
    
    [[self.httpUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.attentionModel = x;
    }];
    
    [[self.httpUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
}

- (RACCommand *)httpCmd {
    
    return self.httpUC.getRequestCmd;
}

@end

//
//  LoginViewModel.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/7/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLoginViewModel.h"
#import "WVRUserModel.h"
#import "WVRLoginUseCase.h"
#import "WVRThirtyPLoginUseCase.h"

@interface WVRLoginViewModel ()

@property (nonatomic, strong) WVRLoginUseCase *loginUC;

@property (nonatomic, strong) WVRThirtyPLoginUseCase * gTPLoginUC;

@end


@implementation WVRLoginViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loginUC = [[WVRLoginUseCase alloc] init];
        [self setupRAC];
    }
    return self;
}

-(WVRThirtyPLoginUseCase *)gTPLoginUC
{
    if (!_gTPLoginUC) {
        _gTPLoginUC = [[WVRThirtyPLoginUseCase alloc] init];
    }
    return _gTPLoginUC;
}

- (void)setupRAC {
    @weakify(self);
    RAC(self.loginUC, username) = RACObserve(self, username);
    RAC(self.loginUC, password) = RACObserve(self, password);
    
    [[self.loginUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSString class]]) {
            self.responseMsg = x;
        } else {
            self.userInfo = x;
        }
    }];
    
    [[self.loginUC buildErrorCase] subscribeNext:^(WVRErrorViewModel *  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];

    [[RACObserve(self, origin) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gTPLoginUC.origin = self.origin;
        [[self thirtyPartyLoginCmd] execute:nil];
    }];
    [[self.gTPLoginUC buildUseCase] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        if (x) {
            if ([x isKindOfClass:[NSString class]]) {
                self.responseMsg = x;
            } else
            if ([x isKindOfClass:[WVRThirtyPLoginModel class]]) {
                self.tpLoginModel = x;
            } else {
                self.userInfo = x;
            }
        }
    }];
    [[self.gTPLoginUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.errorModel = x;
    }];
}

- (void)executeLogin {
    [[self loginCmd] execute:nil];
}

- (RACCommand *)loginCmd {
    return self.loginUC.getRequestCmd;
}

- (RACCommand *)thirtyPartyLoginCmd {
    return [self.gTPLoginUC getRequestCmd];
}
@end

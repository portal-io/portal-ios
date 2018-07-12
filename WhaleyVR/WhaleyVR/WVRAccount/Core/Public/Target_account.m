//
//  Target_account.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_account.h"
#import "WVRUserInfoViewController.h"
#import "WVRLoginViewController.h"
#import "WVRRegisterViewController.h"

#import "WVRGetUserInfoUseCase.h"

#import "WVRRefreshTokenUseCase.h"
#import "WVRLoginTool.h"
#import "WVRMediator+Currency.h"

@implementation Target_account

- (UIViewController *)Action_nativeFetchUserInfoViewController:(NSDictionary *)params
{
    WVRUserInfoViewController * mineVC = [[WVRUserInfoViewController alloc] init];
    return mineVC;
}

- (UIViewController *)Action_nativeFetchLoginViewController:(NSDictionary *)params
{
    WVRLoginViewController * vc = [[WVRLoginViewController alloc] init];
    
    return vc;
}

- (UIViewController *)Action_nativeFetchRegisterViewController:(NSDictionary *)params
{
    WVRRegisterViewController * vc = [[WVRRegisterViewController alloc] init];
    
    return vc;
}

- (void)Action_nativeGetUserInfo:(NSDictionary *)params
{
    WVRGetUserInfoUseCase * uc = [[WVRGetUserInfoUseCase alloc] init];
    [[uc buildUseCase] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", @"");
    }];
    [uc.getRequestCmd execute:nil];
    [[WVRMediator sharedInstance] WVRMediator_GetUserWCBalance];
}

- (BOOL)Action_nativeRefreshToken:(NSDictionary *)params
{
    NSString * code = params[@"code"];
//    void(^cmdBlock)(void) = params[@"cmd"];
    RACCommand * cmd = params[@"cmd"];
    WVRRefreshTokenUseCase* refreshTokenUC = [[WVRRefreshTokenUseCase alloc] init];
    
    if ([code isEqualToString:@"152"]) {
//        @weakify(self);
        [[refreshTokenUC buildUseCase] subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
//            cmdBlock();
            [cmd execute:x];
        }];
        [[refreshTokenUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
            
        }];
        [[refreshTokenUC getRequestCmd] execute:nil];
        return NO;
    }
    return YES;
}

- (BOOL)Action_nativeCheckAndAlertLogin:(NSDictionary *)params {
    
    NSString *title = params[@"alertTitle"];
    
    RACCommand * completeCmd = params[@"completeCmd"];
    RACCommand * cancelCmd = params[@"cancelCmd"];
    
    BOOL isLogined = [WVRLoginTool checkAndAlertLogin:title completeBlock:^(BOOL isLogined) {
        [[WVRMediator sharedInstance] WVRMediator_GetUserWCBalance];
        [completeCmd execute:@(isLogined)];
        
    } loginCanceledBlock:^{
        
        [cancelCmd execute:nil];
    }];
    
    return isLogined;
}

- (BOOL)Action_nativeCheckAndToLogin:(NSDictionary *)params {
    
    RACCommand * completeCmd = params[@"completeCmd"];
    RACCommand * cancelCmd = params[@"cancelCmd"];
    
    BOOL isLogined = [WVRLoginTool checkLogin:^{
        
        [completeCmd execute:nil];
        
    } loginCanceledBlock:^{
        
        [cancelCmd execute:nil];
    }];
    
    return isLogined;
}

- (void)Action_nativeForceLogout:(NSDictionary *)params {
    
    RACCommand *cmd = params[@"cmd"];
    
    [WVRLoginTool forceLogout:^{
        
        [cmd execute:nil];
    }];
}

- (void)Action_nativeLogout:(NSDictionary *)params {
    
    [WVRLoginTool logout];
}

@end

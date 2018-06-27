//
//  WVRBaseUserController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseUserController.h"
#import "WVRBindWhaleyAccountVC.h"
#import "WVRInputNameAndPWVC.h"

//#import "UnityAppController+JPush.h"

@interface WVRBaseUserController ()

@end


@implementation WVRBaseUserController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)gotoPerfectInfoVC {
    
    WVRInputNameAndPWVC *registerVC = [[WVRInputNameAndPWVC alloc] init];
    registerVC.viewStyle = WVRRegisterViewStyleInputNameAndPD;
    registerVC.loginSuccessBlock = self.loginSuccessBlock;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)httpLoginSuccess {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusNotification object:self userInfo:@{ @"status" : @1 }];
    
    if ([self presentingViewController]) {
//        if ([WVRAppModel sharedInstance].preVcisOrientationPortraitl) {
//            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//            [WVRAppModel sharedInstance].preVcisOrientationPortraitl = NO;
//        }
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.loginSuccessBlock) {
                self.loginSuccessBlock();
            }
        }];
    } else {
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock();
        }
    }
}


#pragma mark - 外部方法

-(void)backOnClick
{
    [self cancelLogin];
}

- (void)cancelLogin {
    kWeakSelf(self);
    if ([self presentingViewController]) {
//        if ([WVRAppModel sharedInstance].preVcisOrientationPortraitl) {
//            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//            [WVRAppModel sharedInstance].preVcisOrientationPortraitl = NO;
//        }
        
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakself.cancelBlock) {
                weakself.cancelBlock();
            }
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}

//#pragma mark - dismiss
//- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector  = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = orientation;
//        // 从2开始是因为0 1 两个参数已经被selector和target占用
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//}

@end


@implementation WVRLoginVCThirdpartyModel

@end

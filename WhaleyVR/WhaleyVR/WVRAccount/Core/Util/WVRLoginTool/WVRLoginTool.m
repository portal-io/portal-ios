//
//  WVRLoginTool.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLoginTool.h"

#import "WVRLoginViewController.h"
#import "WVRRegisterViewController.h"

#import "UIViewController+HUD.h"
#import "UIAlertController+Extend.h"

@implementation WVRLoginTool

//+ (BOOL)checkLogin {
//    
//    if ([[self class] isLogined]) {
//        return YES;
//    }
//    
//    [WVRLoginTool toGoLogin];
//    return NO;
//}

+ (BOOL)checkAndAlertLogin {
    
    if ([WVRUserModel sharedInstance].isisLogined) {
        return YES;
    }
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [UIAlertController alertTitle:@"提示" mesasge:@"请登录账户" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        
        [WVRLoginTool toGoLogin];
        
    } cancleHandler:^(UIAlertAction *action) {
        [WVRAppModel sharedInstance].shouldContinuePlay = NO;
    } viewController:rootVC];
    
    return NO;
}

// isLogined 调起登录界面后用户登录行为为NO，检测时已登录为YES
+ (BOOL)checkAndAlertLogin:(void(^)(BOOL isLogined))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock {
    
    return [self checkAndAlertLogin:@"请登录账户" completeBlock:completeBlock loginCanceledBlock:loginCanceledBlock];
}

+ (BOOL)checkAndAlertLogin:(NSString *)alertMsg completeBlock:(void(^)(BOOL isLogined))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock {
    
    if ([WVRUserModel sharedInstance].isisLogined) {
        if (completeBlock) {
            completeBlock(YES);
        }
        return YES;
    }
    
    if (alertMsg == nil) {
        alertMsg = @"请登录账户";
    }
    
    [UIAlertController alertTitle:@"提示" mesasge:alertMsg preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        
        [WVRLoginTool toGoLogin:^{
            if (completeBlock) {
                completeBlock(NO);
            }
        } loginCanceledBlock:^{
            if (loginCanceledBlock) {
                loginCanceledBlock();
            }
        }];
        
    } cancleHandler:^(UIAlertAction *action) {
        if (loginCanceledBlock) {
            loginCanceledBlock();
        }
    } viewController:[UIViewController getCurrentVC]];
    
    return NO;
}

+ (void)toGoLogin {
    
    [self toGoLogin:nil loginCanceledBlock:nil];
}

+ (BOOL)checkLogin:(void(^)(void))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock {
    
    WVRUserModel *model = [WVRUserModel sharedInstance];
    
    if (model.isisLogined) { return YES; }
    
    [WVRLoginTool toGoLogin:^{
        if (completeBlock) {
            completeBlock();
        }
    } loginCanceledBlock:^{
        if (loginCanceledBlock) {
            loginCanceledBlock();
        }
    }];
    return NO;
}

+ (void)toGoLogin:(void(^)(void))completeBlock loginCanceledBlock:(void(^)(void))loginCanceledBlock {
    
    WVRLoginViewController *loginVC = [[WVRLoginViewController alloc] init];
    loginVC.loginSuccessBlock = ^{
        if (completeBlock) {
            completeBlock();
        }
    };
    loginVC.cancelBlock = loginCanceledBlock;
    WVRNavigationController *loginNav = [[WVRNavigationController alloc] initWithRootViewController:loginVC];
    
    UIWindow *keywindow = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *rootVC = (UIViewController *)keywindow.rootViewController;
    
    UIViewController * curVC = [UIViewController getCurrentVC];
    if ([curVC isKindOfClass:NSClassFromString(@"UnityViewControllerBase")]) {
        curVC = rootVC;
    }
    
    [curVC presentViewController:loginNav animated:YES completion:^{}];
}

+ (void)toGoRegister:(void(^)(void))completeBlock registerCanceledBlock:(void(^)(void))registerCanceledBlock {
    
    WVRRegisterViewController *loginVC = [[WVRRegisterViewController alloc] init];
    loginVC.loginSuccessBlock = ^{
        if (completeBlock) {
            completeBlock();
        }
    };
    loginVC.cancelBlock = registerCanceledBlock;
    WVRNavigationController *loginNav = [[WVRNavigationController alloc] initWithRootViewController:loginVC];
    
    UIWindow *keywindow = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *rootVC = (UIViewController *)keywindow.rootViewController;
    [rootVC presentViewController:loginNav animated:YES completion:^{}];
}

+ (void)forceLogout:(void(^)(void))completeBlock {
    
    [self clearUserInfo];
    
//    SQToastInKeyWindow(@"您的账号已在其他设备上的登录，请重新登录");
    [UIAlertController alertTitle:@"该账号已在其它设备上登录\n您已被迫登出" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
//            UIViewController * curVC = [self getCurrentVC];
            UITabBarController * tabBar = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            UIViewController * bottomVC = [(UINavigationController *)tabBar.selectedViewController viewControllers].firstObject;
            UIViewController * topVC = [(UINavigationController *)tabBar.selectedViewController viewControllers].lastObject;
            
            if ([bottomVC isKindOfClass:NSClassFromString(@"WVRMineController")]) {
                [topVC.navigationController popToRootViewControllerAnimated:YES];
            } else {
                
            }
        });
    } viewController:[UIViewController getCurrentVC] sureTitle:@"我知道了"];
}

+ (void)logout {
    
    [self clearUserInfo];
}

+ (void)clearUserInfo {
    
    [WVRUserModel sharedInstance].isLogined = NO;
    [WVRUserModel sharedInstance].firstLogin = NO;
    [WVRUserModel sharedInstance].loginAvatar = @"";
    [WVRUserModel sharedInstance].accountId = @"";
    [WVRUserModel sharedInstance].sessionId = @"";
    [WVRUserModel sharedInstance].mobileNumber = @"";
    [WVRUserModel sharedInstance].refreshtoken = @"";

    [self clearLocalAvatar];
}

+ (void)clearLocalAvatar {
    
    [WVRUserModel sharedInstance].tmpAvatar = nil;
    NSString *imageFilePath = [WVRFilePathTool getDocumentWithName:@"selfPhoto.jpg"];
    [WVRFilePathTool removeFileAtPath:imageFilePath];
}

@end

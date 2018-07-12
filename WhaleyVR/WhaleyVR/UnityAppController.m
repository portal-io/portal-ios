//
//  UnityAppController.m
//  WhaleyVR
//
//  Created by Snailvr on 16/7/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "UnityAppController.h"
#import "UnityAppController+UMeng.h"
#import "UnityAppController+JPush.h"
#import "UnityAppController+Extend.h"
//#import "UnityAppController+MLSDKRestore.h"

#import "WVRLaunchImageVC.h"
#import "WVRGotoNextTool.h"
#import "WVRDetailVC.h"
#import "WVRPlayerVC.h"
#import "WVRPlayerHelper.h"

#import "WVRHomeViewController.h"

#import "WVRBIManager.h"

#import "SQDownloadManager.h"
#import "WVRSQLocalController.h"
#import "WVRLiveController.h"
#import "WVRNavigationController.h"

#import "WVRLaunchLoginController.h"

#import "UnityAppController+Bugly.h"

//#import "IpaynowPluginApi.h"
#import "WVRSQLocalController.h"
//#import "WVRRNConfig.h"


@interface UnityAppController ()    // <IMLSDKRestoreDelegate>

@property (nonatomic) NSTimer * stayAliveTimer;
@property (nonatomic, strong) UIImageView *lockScreenV;

@property (nonatomic, assign) BOOL isPlaying;

@end


@implementation UnityAppController

static bool _launchWithAction = false;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupMainWindow];
    
#if DEBUG
    Class debugCls = NSClassFromString(@"UIDebuggingInformationOverlay");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [debugCls performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
#pragma clang diagnostic pop
    
//    Class someClass = NSClassFromString(@"UIDebuggingInformationOverlay");
//    id obj = [someClass performSelector:NSSelectorFromString(@"overlay")];
//    [obj performSelector:NSSelectorFromString(@"toggleVisibility")];
#endif
    
    [self configureThirdFrameworks];                            // 配置三方库
    [self setupBugly];
    [self initUMengSDK];                                        // 初始化U盟
    [self initJPushSDKWithOptions:launchOptions];               // 初始化JPush
    [self registerNotfi];                                       // 注册通知
//    [MobLink setDelegate:self];
    
    [WVRBIManager uploadBIEvents];        // BI
    
    if (!_launchWithAction) {
        
        [self loadLaunchVC];
    }
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - lock Timer

- (void)updateClockTimerNoti:(NSNotification *)noti {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL isPlaying = [noti.userInfo[@"isPlaying"] boolValue];
        
        self.isPlaying = isPlaying;
        
        if (isPlaying) {
            
            [self setUpNotLockTimer];
        } else {
            [self invalidNotLockTimer];
        }
    });
}

- (void)callEveryTwentySeconds {
    
    //  DON'T let the device go to sleep during our sync
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)setUpNotLockTimer {
    if (self.stayAliveTimer) {
        [self.stayAliveTimer invalidate];
        self.stayAliveTimer = nil;
    }
    self.stayAliveTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                           target:self
                                                         selector:@selector(callEveryTwentySeconds)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.stayAliveTimer forMode:NSDefaultRunLoopMode];
    
    [self callEveryTwentySeconds];
}

- (void)invalidNotLockTimer {
    
    [self.stayAliveTimer invalidate];
    self.stayAliveTimer = nil;
    //  Give our device permission to Auto-Lock when it wants to again.
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    DDLogInfo(@"applicationWillResignActive:");
    
//    [WVRBIManager uploadBIEvents];
    
//    if ([self lockScreenV]) {
//        
//        [[[UIApplication sharedApplication] keyWindow] addSubview:_lockScreenV];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    DDLogInfo(@"applicationDidEnterBackground:");
    
    [[SQCocoaHttpServerTool shareInstance] stopHttpServer];
//    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"kEnterBackground"];
    [[HttpAgent sharedInstance] stop];
    
    [self invalidNotLockTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DDLogInfo(@"applicationWillEnterForeground:");
    
    [[SQCocoaHttpServerTool shareInstance] openHttpServer];
    
//    NSDate *lastTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"kEnterBackground"];
//    NSDate *now = [NSDate date];
//
//    NSTimeInterval time = 0;
//    if (lastTime) { time = [now timeIntervalSinceDate:lastTime]; }
//
//    UIViewController *currentVC = self.tabBarController.currentShowVC;
//    BOOL isPlayerVC = [currentVC isKindOfClass:[WVRDetailVC class]] || [currentVC isKindOfClass:[WVRPlayerVC class]];
//    UIViewController *presentedVC = [self.tabBarController presentedViewController];
//    BOOL isRoot = (_window.rootViewController == self.tabBarController);
//    BOOL isPortrait = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait);
//
//    if (isRoot && !presentedVC && isPortrait && !isPlayerVC) {       // 非播放器界面，否则有可能出问题
//        // 20Min
//        if (time > 20 * 60) { [self displayLaunchImage:NO]; }
//    }
    
//    if (time > 20 * 60) { [WVRBIManager uploadBIEvents]; }        // BI
    
//    [[HttpAgent sharedInstance] stop];
    [[HttpAgent sharedInstance] start];
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService resetBadge];
//    UIView *v = [_window snapshotViewAfterScreenUpdates:YES];
    if (self.isPlaying) {
        [self setUpNotLockTimer];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DDLogInfo(@"applicationDidBecomeActive:");
    
    [application setApplicationIconBadgeNumber:0];
    
//    [self performSelector:@selector(removeLockScreenView) withObject:nil afterDelay:3];
    
//    [self syncJSPatch];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    DDLogInfo(@"applicationWillTerminate:");
    //暂时在app kill的时候取消当前下载（不取消，app被kill下载也会继续，app再次启动需要获取到下载的task和状态，否则重新开启新的downTask会存在两个下载任务同时下载一个文件）；
    //后面需要处理的地方有：1，NSURLSession管理的downloadTask在app启动后获取到session会话后原来app在被kill时没有supend或cancle的downloadTask任务就会继续回调下载进度代理，或者下载完成了回调下载完成代理。所以要处理一下这种情况；
    //2.多次cancle会出现403（访问被据），416（resumData中保存的Range超出文件的实际大小）这个两种情况，416可能是ios11上出现；
    //3.综合1，2两种情况使用supend和resume方法
    [[WVRSQLocalController shareInstance] cancleCurDownload];//在cancle多次后resumeData的参数就会异常，下载文件大小与实际不符（目前测试时2次就出现，一次可以正常下载）
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];     // 关闭屏幕常亮
    });
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // Clear Memory Cache When Receive Memory Warning
    
    DDLogInfo(@"Receive Memory Warning");
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    DDLogInfo(@"Memory Warning End -- Already Refresh Cache");
}

#pragma mark - action

- (void)setupMainWindow {
    
    [WVRAppModel changeStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
}

- (void)loadLaunchVC {
    
//    [self displayMainController];
    
    if ([WVRUserModel sharedInstance].isisLogined) {
        [self displayLaunchImage:YES];
    } else {
        [self displayLaunchLogin];
    }
}

- (void)displayLaunchImage:(BOOL)isFirstLaunch {
    
    if ([_window.rootViewController isMemberOfClass:[WVRLaunchImageVC class]]) {
        return;
    }

//    if (!isFirstLaunch && ![WVRLaunchImageVC canShowLaunchImage]) {
//        return;
//    }
    
    WVRLaunchImageVC *vc = [[WVRLaunchImageVC alloc] init];
    vc.onlyShowLaunchImage = !isFirstLaunch;
    
    if (isFirstLaunch) {
        _window.rootViewController = vc;
    } else {
        [_window.rootViewController presentViewController:vc animated:NO completion:nil];
    }
}

- (void)displayLaunchLogin {
    
    if (_window.rootViewController) { return; }
    
    WVRLaunchLoginController *vc = [[WVRLaunchLoginController alloc] init];
    WVRNavigationController * nv = [[WVRNavigationController alloc] initWithRootViewController:vc];
    
    _window.rootViewController = nv;
//    [_window.rootViewController presentViewController:nv animated:NO completion:nil];
}

- (void)displayMainControllerWithBlock:(void(^)(void))block {
    
    if (!_tabBarController) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        _tabBarController = [[WVRTabBarController alloc] init];
        _tabBarController.viewDidAppearBlock = block;
    }
    
    _window.rootViewController = _tabBarController;
    UIViewController * curVC = [UIViewController getCurrentVC];
    // 应用是横屏状态，不跳转
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight || curVC.view.width > curVC.view.height) {
        return;
    }
    
    if (curVC.presentingViewController == _tabBarController) {
        [curVC dismissViewControllerAnimated:YES completion:nil];
    } else if (curVC.tabBarController == _tabBarController) {
        [curVC.navigationController popToRootViewControllerAnimated:YES];
    } else {
        return;
    }
    
    if (nil == _tabBarController.viewDidAppearBlock && nil != block) {
        block();
    }
}

- (void)displayMainController {
    
    if (!_tabBarController) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        _tabBarController = [[WVRTabBarController alloc] init];
    }
    
    _window.rootViewController = _tabBarController;
    UIViewController * curVC = [UIViewController getCurrentVC];
    if (curVC.presentingViewController) {
        [curVC dismissViewControllerAnimated:YES completion:nil];
    } else {
        [curVC.navigationController popViewControllerAnimated:YES];
    }
}

- (void)displayMainController:(WVRItemModel *)lModel {
    
    @weakify(self);
    [self displayMainControllerWithBlock:^{
        @strongify(self);
        [self delayDoJump:lModel];
    }];       // 先切换跟视图控制器
}

- (void)delayDoJump:(WVRItemModel *)obj
{
    if (obj)
        [WVRGotoNextTool gotoNextVC:obj nav:self.tabBarController.selectedViewController];
}

- (UIImageView *)lockScreenV {
    
    UIImage *img = [[WVRPlayerManager sharedInstance] screenShotForGLKView];
    
    if (img) {
        _lockScreenV = [[UIImageView alloc] initWithImage:img];
    }
    
    return _lockScreenV;
}

- (void)removeLockScreenView {
    
    [_lockScreenV removeFromSuperview];
    _lockScreenV = nil;
}

#pragma mark - notification 

- (void)registerNotfi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToHaveNet) name:kNetReachableNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange) name:kNetStatusChagedNoti  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChangeNo) name:kNoNetNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClockTimerNoti:) name:kUpdateScreenLockStatusNoti object:nil];
}

- (void)changeToHaveNet
{
    [self reportEnterApp];
//    if (![WVRReachabilityModel sharedInstance].isNoNet) {
//        [self playerParserInit];
//    }
}

- (void)netStatusChange {
    
    [[WVRSQLocalController shareInstance] startDownWhenHaveNet];
}

//- (void)netChangeNo {
//
//}

#pragma mark - configuration

//- (void)syncJSPatch {
//    
//    [JSPatch sync];
//

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.absoluteString hasPrefix:@"whaleyvr://"]) {
        if ([url.absoluteString hasPrefix:@"whaleyvr://forwardpage/recommend"]) {
            
            NSString *query = url.query;
            NSString *json = @"";
            NSInteger len = @"data=".length;
            if (query.length > len) {
                json = [[query substringFromIndex:len] stringByRemovingPercentEncoding];
            }
            WVRItemModel *model = [WVRItemModel yy_modelWithJSON:json];
            
            if (model.linkArrangeType) {
                _launchWithAction = true;
                
                UINavigationController *nav = self.tabBarController.selectedViewController;
                UIViewController *tmpVC = [self.tabBarController presentedViewController];        // 跳转前记得把模态界面消除
                if (tmpVC) {
                    [tmpVC dismissViewControllerAnimated:NO completion:nil];
                }
                
                if (nav.viewControllers.count > 1) {                            // pop到根视图控制器
                    [nav popToRootViewControllerAnimated:NO];
                }
                
                self.tabBarController.selectedIndex = kRecommendTabBarIndex;
                nav = [[self.tabBarController viewControllers] objectAtIndex:kRecommendTabBarIndex];
                
                [self setupMainWindow];
                
                [self displayMainController:model];
            }
        }
    } else {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//        if (!result) {
//            if ([url.absoluteString hasPrefix:@"whaleyvrIpaynow://"]) {
//
                // 其他如支付等SDK的回调
//                [IpaynowPluginApi application:application openURL:url sourceApplication:options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] annotation:@"paynow"];
//            }
//        }
        return result;
    }
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    
    [[SQDownloadManager sharedInstance] setBackCompletionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //网页版微博分享会回掉此方法，不回掉option
    return YES;
}

@end

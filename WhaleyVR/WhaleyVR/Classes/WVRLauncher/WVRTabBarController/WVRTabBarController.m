//
//  WVRTabBarController.m
//  WhaleyVR
//
//  Created by Snailvr on 16/8/31.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 主控制器

#import "WVRTabBarController.h"
#import "WVRNavigationController.h"
#import "WVRRecommendViewController.h"

#import "WVRSQLocalController.h"
#import "WVRHomeViewController.h"
#import "WVRSQFlowLayout.h"
#import "WVRLiveController.h"
#import "UnityAppController.h"
#import "WVRStartUnityVC.h"
#import "WVRMediator+SettingActions.h"
#import "WVRProgramBIModel.h"

#import "WVRMediator+AccountActions.h"
#import "WVRTestViewController.h"

#import "WVRLaunchFlowManager.h"

@interface WVRTabBarController ()<UITabBarControllerDelegate> {
    BOOL _isNotFirstLoad;  // 非首次加载
}

@end


@implementation WVRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:1 alpha:0.95]];
//    [UITabBar appearance].translucent = NO;
    
    // WVRFindViewController        发现
    WVRHomeViewController * find = [[WVRHomeViewController alloc] init];
    [self addChildVc:find withImage:@"tab_icon_find" selectedImage:@"tab_icon_find_press" title:@"首页"];
    
    // WVRLiveViewController        直播
    WVRLiveController * live = [[WVRLiveController alloc] init];
    [self addChildVc:live withImage:@"tab_icon_live" selectedImage:@"tab_icon_live_press" title:@"VR直播"];
    
//#if (kAppEnvironmentLauncher == 1)
//    // launcher
//    UIViewController *vc = [[UIViewController alloc] init];
//    [self addChildVc:vc withImage:@"tab_icon_launcher" selectedImage:@"tab_icon_launcher" title:@""];
//#endif
    
    // WVRRecommendViewController   关注
    WVRRecommendViewController *recommend = [[WVRRecommendViewController alloc] init];
    [self addChildVc:recommend withImage:@"tab_icon_attention" selectedImage:@"tab_icon_attention_press" title:@"关注"];
    
//#if (kAppEnvironmentLauncher == 1)
//    live.tabBarItem.titlePositionAdjustment = UIOffsetMake(-6, -5);
//    recommend.tabBarItem.titlePositionAdjustment = UIOffsetMake(6, -5);
//#endif
    
    // WVRAccountViewController     我的
    UIViewController *account = [[WVRMediator sharedInstance] WVRMediator_MineViewController];
    [[WVRMediator sharedInstance] WVRMediator_GetUserInfo];
    
    [self addChildVc:account withImage:@"tab_icon_mine" selectedImage:@"tab_icon_mine_press" title:@"我"];
    
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"WVRTestViewController" bundle:[NSBundle mainBundle]];
//    WVRTestViewController *testVC = (WVRTestViewController*)[storyboard instantiateViewControllerWithIdentifier:@"WVRTestViewController"];
//    [self addChildVc:testVC withImage:@"tab_icon_mine" selectedImage:@"tab_icon_mine_press" title:@"测试入口"];
//    [[WVRMediator sharedInstance] WVRMediator_LocalViewController:YES];//加载下载视频列表
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.viewDidAppearBlock) {
        self.viewDidAppearBlock();
        self.viewDidAppearBlock = nil;
    }
    
    if (!_isNotFirstLoad) {
        
        [self shouldShowLaunchFlow];
    }
    _isNotFirstLoad = YES;
}

- (void)shouldShowLaunchFlow {
    // 后续考虑是否有模态界面
    UINavigationController *nav = self.currentShowNav;
    
    // 用户点击了广告页并且出发了跳转
    if (nav.viewControllers.count > 1) {
        
        UIViewController *vc = nav.viewControllers.firstObject;
        
        [[[vc rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
            
            [[WVRLaunchFlowManager shareInstance] shouldShowSecondStage];
        }];
        
    } else {
        
        [[WVRLaunchFlowManager shareInstance] shouldShowSecondStage];
    }
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片(NSString)
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc withImage:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childVc.title = title;
    childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    
    if ([image isEqualToString:@"tab_icon_launcher"]) {
        [childVc.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = k_Color6;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = Color_RGB(49, 164, 242);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    // 先给外面传进来的小控制器 包装一个导航控制器
    WVRNavigationController *nav = [[WVRNavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [nav.navigationBar setTitleTextAttributes:
     @{ NSFontAttributeName: kNavTitleFont,
        NSForegroundColorAttributeName: [UIColor blackColor] }];
    
    // 添加为子控制器
    [self addChildViewController:nav];
    
    self.delegate = self;
}

#pragma mark - UITabBarControllerDelegate

double kSelectTabTime = 0;

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:kAccountTabBarIndex]) {
        
    } else if (viewController == [tabBarController.viewControllers objectAtIndex:kRecommendTabBarIndex]) {
        
//        UINavigationController *nav = tabBarController.childViewControllers[kRecommendTabBarIndex];
//        WVRRecommendViewController *recommend = [nav.viewControllers firstObject];
//        recommend.needHiddeNavBar = NO;
    }
//#if (kAppEnvironmentLauncher == 1)
//    else if (viewController == [tabBarController.viewControllers objectAtIndex:kLauncherTabBarIndex]) {
//
//        double now = [[NSDate date] timeIntervalSince1970];
//        if ((now - kSelectTabTime) <= 2) { return NO; }       // 规避双击事件
//        kSelectTabTime = now;
//
//        [self showU3DView];
//        return NO;
//    }
//#endif
    // 预留方法，可执行双击刷新操作
//    if (viewController == [tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex]) {
//        // 用户点击了当前已选的tab，可能想要触发刷新/其他操作
//        if (viewController == [tabBarController.viewControllers objectAtIndex:kRecommendTabBarIndex]) {
//
////            UINavigationController *nav = tabBarController.childViewControllers[kRecommendTabBarIndex];
////            WVRRecommendViewController *recommend = [nav.viewControllers firstObject];
////            [recommend pulldownRefreshData];
//        } else if (viewController == [tabBarController.viewControllers objectAtIndex:kLiveTabBarIndex]) {
//
////            UINavigationController *nav = tabBarController.childViewControllers[kLiveTabBarIndex];
////            WVRLiveController *recommend = [nav.viewControllers firstObject];
////            [recommend requestInfo];
//        } else if (viewController == [tabBarController.viewControllers objectAtIndex:kFindTabBarIndex]) {
//
////            UINavigationController *nav = tabBarController.childViewControllers[kFindTabBarIndex];
////            WVRSQFindController *recommend = [nav.viewControllers firstObject];
////            [recommend requestInfo];
//        }
//    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    [WVRProgramBIModel recommendTabSelect:tabBarController.selectedIndex];
    
    // 此处为了解决切换tabbar的时候“我的”页面导航栏闪动的问题
    if (tabBarController.selectedIndex == kAccountTabBarIndex) {      // 我的
        
        UINavigationController *nav = tabBarController.childViewControllers[kAccountTabBarIndex];
        [nav setNavigationBarHidden:YES animated:NO];
        
    } else if (tabBarController.selectedIndex == kRecommendTabBarIndex) {   // 推荐
        
//        UINavigationController *nav = tabBarController.childViewControllers[kRecommendTabBarIndex];
//        [nav setNavigationBarHidden:YES animated:NO];
    } else if(tabBarController.selectedIndex == kLiveTabBarIndex) {
//        WVRLiveController* liveVC = [[(UINavigationController*)viewController viewControllers] firstObject];
//        [liveVC requestInfo];
    }
    
    NSLog(@"should show tabBar at index: %ld", (unsigned long)tabBarController.selectedIndex);
}

#pragma mark - show U3D

- (void)showU3DView {
    
    WVRStartUnityVC *vc = [[WVRStartUnityVC alloc] init];
    UINavigationController *nav = [self currentShowNav];
    
    [nav pushViewController:vc animated:YES];
}

#pragma mark - external func

- (UIViewController *)currentShowVC {
    if (self.selectedIndex >= [self viewControllers].count) {//fix bug[#6582]  app启动过程中，切换到后台，然后切换回来，会闪退
        self.selectedIndex = 0;
    }
    UINavigationController *nav = [[self viewControllers] objectAtIndex:self.selectedIndex];
    UIViewController *vc = nav.viewControllers.lastObject;
    
    return vc;
}

- (UINavigationController *)currentShowNav {
    
    return self.selectedViewController;
}

#pragma mark - orientation

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//#endif
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

- (BOOL)prefersStatusBarHidden
{
    return [self.selectedViewController prefersStatusBarHidden];
}

//支持横竖屏
- (BOOL)shouldAutorotate {
    
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.selectedViewController supportedInterfaceOrientations];
}

#if (kAppEnvironmentLauncher == 0)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
#endif

@end

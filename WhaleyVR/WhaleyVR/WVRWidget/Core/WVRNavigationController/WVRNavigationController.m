//
//  WVRNavigationController.m
//  VRManager
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRNavigationController.h"

@interface WVRNavigationController () // <UIGestureRecognizerDelegate>

@end


@implementation WVRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    id target = self.interactivePopGestureRecognizer.delegate;
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
//    pan.delegate = self;
//    
//    [self.view addGestureRecognizer:pan];
//    [self.interactivePopGestureRecognizer setEnabled:NO];
    
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 当前页面是特定页面，不响应滑动手势
//    UIViewController *vc = [self.childViewControllers lastObject];
//    if ([vc isKindOfClass:[BaseViewController class]]) {
//        return NO;
//    }
    return self.childViewControllers.count > 1 && !_gestureInValid;
}

/// YES: 使手势失效
- (void)setGestureInValid:(BOOL)gestureInValid {
    
    _gestureInValid = gestureInValid;
    
    [self.interactivePopGestureRecognizer setEnabled:!gestureInValid];
}

#pragma mark - rotation

- (BOOL)prefersStatusBarHidden {
    
    return [self.viewControllers.lastObject prefersStatusBarHidden];
}

// 支持横竖屏
- (BOOL)shouldAutorotate {
    
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end

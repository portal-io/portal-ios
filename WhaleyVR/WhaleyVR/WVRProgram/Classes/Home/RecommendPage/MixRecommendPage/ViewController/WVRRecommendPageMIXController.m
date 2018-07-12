//
//  WVRRecommendPageMIXController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRecommendPageMIXController.h"
#import "WVRSectionModel.h"
#import "WVRRecommendPageMIXView.h"
#import "WVRSmallPlayerPresenter.h"


@interface WVRRecommendPageMIXController ()

@property (nonatomic) WVRSectionModel * sectionModel;


@end


@implementation WVRRecommendPageMIXController

-(void)loadView
{
    [super loadView];
    self.sectionModel = self.createArgs;
    WVRRecommendPageMIXViewInfo * vInfo = [WVRRecommendPageMIXViewInfo new];
    vInfo.viewController = self;
    vInfo.frame = self.view.bounds;
    vInfo.sectionModel = self.sectionModel;
    WVRRecommendPageMIXView* nodePV = [WVRRecommendPageMIXView createWithInfo:vInfo];
    [nodePV requestInfo];
    self.gCollectionView = nodePV;
    [self.view addSubview:self.gCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
        [[WVRSmallPlayerPresenter shareInstance] restartForLaunch];
    } else {
        [[WVRSmallPlayerPresenter shareInstance] updateCanPlay:YES];
        [(WVRRecommendPageMIXView*)self.gCollectionView updatePlay];
    }
}


-(void)initTitleBar
{
    [super initTitleBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[WVRSmallPlayerPresenter shareInstance] isLaunch]) {
//        [[WVRSmallPlayerPresenter shareInstance] destroyForLauncher];
    }
    else{
        [[WVRSmallPlayerPresenter shareInstance] destroy];
    }
}

- (BOOL)prefersStatusBarHidden {
    if ([WVRAppContext sharedInstance].gStatusBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    return [WVRAppContext sharedInstance].gStatusBarHidden;     // _isLandspace
}

//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    
//    return UIStatusBarAnimationFade;
//}
#pragma mark - orientation

- (BOOL)shouldAutorotate {
    
    return self.gShouldAutorotate;//self.hidenStatusBar;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return self.gSupportedInterfaceO;//UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)gShouldAutorotate
{
    return [WVRAppContext sharedInstance].gShouldAutorotate;
}

- (UIInterfaceOrientationMask)gSupportedInterfaceO
{
    return [WVRAppContext sharedInstance].gSupportedInterfaceO;
}

@end

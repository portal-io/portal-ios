//
//  WVRStartUnityVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRStartUnityVC.h"
#import "WVRMediator+UnityActions.h"

@interface WVRStartUnityVC ()

@property (nonatomic, weak) UIButton *goUnityBtn;
@property (nonatomic, weak) UIImageView *guildImgV;

@property (atomic, assign) BOOL isBack;
@property (atomic, assign) BOOL isGoUnity;

@end


@implementation WVRStartUnityVC

#pragma mark - life cycle

float _goUnityDeley = 2.5;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VR模式";
    
    [self configureSubviews];
    [self performSelector:@selector(jumpToUnityVC) withObject:nil afterDelay:_goUnityDeley];
    
//    // Request to turn on accelerometer and begin receiving accelerometer events
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_guildImgV && !_guildImgV.isAnimating) {
        
        [_guildImgV startAnimating];
    }
    self.isBack = NO;
//    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    // Request to stop receiving accelerometer events and turn off accelerometer
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    self.isBack = YES;
    
    [_guildImgV stopAnimating];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.isGoUnity) {
        
        NSMutableArray<UIViewController *> *tmpArr = [NSMutableArray array];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            [tmpArr addObject:vc];
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if (vc == self) {
                [tmpArr removeObject:vc];
            }
        }
        self.navigationController.viewControllers = tmpArr;
    }
}

- (void)dealloc {
    
    DDLogInfo(@"");
}

#pragma mark - UI

- (void)configureSubviews {
    
    [self createGotoUnityBtn];
    [self createGuildImageView];
    [self createRemindLabel];
}

- (void)createGuildImageView {
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 0; i < 40; i ++) {
        
        NSString *name = [NSString stringWithFormat:@"cardboard_%d.png", i];
        UIImage *img = [UIImage imageNamed:name];
        [imgArr addObject:img];
    }
    
    UIImageView *imgV = [[UIImageView alloc] init];
//    imgV.backgroundColor = Color_RGB(255, 242, 242);
    
    imgV.image = [UIImage imageNamed:@"cardboard_0"];
    
    imgV.width = adaptToWidth(260);
    imgV.height = adaptToWidth(233);
    imgV.centerX = self.view.width / 2.f;
    imgV.y = kNavBarHeight + adaptToWidth(75);
    
//    imgV.layer.borderWidth = adaptToWidth(5);
//    imgV.layer.borderColor = imgV.backgroundColor.CGColor;
    
    imgV.animationRepeatCount = LONG_MAX;
    imgV.animationImages = imgArr;
    imgV.animationDuration = _goUnityDeley;
    
    [self.view addSubview:imgV];
    _guildImgV = imgV;
}

- (void)createRemindLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请将手机横屏放入VR眼镜";
    label.textColor = k_Color5;
    label.font = kFontFitForSize(16);
    [label sizeToFit];
    
    [self.view addSubview:label];
    
    label.centerX = self.view.width/2.f;
    label.y = _guildImgV.bottomY + adaptToWidth(30);
}

- (void)createGotoUnityBtn {
    
    UIButton *unityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    unityBtn.width = adaptToWidth(210);
    unityBtn.height = adaptToWidth(50);
    unityBtn.bottomY = SCREEN_HEIGHT - adaptToWidth(120);
    unityBtn.centerX = self.view.width / 2.f;
    
    UIColor *color = [k_Color1 colorWithAlphaComponent:0.7];
    [unityBtn setTitle:@"进入VR模式" forState:UIControlStateNormal];
    [unityBtn setTitleColor:color forState:UIControlStateNormal];
    [unityBtn.titleLabel setFont:kFontFitForSize(16)];
    
    unityBtn.layer.cornerRadius = adaptToWidth(4);
    unityBtn.layer.borderColor = color.CGColor;
    unityBtn.layer.borderWidth = 1;
    
    [unityBtn addTarget:self action:@selector(unityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unityBtn];
    _goUnityBtn = unityBtn;
}

#pragma mark - action

- (void)unityBtnClick:(UIButton *)sender {
    
    DDLogInfo(@"");
    [self jumpToUnityVC];
}

- (void)jumpToUnityVC {
    
//    if (self.isBack) { return; }
//    if (self.isGoUnity) { return; }
//    
//    self.isGoUnity = YES;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [[WVRMediator sharedInstance] WVRMediator_showU3DView:YES];
//    });
}

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//
//- (void)orientationChanged:(NSNotification *)notification {
//    // Respond to changes in device orientation
//
//    UIDeviceOrientation ori = [[UIDevice currentDevice] orientation];
//    if (ori == UIDeviceOrientationLandscapeLeft) {
//        [self jumpToUnityVC];
//    }
//}

@end

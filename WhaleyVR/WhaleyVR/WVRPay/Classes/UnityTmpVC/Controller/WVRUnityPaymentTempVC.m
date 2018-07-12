//
//  WVRUnityPaymentTempVC.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// Unity跳转支付界面的时候的背景视图控制器

#import "WVRUnityPaymentTempVC.h"
#import "WVRUnityTempVideoView.h"
#import "WVRUnityTempLiveView.h"
#import "WVRUnityTempTopicView.h"
#import "WVRNavigationBar.h"
#import "WVRPayModel.h"

@interface WVRUnityPaymentTempVC (){}

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) WVRPayModel *payModel;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) WVRDetailNavigationBar *bar;

@end


@implementation WVRUnityPaymentTempVC

#pragma mark - life cycle

- (instancetype)initWithData:(NSDictionary *)dict payModel:(WVRPayModel *)payModel {
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        _dataDict = dict;
        _payModel = payModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self navShareSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (_bar) {
        
        [self.view bringSubviewToFront:_bar];
        [_bar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - UI

- (void)navShareSetting {
    
    _bar = [[WVRDetailNavigationBar alloc] init];
    [self.view addSubview:_bar];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIImage *backimage = [[UIImage imageNamed:@"icon_manual_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStylePlain target:self action:@selector(action_nothing)];
    
    NSString *title = _dataDict[@"name"];
    if (title.length) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, 35)];
        label.textAlignment = NSTextAlignmentLeft;
        NSAttributedString * att = [[NSAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[WVRAppModel fontFitForSize:15], NSFontAttributeName, k_Color12, NSForegroundColorAttributeName, nil]];
        label.attributedText = att;
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:label];
        item.leftBarButtonItems = @[ backItem, titleItem ];
    } else {
        
        item.leftBarButtonItems = @[ backItem ];
    }
    
    UIImage *image = [[UIImage imageNamed:@"icon_detail_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *ShareItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(action_nothing)];
    
    item.rightBarButtonItems = @[ ShareItem ];
    
    [self.bar pushNavigationItem:item animated:NO];
}

- (void)drawUI {
    
    [self.view addSubview:self.mainView];
}

- (UIView *)mainView {
    
    if (_mainView) { return _mainView; }
    
    CGRect rect = self.view.frame;
    
    if (_payModel.payComeFromType == WVRPayComeFromTypeProgramPackage) {
        
        _mainView = [[WVRUnityTempTopicView alloc] initWithFrame:rect data:_dataDict];
        
    } else if (_payModel.payComeFromType == WVRPayComeFromTypeProgramLive) {
        
        _mainView = [[WVRUnityTempLiveView alloc] initWithFrame:rect data:_dataDict];
    } else {
        
        _mainView = [[WVRUnityTempVideoView alloc] initWithFrame:rect data:_dataDict];
    }
    
    return _mainView;
}

#pragma mark - action

- (void)action_nothing {
    
}

@end

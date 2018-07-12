//
//  WVRAboutUsVC.m
//  VRManager
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 关于微鲸VR

#import "WVRAboutUsVC.h"
#import "WVRAgreementVC.h"
#import "WVRUMShareView.h"
#import "WVRBusinessCoopController.h"

#define QQ_ACOUNT (@"467306966")
#define QQ_GROUP_KEY (@"e24c8ff028f9ccf3cfef152647b70a2b7a35edb2ffb51fc33b8570141cebec16")

@interface WVRAboutUsVC ()

@end


@implementation WVRAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bulidUI];
}

- (void)bulidUI {
    
    self.navigationItem.title = @"关于微鲸VR";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawUI];
//    [self createRightBarItem];
}

- (void)createRightBarItem {
    
    UIImage *image = [[UIImage imageNamed:@"icon_MA_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarShareItemClick)];
}

- (void)drawUI {
    
    UIImageView *imgViewc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon"]];
    [self.view addSubview:imgViewc];
    imgViewc.centerX = self.view.bounds.size.width/2.0;
    imgViewc.y = kNavBarHeight + fitToWidth(65);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [label setTextAlignment:NSTextAlignmentCenter];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [label setText:[NSString stringWithFormat:@"软件版本：%@", version]];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setTextColor:[UIColor colorWithWhite:0.3529 alpha:1.0]];
    [self.view addSubview:label];
    label.centerX = imgViewc.centerX;
    label.y = imgViewc.bottomY + fitToWidth(25);
    
#if (kAppEnvironmentTest == 1)
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    version = [label.text stringByAppendingString:[NSString stringWithFormat:@" build:%@", build]];
    [label setText:version];
#endif
    
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 16)];
    [copyright setTextAlignment:NSTextAlignmentCenter];
    [copyright setText:@"@2017 WHALEY VR All Rights Reserved"];
    [copyright setFont:[UIFont systemFontOfSize:14]];
    [copyright setTextColor:[UIColor colorWithWhite:0.7529 alpha:1.0]];
    [self.view addSubview:copyright];
    copyright.centerX = imgViewc.centerX;
    copyright.bottomY = SCREEN_HEIGHT - fitToWidth(36);
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    [self.view addSubview:agreeBtn];
    [agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:[UIColor colorWithWhite:0.3529 alpha:1.0] forState:UIControlStateNormal];
    agreeBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH/2, 20);
    agreeBtn.centerX = imgViewc.centerX;
    agreeBtn.bottomY = copyright.y - fitToWidth(18);
    
    UIButton * joinQQ = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, fitToWidth(292), fitToWidth(52))];
    [joinQQ setTitle:[NSString stringWithFormat:@"加入官方粉丝QQ群：%@",QQ_ACOUNT] forState:UIControlStateNormal];
    joinQQ.backgroundColor = UIColorFromRGB(0xfafafa);
    [joinQQ setBackgroundImageWithColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    joinQQ.layer.masksToBounds = YES;
    joinQQ.layer.cornerRadius = fitToWidth(4.0f);
    joinQQ.layer.borderWidth = 0.5;
    joinQQ.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    [self.view addSubview:joinQQ];
    joinQQ.centerX = imgViewc.centerX;
    joinQQ.bottomY = SCREEN_HEIGHT - adaptToWidth(152) - adaptToWidth(20) - joinQQ.height;
    if (joinQQ.y < label.bottomY) {
        joinQQ.y = label.bottomY+5;
    }
    [joinQQ addTarget:self action:@selector(joinQQOnClick) forControlEvents:UIControlEventTouchUpInside];
    [joinQQ setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    joinQQ.titleLabel.font = [UIFont systemFontOfSize:fitToWidth(13.5f)];
    
    [self addBusinessCooperationBtnWithY:(joinQQ.bottomY + adaptToWidth(20))];
}

- (void)addBusinessCooperationBtnWithY:(float)y {
    
    UIButton *business = [[UIButton alloc]initWithFrame:CGRectMake(0, y, fitToWidth(292), fitToWidth(52))];
    [business setTitle:[NSString stringWithFormat:@"商务合作"] forState:UIControlStateNormal];
    business.backgroundColor = UIColorFromRGB(0xfafafa);
    [business setBackgroundImageWithColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    business.layer.masksToBounds = YES;
    business.layer.cornerRadius = fitToWidth(4.0f);
    business.layer.borderWidth = 0.5;
    business.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    [self.view addSubview:business];
    business.centerX = self.view.centerX;
    [business addTarget:self action:@selector(businessCooperationClick) forControlEvents:UIControlEventTouchUpInside];
    [business setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    business.titleLabel.font = [UIFont systemFontOfSize:fitToWidth(13.5f)];
}

- (void)joinQQOnClick {
    
    [self joinGroup:QQ_ACOUNT key:QQ_GROUP_KEY];
}

- (void)businessCooperationClick {
    
    WVRBusinessCoopController * vc = [WVRBusinessCoopController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key {
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin, key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

#pragma mark - action

// 分享
- (void)rightBarShareItemClick {
    // 分享功能模块
    
    [WVRUMShareView shareForAbout];
}

- (void)agreeAction:(id)sender {
    
    [WVRTrackEventMapping trackEvent:@"about" flag:@"protocol"];
    
    WVRAgreementVC *agreeVC = [[WVRAgreementVC alloc] init];
    
    [self.navigationController pushViewController:agreeVC animated:YES];
}

- (void)backClick:(UIButton *)btn {
    
    [WVRTrackEventMapping trackEvent:@"about" flag:@"back"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

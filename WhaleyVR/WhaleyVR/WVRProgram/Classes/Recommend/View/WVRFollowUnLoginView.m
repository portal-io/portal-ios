//
//  WVRFollowUnLoginView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFollowUnLoginView.h"

#import "WVRMediator+AccountActions.h"

@interface WVRFollowUnLoginView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *remainLabel;
@property (nonatomic, weak) UIButton *loginBtn;

@end


@implementation WVRFollowUnLoginView

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - kTabBarHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createImageView];
        [self createRemindLabel];
        [self createLoginButton];
    }
    return self;
}

- (void)createImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, adaptToWidth(125), adaptToWidth(180), adaptToWidth(165))];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.centerX = self.width / 2.f;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"myFollow_icon_unLogin"];
    
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)createRemindLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"登录后才能看到您关注的内容哦~";
    label.font = kFontFitForSize(15);
    label.textColor = k_Color6;
    [label sizeToFit];
    
    label.centerX = self.width / 2.f;
    label.y = self.imageView.bottomY + adaptToWidth(18);
    
    [self addSubview:label];
    _remainLabel = label;
}

- (void)createLoginButton {
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, _remainLabel.bottomY + adaptToWidth(30), adaptToWidth(225), adaptToWidth(40));
    loginBtn.centerX = self.width / 2.f;
    loginBtn.backgroundColor = [UIColor colorWithHex:0x29A1F7];
    loginBtn.layer.cornerRadius = adaptToWidth(4);
    loginBtn.layer.masksToBounds = YES;
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:k_Color12 forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kFontFitForSize(15);
    
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:loginBtn];
    _loginBtn = loginBtn;
}

#pragma mark - action

- (void)loginBtnClick:(UIButton *)sender {
    
    [[WVRMediator sharedInstance] WVRMediator_CheckAndToLogin:nil];
}

@end

//
//  WVRUnityPlayerTopView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityPlayerTopView.h"

@interface WVRUnityPlayerTopView () {
    id _rac_handler;
}

@property (nonatomic, weak) UIButton *backBtn;

@property (nonatomic, weak) UILabel *titleLabel;

@end


@implementation WVRUnityPlayerTopView

#define VIEW_SPACE 11
#define SELF_VIEW_HEIGHT (MIN(SCREEN_HEIGHT, SCREEN_WIDTH) * 0.11f)

- (instancetype)initWithViewModel:(WVRUnityPlayerViewModel *)viewModel {
    self = [super init];
    if (self) {
        
        [self setViewModel:viewModel];
        
        [self configSelf];
        [self createSubViews];
        [self installRAC];
    }
    return self;
}

- (void)installRAC {
    
    @weakify(self);
    [[RACObserve(self.viewModel, showingToast) skip:1] subscribeNext:^(id  _Nullable x) {
        [UIView animateWithDuration:UnityDefaultToastTime animations:^{
            
            @strongify(self);
            self.titleLabel.alpha = (1 - [x intValue]);
        }];
    }];
    
    __block RACDisposable *handler = [RACObserve(self.viewModel, unitySceneReady) subscribeNext:^(id  _Nullable x) {
        if (self.viewModel.unitySceneReady) {
            @strongify(self);
            self.backBtn.enabled = YES;
            [handler dispose];
        }
    }];
    _rac_handler = handler;
}

- (void)configSelf {
    
    self.frame = CGRectMake(0, 0, MAX(SCREEN_HEIGHT, SCREEN_WIDTH), SELF_VIEW_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9f];
}

- (void)createSubViews {
    
    [self backBtn];
    [self titleLabel];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(fitToWidth(VIEW_SPACE), 0, fitToWidth(45), fitToWidth(35));
        [btn setImage:[UIImage imageNamed:@"player_icon_back"] forState:UIControlStateNormal];
        
        btn.enabled = NO;
        [btn addTarget:self.viewModel action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        btn.centerY = self.height * 0.5f;
        _backBtn = btn;
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        float halfScreenWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT) * 0.5f;
        float x = self.backBtn.bottomX + fitToWidth(VIEW_SPACE);
        float width = halfScreenWidth - x - adaptToWidth(25);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, fitToWidth(35))];
        label.font = kFontFitForSize(15);
        label.textColor = [UIColor whiteColor];
        label.text = self.viewModel.title;
        
        [self addSubview:label];
        label.centerY = self.height * 0.5f;
        _titleLabel = label;
    }
    return _titleLabel;
}

@end

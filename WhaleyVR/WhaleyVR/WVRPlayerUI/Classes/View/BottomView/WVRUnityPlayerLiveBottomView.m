//
//  WVRUnityPlayerLiveBottomView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityPlayerLiveBottomView.h"

@interface WVRUnityPlayerLiveBottomView () {
    id _rac_handler;
}

@property (nonatomic, weak) UIButton *definitionBtn;

@property (nonatomic, weak) UIButton *vrModeBtn;

@end


@implementation WVRUnityPlayerLiveBottomView

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
    [RACObserve(self.viewModel, definition) subscribeNext:^(id  _Nullable x) {
        if (x != nil) {
            @strongify(self);
            [self.definitionBtn setTitle:x forState:UIControlStateNormal];
        }
    }];
    
    [RACObserve(self.viewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self playStatusChanged];
    }];
    
    __block RACDisposable *handler = [RACObserve(self.viewModel, unitySceneReady) subscribeNext:^(id  _Nullable x) {
        if (self.viewModel.unitySceneReady) {
            @strongify(self);
            self.vrModeBtn.enabled = YES;
            [handler dispose];
        }
    }];
    _rac_handler = handler;
}

- (void)configSelf {
    
    float width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    float height = SELF_VIEW_HEIGHT;
    float y = MIN(SCREEN_HEIGHT, SCREEN_WIDTH) - height;
    self.frame = CGRectMake(0, y, width, height);
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9f];
}

- (void)createSubViews {
    
    [self vrModeBtn];
    [self definitionBtn];
}

- (UIButton *)definitionBtn {
    if (!_definitionBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        [btn setTitle:@"高清" forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFontFitForSize(13.5)];
        
        float width = fitToWidth(45);
        float height = fitToWidth(35);
        float offset = 0 - fitToWidth(VIEW_SPACE);
        
        [btn addTarget:self.viewModel action:@selector(definitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _definitionBtn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.equalTo(btn.superview);
            make.right.equalTo(self.vrModeBtn.mas_left).offset(offset);
        }];
    }
    return _definitionBtn;
}

- (UIButton *)vrModeBtn {
    if (!_vrModeBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"icon_player_back_from_vrMode"] forState:UIControlStateNormal];
        btn.enabled = NO;
        
        float width = fitToWidth(45);
        float height = fitToWidth(35);
        float offset = 0 - fitToWidth(VIEW_SPACE);
        
        [btn addTarget:self.viewModel action:@selector(vrModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _vrModeBtn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.equalTo(btn.superview);
            make.right.equalTo(btn.superview).offset(offset);
        }];
    }
    return _vrModeBtn;
}

// MARK: - action

- (void)playStatusChanged {
    
    BOOL enable = (self.viewModel.playStatus != UnityPlayerPlayStatusPreparing);
    self.definitionBtn.enabled = enable;
}

@end

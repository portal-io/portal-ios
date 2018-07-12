//
//  WVRUnityPlayerLiveTopView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityPlayerLiveTopView.h"
#import "WVRMediator+UnityActions.h"
#import "YYText.h"

@interface WVRUnityPlayerLiveTopView () {
    id _rac_handler;
}

@property (nonatomic, weak) UIButton *backBtn;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *line;

@property (nonatomic, weak) YYLabel *countLabel;

@property (nonatomic, weak) UIButton *closeBtn;

@end


@implementation WVRUnityPlayerLiveTopView

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
    [RACObserve(self.viewModel, playCount) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self playCoutChanged];
    }];
    
    [[RACObserve(self.viewModel, showingToast) skip:1] subscribeNext:^(id  _Nullable x) {
        [UIView animateWithDuration:UnityDefaultToastTime animations:^{
            
            @strongify(self);
            self.titleLabel.alpha = (1 - [x intValue]);
            self.countLabel.alpha = self.titleLabel.alpha;
            self.line.alpha = self.titleLabel.alpha;
        }];
    }];
    
    __block RACDisposable *handler = [RACObserve(self.viewModel, unitySceneReady) subscribeNext:^(id  _Nullable x) {
        if (self.viewModel.unitySceneReady) {
            @strongify(self);
            self.backBtn.enabled = YES;
            self.closeBtn.enabled = YES;
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
    [self line];
    [self countLabel];
    [self closeBtn];
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
        
        [label sizeToFit];
        
        label.centerY = self.height * 0.5f;
        if (label.width > width) {
            label.width = width;
        }
        
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        
        UIView *view = [[UIView alloc] init];
        float x = self.titleLabel.bottomX + fitToWidth(11);
        float height = fitToWidth(12);
        float y = (self.height - height) * 0.5f;
        view.frame = CGRectMake(x, y, 0.5, height);
        
        view.backgroundColor = k_Color9;
        
        [self addSubview:view];
        _line = view;
    }
    return _line;
}

- (YYLabel *)countLabel {
    if (!_countLabel) {
        
        YYLabel *label = [[YYLabel alloc] init];
        label.font = kFontFitForSize(12.5);
        
        float x = self.line.bottomX + fitToWidth(11);
        float height = fitToWidth(25);
        float y = (self.height - height) * 0.5f;
        
        label.frame = CGRectMake(x, y, fitToWidth(90), height);
        
        
        [self addSubview:label];
        _countLabel = label;
    }
    return _countLabel;
}

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"player_live_exit"] forState:UIControlStateNormal];
        
        float width = fitToWidth(30);
        btn.frame = CGRectMake(0, 0, width, width);
        btn.centerY = self.height * 0.5f;
        btn.bottomX = self.width - fitToWidth(VIEW_SPACE);
        btn.enabled = NO;
        
        [btn addTarget:self.viewModel action:@selector(liveCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _closeBtn = btn;
    }
    return _closeBtn;
}

// MARK: - func

- (void)playCoutChanged {
    
    UIFont *font = self.countLabel.font;
    UIColor *color = Color_RGB(244, 216, 133); // [UIColor colorWithHex:0xF4D885]
    
    UIImage *image = [UIImage imageNamed:@"icon_player_live_online_pepole"];
    NSString *address = [WVRComputeTool numberToString:self.viewModel.playCount];
    
    NSString *str = [NSString stringWithFormat:@"  %@人", address];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName: color, NSFontAttributeName: font }]];
    
    self.countLabel.attributedText = [text copy];
    
    CGSize sizeOriginal = CGSizeMake(self.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    self.countLabel.size = layout.textBoundingSize;
    self.countLabel.textLayout = layout;
    
    self.countLabel.centerY = self.height * 0.5;
}

@end

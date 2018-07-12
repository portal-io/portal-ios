//
//  WVRUnityPlayerLocalBottomView.m
//  Unity-iPhone
//
//  Created by soccer_vr on 2017/12/29.
//

#import "WVRUnityPlayerLocalBottomView.h"
#import "WVRSlider.h"

@interface WVRUnityPlayerLocalBottomView ()<WVRSliderDelegate> {
    id _rac_handler;
}

@property (nonatomic, weak) UIButton *vrModeBtn;

@property (nonatomic, weak) UIButton *playBtn;

@property (nonatomic, weak) UILabel *positionLable;

@property (nonatomic, weak) UILabel *durationLabel;

@property (nonatomic, weak) WVRSlider *slider;

@end


@implementation WVRUnityPlayerLocalBottomView

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
    [RACObserve(self.viewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self playStatusChanged];
    }];
    [RACObserve(self.viewModel, position) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self playerPositionChanged];
    }];
    [RACObserve(self.viewModel, duration) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self playerDurationChanged];
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
    
    [self playBtn];
    [self positionLable];
    [self durationLabel];
    [self slider];
}

- (UIButton *)vrModeBtn {
    if (!_vrModeBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"icon_player_back_from_vrMode"] forState:UIControlStateNormal];
        btn.enabled = NO;
        
        float width = fitToWidth(35);
        float height = fitToWidth(30);
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

- (UIButton *)playBtn {
    if (!_playBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"player_icon_play"] forState:UIControlStateNormal];
        
        float width = fitToWidth(35);
        float height = fitToWidth(30);
        float offset = fitToWidth(VIEW_SPACE);
        
        [btn addTarget:self.viewModel action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _playBtn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.equalTo(btn.superview);
            make.left.equalTo(btn.superview).offset(offset);
        }];
    }
    return _playBtn;
}

- (UILabel *)positionLable {
    if (!_positionLable) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, fitToWidth(45), fitToWidth(25));
        label.font = kFontFitForSize(13);
        label.textColor = [UIColor whiteColor];
        label.text = @"00:00";
        
        [self addSubview:label];
        _positionLable = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(label.width);
            make.height.mas_equalTo(label.height);
            make.left.equalTo(self.playBtn.mas_right).offset(fitToWidth(VIEW_SPACE));
            make.centerY.equalTo(label.superview);
        }];
    }
    return _positionLable;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, fitToWidth(45), fitToWidth(25));
        label.font = kFontFitForSize(13);
        label.textColor = [UIColor whiteColor];
        label.text = @"00:00";
        
        [self addSubview:label];
        _durationLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(label.width);
            make.height.mas_equalTo(label.height);
            make.right.equalTo(self.vrModeBtn.mas_left).offset(0 - fitToWidth(VIEW_SPACE));
            make.centerY.equalTo(label.superview);
        }];
    }
    return _durationLabel;
}

- (WVRSlider *)slider {
    if (!_slider) {
        
        WVRSlider *slider = [[WVRSlider alloc] init];
        slider.realDelegate = self;
        
        [self addSubview:slider];
        _slider = slider;
        
        float offset = fitToWidth(VIEW_SPACE);
        
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.positionLable.mas_right).offset(offset);
            make.right.equalTo(self.durationLabel.mas_left).offset(0 - offset);
            make.centerY.equalTo(slider.superview);
        }];
    }
    return _slider;
}

// MARK: - action

- (void)playStatusChanged {
    
    self.playBtn.tag = self.viewModel.playStatus;
    
    BOOL enable = (self.viewModel.playStatus != UnityPlayerPlayStatusPreparing);
    self.playBtn.enabled = enable;
    self.slider.enabled = enable;
    
    switch (self.viewModel.playStatus) {
        case UnityPlayerPlayStatusComplation: {
            [self.playBtn setImage:[UIImage imageNamed:@"player_icon_restart"] forState:UIControlStateNormal];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.slider resetWithPlayComplete];
            });
        }
            break;
        case UnityPlayerPlayStatusPause:
            
            [self.playBtn setImage:[UIImage imageNamed:@"player_icon_play"] forState:UIControlStateNormal];
            break;
        case UnityPlayerPlayStatusPlaying:
            self.slider.enabled = YES;
            [self.playBtn setImage:[UIImage imageNamed:@"player_icon_pause"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)playerPositionChanged {
    
    [self.positionLable setText:[self numberToTime:self.viewModel.position/1000]];
    
    long buffer = (self.viewModel.streamType == STREAM_VR_LOCAL) ? 0 : self.viewModel.buffer;
    [self.slider updatePosition:self.viewModel.position buffer:buffer duration:self.viewModel.duration];
}

- (void)playerDurationChanged {
    
    [self.durationLabel setText:[self numberToTime:self.viewModel.duration/1000]];
}

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)time/60, (int)time%60];
}

// MARK: - WVRSliderDelegate

- (void)sliderStartScrubbing:(UISlider *)sender {
    
    // 防止拖拽过程中控件隐藏
    [self.viewModel.delegate scheduleHideControls];
}

- (void)sliderEndScrubbing:(UISlider *)sender {
    
    [self.viewModel changeProgress:self.viewModel.duration * sender.value];
}

@end

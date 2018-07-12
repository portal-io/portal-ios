//
//  WVRPlayerStartView.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/26.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器起播界面，有背景图，显示本界面的时候不允许切换单双屏

#import "WVRPlayerStartView.h"

@interface WVRPlayerStartView () {
    
    NSString *_title;
    NSString *_nextTitle;
    float _minWidth;
    float _maxWidth;
    BOOL _isLoading;
    BOOL _isErrorStatus;
    BOOL _isWaitingRestart;
    NSTimer *_countdownTimer;   // 专题连播倒计时timer
    int _timerCount;
}

@property (nonatomic, weak) UIImageView *imageView;     // background
@property (nonatomic, weak) UIImageView *logo;

@property (nonatomic, weak) UIImageView *loadingView;   // animating

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *progressView;

@property (nonatomic, weak) UIButton *retryBtn;
@property (nonatomic, weak) UILabel *remindLabel;       // payment
@property (nonatomic, weak) UIButton *buyBtn;           // payment
@property (nonatomic, weak) UIButton *reTrialBtn;       // payment

@property (nonatomic, weak) UIButton *backBtn;

@property (nonatomic, strong) UIButton *vrBackBtn;

/// 提示用户可以再次播放
@property (nonatomic, weak) UIButton *restartBackBtn;   // restart
@property (nonatomic, weak) UILabel *restartTitleLabel; // restart
@property (nonatomic, weak) UIButton *nextBtn;          // topic

@end


@implementation WVRPlayerStartView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        _title = @"";
        
        _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        [self imageView];
        [self logo];
        [self loadingView];
        [self titleLabel];
        [self startAnimation];
        [self backBtn];
        [self vrBackBtn];
        [self registeNotifications];
        @weakify(self);
        [RACObserve(self, gHidenBackgroundImage) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.imageView.hidden = self.gHidenBackgroundImage;
        }];
        [RACObserve(self, gHidenVRBackBtn) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.vrBackBtn.hidden = self.gHidenVRBackBtn;
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _title = @"";
    
    _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self imageView];
    [self logo];
    [self loadingView];
    [self titleLabel];
    [self startAnimation];
    [self backBtn];
    
    [self registeNotifications];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview);
        make.top.equalTo(self.superview);
        make.height.equalTo(self.superview);
        make.width.equalTo(self.superview);
    }];
}

- (instancetype)initWithTitleText:(NSString *)title containerView:(UIView *)container {
    self = [super initWithFrame:container.bounds];
    if (self) {
        
        _title = title;
        
        _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [container addSubview:self];
        
        [self imageView];
        [self logo];
        [self loadingView];
        [self titleLabel];
        [self startAnimation];
        [self backBtn];
        
        [self registeNotifications];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container);
            make.top.equalTo(container);
            make.height.equalTo(container);
            make.width.equalTo(container);
        }];
    }
    return self;
}

/// 分屏模式下 播放结束后重新播放
- (instancetype)initWithContainerView:(UIView *)container {
    self = [super initWithFrame:container.bounds];
    if (self) {
        
        _isWaitingRestart = YES;
        
        _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [container addSubview:self];
        
        [self imageView];
        [self restartBackBtn];
        [self createRestartBtn];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container);
            make.top.equalTo(container);
            make.height.equalTo(container);
            make.width.equalTo(container);
        }];
    }
    return self;
}

/// 手机模式下 播放结束后重新播放
- (instancetype)initForRestartWithTitleText:(NSString *)title containerView:(UIView *)container {
    self = [super initWithFrame:container.bounds];
    if (self) {
        
        _isWaitingRestart = YES;
        _title = title;
        
        _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [container addSubview:self];
        
        [self imageView];
        [self logo];
        kWeakSelf(self);
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(weakself);
        }];
        [self restartTitleLabel];
        [self restartBackBtn];
        [self createRestartBtnForCompilation];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container);
            make.top.equalTo(container);
            make.height.equalTo(container);
            make.width.equalTo(container);
        }];
    }
    return self;
}

- (instancetype)initForTopicWithTitleText:(NSString *)title nextTitle:(NSString *)nextTitle containerView:(UIView *)container {
    self = [super initWithFrame:container.bounds];
    if (self) {
        
        _isWaitingRestart = YES;
        _title = title;
        _nextTitle = nextTitle;
        
        _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [container addSubview:self];
        
        [self imageView];
        [self logo];
        kWeakSelf(self);
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(weakself);
        }];
        [self restartTitleLabel];
        [self restartBackBtn];
        [self topicBackTitle];
        [self createRestartBtnForCompilation];
        [self.reTrialBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_centerX).offset(-fitToWidth(20));
        }];
        [self nextBtn];
        
        [self createTimer];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container);
            make.top.equalTo(container);
            make.height.equalTo(container);
            make.width.equalTo(container);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float fit = self.height / 375.f;
    float height = 40 * fit;
    float width = 100 * fit;
    [self.retryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    
    if (_isWaitingRestart) {
        self.restartBackBtn.hidden = (self.width < _maxWidth * 0.8);
    } else {
        
        self.loadingView.bottomX = 0;
        self.loadingView.bottomY = self.height / 2.f;
    }
}

- (void)hidenbackBtn:(BOOL)isHiden
{
    self.backBtn.hidden = isHiden;
}

#pragma mark - subView

- (UIImageView *)imageView {
    if (!_imageView) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        
        imageV.clipsToBounds = YES;
        [self insertSubview:imageV atIndex:0];
        self.imageView = imageV;
        
        [self configImageForImageView];
        
        kWeakSelf(self);
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself);
            make.top.equalTo(weakself);
            make.height.equalTo(weakself);
            make.width.equalTo(weakself);
        }];
    }
    return _imageView;
}

- (UIImageView *)logo {
    if (!_logo) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_start_logo"]];
        
        img.centerX = self.width / 2.f;
        img.bottomY = self.height / 2.f - adaptToWidth(15);     // 具体位置设置在layoutsubviews方法
        
        [self addSubview:img];
        _logo = img;
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(img.height);
            make.width.mas_equalTo(img.width);
            make.centerX.equalTo(img.superview);
            make.bottom.equalTo(img.superview.mas_centerY).offset(0 - adaptToWidth(15));
        }];
    }
    return _logo;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_start_loading"]];
        
        img.bottomX = 0;
        img.bottomY = self.height / 2.f;
        
        [self addSubview:img];
        _loadingView = img;
    }
    return _loadingView;
}

- (UILabel *)titleLabel {
        
    if (!_titleLabel) {
        
        float height = adaptToWidth(40);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [WVRAppModel fontFitForSize:15.5];
        label.text = [NSString stringWithFormat:@"即将播放：%@", _title];
        
        [self addSubview:label];
        _titleLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(height);
            make.left.equalTo(label.superview).offset(10);
            make.right.equalTo(label.superview).offset(-10);
            make.centerY.equalTo(label.superview).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel *)restartTitleLabel {
    
    if (!_restartTitleLabel) {
        
        float height = adaptToWidth(40);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [WVRAppModel fontFitForSize:15.5];
        label.text = _title;
        
        [self addSubview:label];
        _restartTitleLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(height);
            make.left.equalTo(label.superview).offset(fitToWidth(10));
            make.right.equalTo(label.superview).offset(-fitToWidth(10));
            make.centerY.equalTo(label.superview).offset(fitToWidth(20));
        }];
    }
    return _restartTitleLabel;
}

- (UIButton *)backBtn {
    
    // 只有横屏时才会有
//    if (self.width != MAX(SCREEN_WIDTH, SCREEN_HEIGHT)) { return nil; }
    
    if (!_backBtn) {
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(10, 25, 45, 30);
        [back setImage:[UIImage imageNamed:@"player_icon_back"] forState:UIControlStateNormal];
        back.imageView.contentMode = UIViewContentModeScaleAspectFit;
        back.showsTouchWhenHighlighted = YES;
        
        [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:back];
        _backBtn = back;
    }
    return _backBtn;
}

- (UIButton *)restartBackBtn {
    
    if (!_restartBackBtn) {
        
        // 只有横屏时才会有
        if (self.width < _maxWidth) { return nil; }
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(10, 25, 45, 30);
        [back setImage:[UIImage imageNamed:@"player_icon_back"] forState:UIControlStateNormal];
        back.imageView.contentMode = UIViewContentModeScaleAspectFit;
        back.showsTouchWhenHighlighted = YES;
        
        [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:back];
        _restartBackBtn = back;
    }
    return _restartBackBtn;
}

- (void)topicBackTitle {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = _title;
    label.font = self.restartTitleLabel.font;
    label.textColor = self.restartTitleLabel.textColor;
    
    [self addSubview:label];
    
    kWeakSelf(self);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.restartBackBtn.mas_right).offset(fitToWidth(5));
        make.centerY.equalTo(weakself.restartBackBtn);
    }];
}

- (UIButton *)vrBackBtn
{
    if (!_vrBackBtn) {
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setImage:[UIImage imageNamed:@"player_icon_back"] forState:UIControlStateNormal];
        back.imageView.contentMode = UIViewContentModeScaleAspectFit;
        back.showsTouchWhenHighlighted = YES;
        
        [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(fitToWidth(10.f));
            make.bottom.equalTo(self).offset(-fitToWidth(15.f));
            make.width.mas_equalTo(fitToWidth(45));
            make.height.mas_equalTo(fitToWidth(30));
        }];
        _vrBackBtn = back;
    }
    return _vrBackBtn;
}

- (BOOL)isLoading {
    
    return _isLoading && self.superview;
}

#pragma mark - notification

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

- (void)registeNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)appWillEnterForeground:(NSNotification *)noti {
    
    if (_isLoading && self.superview) {
        [self stopAnimation];
    }
}

#pragma mark - pravite func

- (void)createTimer {
    
    if (_countdownTimer) {
        [_countdownTimer invalidate];
    }
    _timerCount = 5;
    kWeakSelf(self);
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
    
    [weakself timerCountdown];
}

- (void)timerCountdown {
    
    if (_timerCount <= 0) {
        [self playNextBtnClick:nil];
        return;
    }
    
    self.restartTitleLabel.text = [NSString stringWithFormat:@"%d秒后即将播放:%@", _timerCount, _nextTitle];
    
    _timerCount -= 1;   // --
}

- (void)startAnimation {
    
    _isLoading = YES;
    self.hidden = NO;
    [self loadingAnimations];
}

- (void)loadingAnimations {
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.fromValue = [NSNumber numberWithDouble:(0 - SCREEN_WIDTH)];
    positionAnimation.toValue = [NSNumber numberWithDouble:SCREEN_WIDTH];
    positionAnimation.duration = 1.2 * SCREEN_WIDTH / MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    positionAnimation.repeatCount = MAXFLOAT;
    [self.loadingView.layer addAnimation:positionAnimation forKey:@"position"];
}

- (void)stopAnimation {
    
    [self.loadingView.layer removeAnimationForKey:@"position"];
    [self.loadingView removeFromSuperview];
    _isLoading = NO;
}

- (void)addRetryBtn {
    
    // 避免用户点击多个视频后按钮重叠
    if (_retryBtn.superview == self) { return; }
    
    UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    retryBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    float fit = self.height / 375.f;
    float height = 40 * fit;
    float width = 100 * fit;
    retryBtn.frame = CGRectMake(0, 0, width, height);
    
    retryBtn.clipsToBounds = YES;
    retryBtn.layer.cornerRadius = adaptToWidth(5);
    
    [retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retryBtn setImage:[UIImage imageNamed:@"player_icon_retry_normal"] forState:UIControlStateNormal];
    [retryBtn setImage:[UIImage imageNamed:@"player_icon_retry_press"] forState:UIControlStateNormal];
    
    [retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:retryBtn];
    self.retryBtn = retryBtn;
    
    kWeakSelf(self);
    [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.centerX.equalTo(retryBtn.superview);
        make.centerY.equalTo(weakself.titleLabel.mas_bottom).offset(20);
    }];
}

- (void)configImageForImageView {
    
//    float minW = MIN(self.width, self.width);
//    float maxW = MAX(self.width, self.width);
//    if (minW < _minWidth) {
//        _imageView.image = [UIImage imageNamed:@"player_start_background_half"];
//    } else if (minW == maxW) {
//        _imageView.image = [UIImage imageNamed:@"player_start_background_vrHalf"];
//    } else if (maxW == _maxWidth) {
        _imageView.image = [UIImage imageNamed:@"player_start_background_full"];
//    }
}

- (void)removeUnuseUI {
    
    [self.retryBtn removeFromSuperview];
    [self.remindLabel removeFromSuperview];
    [self.buyBtn removeFromSuperview];
    [self.reTrialBtn removeFromSuperview];
}

#pragma mark - external func

- (void)onErrorWithMsg:(NSString *)msg code:(NSInteger)code {
    
    _isErrorStatus = YES;
    
    // 重试
    [self stopAnimation];
    [self addRetryBtn];
    
    self.titleLabel.text = [NSString stringWithFormat:@"播放失败  错误码：%d", (int)code];
}

- (void)dismiss {
    
    [self stopAnimation];
    self.hidden = YES;
//    [self removeFromSuperview];
}

- (void)resetStatus:(NSString *)title {
    _title = title;
    
    _isErrorStatus = NO;
    [self removeUnuseUI];
    
    self.logo.hidden = NO;
    self.titleLabel.hidden = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"即将播放：%@", _title];;
    
    [self configImageForImageView];
    
    [self startAnimation];
}

- (void)resetStatusToPaymentWithTrail:(BOOL)canTrail price:(NSString *)price {
    
//    if (_isErrorStatus) { return; }
    
    [self stopAnimation];
    [_retryBtn removeFromSuperview];
    _titleLabel.hidden = YES;
    _logo.hidden = YES;
    
    if (self.remindLabel.superview) { return; }
    
    [self createRemindLabel:canTrail];
    
//    if (self.width == MAX(SCREEN_WIDTH, SCREEN_HEIGHT)) {
        [self createBuyBtn:canTrail];
//    } else {
//        _buyBtn = nil;
//    }
    
    if (canTrail) {
        [self createRetrailBtn];
    }
}

- (void)viewWillRotationToVertical {
    
    [_buyBtn removeFromSuperview];
    _buyBtn = nil;
}

- (BOOL)playerUINotAutoHide {
    
    return YES;
}

- (void)createRemindLabel:(BOOL)canTrail {
    
    UILabel *remindLabel = [[UILabel alloc] init];
    
    NSString *str = [NSString stringWithFormat:@"请购买观看券观看完整视频"];
    if (canTrail) {
        NSString *tmp = @"试看已结束，";
        str = [tmp stringByAppendingString:str];
    }
    remindLabel.text = str;
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.font = kFontFitForSize(14);
    [remindLabel sizeToFit];
    
    remindLabel.centerX = self.width / 2.f;
    remindLabel.bottomY = self.height / 2.f - adaptToWidth(15);
    
    [self addSubview:remindLabel];
    _remindLabel = remindLabel;
    
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(remindLabel.superview);
        make.bottom.equalTo(remindLabel.superview.mas_centerY).offset(0 - adaptToWidth(15));
        make.width.mas_equalTo(remindLabel.width);
        make.height.mas_equalTo(remindLabel.height);
    }];
}

- (void)createBuyBtn:(BOOL)canTrail {
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    
    float width = adaptToWidth(95);
    float x_gap = canTrail ? (0 - adaptToWidth(15) - width) : (0 - width * 0.5);
    
    buyBtn.frame = CGRectMake(self.width / 2.f + x_gap, _remindLabel.bottomY + adaptToWidth(28), width, adaptToWidth(30));
    buyBtn.bottomX = self.width / 2.f - adaptToWidth(12.5);
    
    buyBtn.layer.cornerRadius = buyBtn.height / 2.f;
    buyBtn.layer.masksToBounds = YES;
    buyBtn.backgroundColor = k_Color15;
    buyBtn.titleLabel.textColor = [UIColor whiteColor];
    [buyBtn.titleLabel setFont:kFontFitForSize(13)];
    
    [buyBtn addTarget:self action:@selector(payForVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buyBtn];
    _buyBtn = buyBtn;
    
    kWeakSelf(self);
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(buyBtn.superview.mas_centerX).offset(x_gap);
        make.width.mas_equalTo(buyBtn.width);
        make.height.mas_equalTo(buyBtn.height);
        make.top.equalTo(weakself.remindLabel.mas_bottom).offset(adaptToWidth(28));
    }];
}

- (void)createRetrailBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"重新试看" forState:UIControlStateNormal];
    
    float width = adaptToWidth(95);
    float x_gap = (_buyBtn.superview == nil) ? (0 - width * 0.5) : adaptToWidth(12.5);
    
    btn.frame = CGRectMake(self.width * 0.5 + x_gap, _remindLabel.bottomY + adaptToWidth(28), width, adaptToWidth(30));
    btn.titleLabel.textColor = [k_Color12 colorWithAlphaComponent:0.7];
    [btn.titleLabel setFont:kFontFitForSize(13)];
    
    btn.layer.cornerRadius = btn.height / 2.f;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = btn.titleLabel.textColor.CGColor;
    
    [btn addTarget:self action:@selector(actionRetryTryAndSeeOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    _reTrialBtn = btn;
    
    kWeakSelf(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(btn.superview.mas_centerX).offset(x_gap);
        make.width.mas_equalTo(btn.width);
        make.height.mas_equalTo(btn.height);
        make.top.equalTo(weakself.remindLabel.mas_bottom).offset(adaptToWidth(28));
    }];
}

- (void)createRestartBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"重新播放" forState:UIControlStateNormal];
    
    float width = adaptToWidth(95);
    float x_gap = (_buyBtn.superview == nil) ? (0 - width * 0.5) : adaptToWidth(12.5);
    
    btn.frame = CGRectMake(self.width * 0.5 + x_gap, _remindLabel.bottomY + adaptToWidth(28), width, adaptToWidth(30));
    btn.titleLabel.textColor = [k_Color12 colorWithAlphaComponent:0.7];
    [btn.titleLabel setFont:kFontFitForSize(13)];
    
    btn.layer.cornerRadius = btn.height / 2.f;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = btn.titleLabel.textColor.CGColor;
    
    [btn addTarget:self action:@selector(restartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    _reTrialBtn = btn;
    
    kWeakSelf(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(btn.width);
        make.height.mas_equalTo(btn.height);
        make.center.equalTo(weakself);
    }];
}

- (void)createRestartBtnForCompilation {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"重播" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"player_icon_restart"] forState:UIControlStateNormal];
    
    btn.bounds = CGRectMake(0, 0, adaptToWidth(45), adaptToWidth(60));
    btn.titleLabel.textColor = [k_Color12 colorWithAlphaComponent:0.7];
    [btn.titleLabel setFont:kFontFitForSize(13)];
    
    [btn addTarget:self action:@selector(restartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn centerImageAndTitle];
    
    [self addSubview:btn];
    _reTrialBtn = btn;
    
    kWeakSelf(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(btn.width);
        make.height.mas_equalTo(btn.height);
        make.centerX.equalTo(weakself);
        make.top.equalTo(weakself.restartTitleLabel.mas_bottom).offset(-fitToWidth(5));
    }];
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"下一个" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_player_next_normal"] forState:UIControlStateNormal];
        
        btn.bounds = CGRectMake(0, 0, adaptToWidth(45), adaptToWidth(60));
        btn.titleLabel.textColor = [k_Color12 colorWithAlphaComponent:0.7];
        [btn.titleLabel setFont:kFontFitForSize(13)];
        
        [btn addTarget:self action:@selector(playNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn centerImageAndTitle];
        
        [self addSubview:btn];
        _nextBtn = btn;
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(btn.width);
            make.height.mas_equalTo(btn.height);
            make.left.equalTo(weakself.mas_centerX).offset(fitToWidth(20));
            make.top.equalTo(weakself.reTrialBtn.mas_top);
        }];
    }
    return _nextBtn;
}

- (void)checkAnimation {
    
    if (self.isLoading) { [self startAnimation]; }
}

#pragma mark - action

- (void)restartBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    
    if ([self.realDelegate respondsToSelector:@selector(actionRestart)]) {
        [self.realDelegate actionRestart];
    }
}

- (void)playNextBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    
    if ([self.realDelegate respondsToSelector:@selector(actionPlayNext)]) {
        [self.realDelegate actionPlayNext];
    }
}

- (void)payForVideo {
    
    UIViewController *currentVC = [UIViewController getCurrentVC];
    if ([currentVC isKindOfClass:NSClassFromString(@"WVRDetailVC")]) {
        self.backBtn.hidden = YES;
    }
    [self.realDelegate actionGotoBuy];
}

- (void)retryBtnClick:(UIButton *)sender {
    
    [self removeUnuseUI];
    
    [self startAnimation];
    self.titleLabel.hidden = NO;
    self.logo.hidden = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"即将播放：%@", _title];;
    
    [self.realDelegate actionRetry];
}

- (void)actionRetryTryAndSeeOnClick:(UIButton *)sender {
    
    [self removeUnuseUI];
    
    [self startAnimation];
    self.titleLabel.hidden = NO;
    self.logo.hidden = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"即将播放：%@", _title];
    
    [self.realDelegate actionRetryTryAndSee];
}

- (void)backBtnClick:(UIButton *)sender {
    
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    
    [self.realDelegate backOnClick:sender];
}

#pragma mark - user interface enabled

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *retView = [super hitTest:point withEvent:event];
    if (retView == self) {
        return nil;
    }
    
    return retView;
}

@end

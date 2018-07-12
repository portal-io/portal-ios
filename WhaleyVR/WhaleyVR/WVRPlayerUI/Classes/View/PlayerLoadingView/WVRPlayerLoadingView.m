//
//  WVRPlayerLoadingView.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/22.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器加载视图，显示网速

#import "WVRPlayerLoadingView.h"
#import "WVRPlayLoadingCellViewModel.h"
//#import "WVRPlayerStartController.h"
#import "WVRPlayerStartView.h"

@interface WVRPlayerLoadingView ()

@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UILabel *speedLabel;
@property (nonatomic, weak) UIView *normalBackGround;

@property (nonatomic, assign) BOOL isVRMode;

@property (nonatomic, weak) UIActivityIndicatorView *activityVRL;
@property (nonatomic, weak) UIActivityIndicatorView *activityVRR;

@property (nonatomic, strong) NSString * gTip;

@property (strong, nonatomic) UIButton *gPauseStatusView;

@property (strong, nonatomic) WVRPlayerStartView *gStartView;

@end


@implementation WVRPlayerLoadingView
@synthesize gViewModel = _gViewModel;

- (void)setGViewModel:(WVRPlayViewCellViewModel *)gViewModel
{
    _gViewModel = gViewModel;
}

- (WVRPlayLoadingCellViewModel *)gViewModel
{
    return (WVRPlayLoadingCellViewModel*)_gViewModel;
}

static NSString *const defLoadingStr = @"加载中...";

- (instancetype)init NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE {
    
    return nil;
}

- (WVRPlayerStartView *)gStartView
{
    if (!_gStartView) {
        _gStartView = [[WVRPlayerStartView alloc] init];
        [self addSubview:_gStartView];
        [_gStartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
        }];
    }
    return _gStartView;
}

- (UIButton *)gPauseStatusView
{
    if (!_gPauseStatusView) {
        _gPauseStatusView = [[UIButton alloc] init];
        [_gPauseStatusView setImage:[UIImage imageNamed:@"icon_player_pause_for_vrMode"] forState:UIControlStateNormal];
        _gPauseStatusView.clipsToBounds = YES;
        _gPauseStatusView.layer.cornerRadius = fitToWidth(6);
        _gPauseStatusView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:_gPauseStatusView];
        [_gPauseStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(fitToWidth(60));
            make.height.mas_equalTo(fitToWidth(60));
        }];
    }
    return _gPauseStatusView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (void)installRAC
{
    @weakify(self);
    [RACObserve(self.gViewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus:self.gViewModel.playStatus];
    }];
    [RACObserve(((WVRPlayLoadingCellViewModel*)self.gViewModel), gNetSpeed) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateNetSpeed:((WVRPlayLoadingCellViewModel*)self.gViewModel).gNetSpeed];
    }];
    [RACObserve(((WVRPlayLoadingCellViewModel*)self.gViewModel), gTipStr) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateTip:x];
    }];
    [RACObserve(((WVRPlayLoadingCellViewModel*)self.gViewModel), gHidenBack) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.gStartView hidenbackBtn:((WVRPlayLoadingCellViewModel*)self.gViewModel).gHidenBack];
    }];
    [RACObserve(self.gViewModel, vrStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateVRStatus:self.gViewModel.vrStatus];
    }];
    [RACObserve(self.gViewModel, gPayStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updatePayStatus:self.gViewModel.gPayStatus];
    }];
    [RACObserve(self, gViewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gStartView.realDelegate = self.gViewModel.delegate;
        self.gStartView.gHidenVRBackBtn = ((WVRPlayLoadingCellViewModel*)self.gViewModel).gHidenVRBackBtn;
    }];
}

- (void)fillData:(WVRPlayViewCellViewModel *)args
{
    if (self.gViewModel == args) {
        [self updateStatus:self.gViewModel.playStatus];
        return;
    }
    self.gViewModel = (WVRPlayLoadingCellViewModel*)args;
    self.gTip = defLoadingStr;
    
    [self activityView];
    [self speedLabel];
    [self normalBackGround];
    
    [self activityVRL];
    [self activityVRR];
    
    [self switchVR:NO];
    [self installRAC];
}

- (void)updateVRStatus:(WVRPlayerToolVStatus)status
{
    switch (status) {
        case WVRPlayerToolVStatusVR:
            [self enableVRStatus];
            break;
        case WVRPlayerToolVStatusNotVR:
            [self enableNotVRStatus];
            break;
        default:
            break;
    }
}

- (void)enableVRStatus
{
    self.gStartView.gHidenBackgroundImage = YES;
}

- (void)enableNotVRStatus
{
    self.gStartView.gHidenBackgroundImage = NO;
}

- (instancetype)initWithContentView:(UIView *)contentView isVRMode:(BOOL)vrMode {
    
    float width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT) / 2.0;
    CGRect rect = CGRectMake(0, 0, width, 30);
    
    self = [super initWithFrame:rect];
    if (self) {
        
        [self configSelfWithContentView:contentView];
        
        [self activityView];
        [self speedLabel];
        [self normalBackGround];
        
        [self activityVRL];
        [self activityVRR];
        
        [self switchVR:vrMode];
    }
    return self;
}

- (void)updatePayStatus:(WVRPlayerToolVStatus)status
{
    [super updatePayStatus:status];
    switch (status) {
        case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        case WVRPlayerToolVStatusPaySuccess:
            
            break;
        default:
            break;
    }
}

#pragma mark - updateStatus

- (void)updateStatus:(WVRPlayerToolVStatus)status {
//    DebugLog(@"play_UI_updateStatus:%d",(int)status);
    [super updateStatus:status];
    if (self.gViewModel.gPayStatus == WVRPlayerToolVStatusWatingPay) {//如果是等待支付状态，一切操作都不响应
        
        return;
    }
    self.hidden = NO;
    switch (status) {
        case WVRPlayerToolVStatusDefault:
            [self enableDefaultStatus];
            break;
        case WVRPlayerToolVStatusPreparing:
            [self enablePreparingStatus];
            break;
        case WVRPlayerToolVStatusPrepared:
            [self enablePreparedStatus];
            break;
        case WVRPlayerToolVStatusPlaying:
            [self enablePlayingStatus];
            break;
        case WVRPlayerToolVStatusPause:
        case WVRPlayerToolVStatusUserPause:
            [self enablePauseStatus];
            break;
        case WVRPlayerToolVStatusStop:
            [self enableStopStatus];
            break;
        case WVRPlayerToolVStatusComplete:
            [self enableCompleteStatus];
            break;
        case WVRPlayerToolVStatusError:
            [self enableErrorStatus];
            break;
        case WVRPlayerToolVStatusChangeQuality:
            [self enableChangeQuStatus];
            break;
        case WVRPlayerToolVStatusSliding:
            [self enableSlidingStatus];
            break;
        case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        case WVRPlayerToolVStatusDramaPlayEnd:
            [self enableDramaPlayEndStatus];
            break;
        default:
            break;
    }
}

- (void)enableNotClockStatus {
    self.hidden = NO;
    self.gStartView.hidden = YES;
    self.gPauseStatusView.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enableDefaultStatus {
    self.gStartView.hidden = YES;
    self.gPauseStatusView.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enablePreparingStatus {
    self.gPauseStatusView.hidden = YES;
    if (((WVRPlayLoadingCellViewModel*)self.gViewModel).gIsLive) {
        [self startAnimating:NO];
        self.gStartView.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        [self stopAnimating];
        [self.gStartView resetStatus:((WVRPlayLoadingCellViewModel*)self.gViewModel).gTitle];
        self.gStartView.hidden = NO;
        self.userInteractionEnabled = YES;
        self.hidden = NO;
        [self.superview bringSubviewToFront:self];
    }
}

- (void)enablePreparedStatus {
    [self stopAnimating];
    [self.gStartView dismiss];
    self.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enablePlayingStatus {
    [self stopAnimating];
    [self.gStartView dismiss];
    self.gPauseStatusView.hidden = YES;
    self.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enablePauseStatus {
    [self stopAnimating];
    [self.gStartView dismiss];
    self.hidden = NO;
    switch (self.gViewModel.vrStatus) {
        case WVRPlayerToolVStatusVR:
            self.gPauseStatusView.hidden = NO;
            break;
        default:
            self.gPauseStatusView.hidden = YES;
            break;
    }
    self.userInteractionEnabled = NO;
}

- (void)enableStopStatus {
    [self stopAnimating];
    [self.gStartView dismiss];
    self.hidden = NO;
    switch (self.gViewModel.vrStatus) {
        case WVRPlayerToolVStatusVR:
            self.gPauseStatusView.hidden = NO;
            break;
        default:
            self.gPauseStatusView.hidden = YES;
            break;
    }
    self.userInteractionEnabled = NO;
}

- (void)enableCompleteStatus {
    
    [self stopAnimating];
    self.hidden = YES;
    self.gPauseStatusView.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enableErrorStatus {
    if (((WVRPlayLoadingCellViewModel*)self.gViewModel).gIsLive) {
        [self startAnimating:NO];
        self.gStartView.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        [self stopAnimating];
        [self.gStartView onErrorWithMsg:((WVRPlayLoadingCellViewModel*)self.gViewModel).gErrorMsg code:((WVRPlayLoadingCellViewModel*)self.gViewModel).gErrorCode];
        self.gStartView.hidden = NO;
        self.hidden = NO;
        self.gPauseStatusView.hidden = YES;
        self.userInteractionEnabled = YES;
        [self.superview bringSubviewToFront:self];
    }
    
}

- (void)enableChangeQuStatus {
    [self startAnimating:NO];
    [self.gStartView dismiss];
    self.hidden = NO;
    self.gPauseStatusView.hidden = YES;
    self.userInteractionEnabled = NO;
    [self.superview bringSubviewToFront:self];
}

- (void)enableSlidingStatus {
    [self startAnimating:NO];
    [self.gStartView dismiss];
    self.hidden = NO;
    self.gPauseStatusView.hidden = YES;
    self.userInteractionEnabled = NO;
    [self.superview bringSubviewToFront:self];
}

- (void)enableWatingPayStatus
{
    [self stopAnimating];
    if (((WVRPlayLoadingCellViewModel*)self.gViewModel).gIsLive) {
        [self stopAnimating];
        self.hidden = YES;
        self.gStartView.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        [self.gStartView resetStatusToPaymentWithTrail:((WVRPlayLoadingCellViewModel*)self.gViewModel).gCanTrail price:((WVRPlayLoadingCellViewModel*)self.gViewModel).gPrice];
        self.gStartView.hidden = NO;
        self.hidden = NO;
        self.gPauseStatusView.hidden = YES;
        self.userInteractionEnabled = YES;
        [self.superview bringSubviewToFront:self];
    }
}

- (void)enableDramaPlayEndStatus {
    
//    [self stopAnimating];
//    self.hidden = NO;
//    self.gPauseStatusView.hidden = YES;
//    self.userInteractionEnabled = YES;
//    
//    WVRPlayerStartView *startV = [[WVRPlayerStartView alloc] initWithContainerView:self.superview];
//    startV.realDelegate = (id)self.gStartView.realDelegate;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (!self.gStartView.hidden) {
//        return self.gStartView;
//    }else{
//        return nil;
//    }
//}

- (void)configSelfWithContentView:(UIView *)contentView {
    
    [contentView addSubview:self];
    
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.center = CGPointMake(contentView.width * 0.5, contentView.height * 0.5);
    
    self.gTip = defLoadingStr;
    
//    // 20171011新增，loading view居中显示
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(contentView);
//        make.right.equalTo(contentView);
//        make.height.equalTo(@30);
//        make.centerY.equalTo(contentView);
//    }];
}

#pragma mark - subviews

- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.centerX = self.normalBackGround.width * 0.5;
        activityView.bottomY = self.normalBackGround.height * 0.35;
        activityView.hidesWhenStopped = YES;
        [self.normalBackGround addSubview:activityView];
        
        _activityView = activityView;
    }
    return _activityView;
}

- (UILabel *)speedLabel {
    
    if (!_speedLabel) {
        UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.normalBackGround.height * 0.55, self.normalBackGround.width, adaptToWidth(20))];
        speedLabel.font = [WVRAppModel fontFitForSize:12];
        speedLabel.textColor = [UIColor whiteColor];
        speedLabel.text = self.gTip;
        speedLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.normalBackGround addSubview:speedLabel];
        
        _speedLabel = speedLabel;
    }
    return _speedLabel;
}

- (UIView *)normalBackGround {
    
    if (!_normalBackGround) {
        
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) * 0.36;
        
        CGRect rect = CGRectMake(0, 0, width, width * 0.62);
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.center = CGPointMake(self.width * 0.5, self.height * 0.5);
        
        view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        view.layer.cornerRadius = adaptToWidth(7);
        view.clipsToBounds = YES;
        
        [self addSubview:view];
        _normalBackGround = view;
    }
    return _normalBackGround;
}

- (IBAction)btnOnClick:(id)sender {
    
    SQToastInKeyWindow(@"jjjj");
}

- (UIActivityIndicatorView *)activityVRL {
    if (!_activityVRL) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.centerX = 0;
        activityView.centerY = self.height * 0.5;
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
        _activityVRL = activityView;
    }
    return _activityVRL;
}

- (UIActivityIndicatorView *)activityVRR {
    if (!_activityVRR) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.centerX = self.width;
        activityView.centerY = self.activityVRL.centerY;
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
        _activityVRR = activityView;
    }
    return _activityVRR;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.normalBackGround.center = CGPointMake(self.width * 0.5, self.height * 0.5);;
    self.activityView.centerX = self.normalBackGround.width * 0.5;
    self.activityView.bottomY = self.normalBackGround.height * 0.35;
    self.activityVRL.centerX = 0;
    self.activityVRL.centerY = self.height * 0.5;
    self.activityVRR.centerX = self.width;
    self.activityVRR.centerY = self.activityVRL.centerY;
    self.speedLabel.frame = CGRectMake(0, self.normalBackGround.height * 0.55, self.normalBackGround.width, adaptToWidth(20));
}

#pragma mark - external func

- (void)updateNetSpeed:(long)speed {
    
    if (self.hidden || _isVRMode) { return; }
    
    NSString *sp = @"";
    
    if (speed > 1048576) {
        float num = speed / 1048576.f;
        sp = [NSString stringWithFormat:@"%.1fMB/s", num];
        
    } else if (speed > 1024) {
        int num = (int)speed / 1024;
        sp = [NSString stringWithFormat:@"%dKB/s", num];
    } else if (speed >= 0) {
        sp = [NSString stringWithFormat:@"%dB/s", (int)speed];
    } else {
//        sp = [NSString stringWithFormat:@"%dB/s", 0];
    }
    
    _speedLabel.text = [NSString stringWithFormat:@"%@ %@", self.gTip, sp];
}

- (void)startAnimating:(BOOL)isVRMode {
    
    _isVRMode = isVRMode;
    
    if (isVRMode) {
        [self showWithVRMode];
    } else {
        [self showWithNotVRMode];
    }
    
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    
//    Class cls = NSClassFromString(@"WVRPlayerStartView");
//    for (UIView *view in self.superview.subviews) {
//        if ([view isKindOfClass:cls]) {
//
//            [self.superview bringSubviewToFront:self];
//        }
//    }
}

- (void)stopAnimating {
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)view stopAnimating];
        }
        view.hidden = YES;
    }
    
//    self.hidden = YES;
}

- (void)showWithNotVRMode {
    
    self.normalBackGround.hidden = NO;
    [self.activityView startAnimating];
    self.speedLabel.hidden = NO;
    
    [self.activityVRL stopAnimating];
    [self.activityVRR stopAnimating];
}

- (void)showWithVRMode {
    
    [self.activityVRL startAnimating];
    [self.activityVRR startAnimating];
    
    self.normalBackGround.hidden = YES;
    [self.activityView stopAnimating];
    self.speedLabel.hidden = YES;
}

- (void)switchVR:(BOOL)isVR {
    
    _isVRMode = isVR;
    
    if (_isVRMode) {
        [self showWithVRMode];
    } else {
        [self showWithNotVRMode];
    }
    
    // 注意最上层可能有悬浮层
    [self.superview bringSubviewToFront:self];
}

- (void)updateTip:(NSString *)tip {
    if(tip.length > 0)
        self.gTip = tip;
}


@end

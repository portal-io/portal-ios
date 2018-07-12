//
//  WVRSmallPlayerToolView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 全景点播，华数视频（点播）

#import "WVRPlayerSmallBottomView.h"
#import "WVRSlider.h"
#import "WVRSpring2018Manager.h"

@interface WVRPlayerSmallBottomView ()

@property (nonatomic, weak) UIView *bottomShadow;       // layer

@property (nonatomic) WVRPlayerToolVStatus mStatus;
@property (nonatomic, assign) BOOL gIsPlay;

@property (nonatomic) CAGradientLayer *gradientLayer;

@end


@implementation WVRPlayerSmallBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self bottomShadow];
    [self registEvents];
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
    [RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), position) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updatePosition:((WVRPlayBottomCellViewModel*)self.gViewModel).position buffer:((WVRPlayBottomCellViewModel*)self.gViewModel).bufferPosition duration:((WVRPlayBottomCellViewModel*)self.gViewModel).duration];
    }];
    
    [RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), toFullIcon) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString * str = ((WVRPlayBottomCellViewModel*)self.gViewModel).toFullIcon;
        if (str.length==0) {
            str = @"player_icon_toFull";
        }
        [self.fullBtn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    }];
}

- (void)fillData:(WVRPlayBottomCellViewModel *)args
{
    if(self.gViewModel == args){
        return;
    }
    self.gViewModel = args;
    self.processSlider.realDelegate = self.gViewModel.delegate;
    [self installRAC];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGFloat yOffset = point.y;
    BOOL response = yOffset > 0;
    
    return response;
}

- (UIView *)bottomShadow {

    if (!_bottomShadow) {
        
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), HEIGHT_DEFAULT)];
        
        // 设置渐变效果
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = bottomShadow.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                                (id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor], nil];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        [bottomShadow.layer insertSublayer:_gradientLayer atIndex:0];
        
        bottomShadow.backgroundColor = [UIColor clearColor];
        bottomShadow.userInteractionEnabled = NO;
        [self insertSubview:bottomShadow atIndex:0];
        bottomShadow.bottomY = self.height;
        
        _bottomShadow = bottomShadow;
    }
    return _bottomShadow;
}

- (void)layoutSubviews {
    
    self.bottomShadow.frame = self.bounds;
    self.gradientLayer.frame = self.bottomShadow.bounds;
    [self updateLeadingCons];
//    NSArray * cons = self.constraints;
//    for (NSLayoutConstraint* cur in cons) {
//        if (cur.firstItem == self.startBtn) {
//            if (cur.firstAttribute == NSLayoutAttributeTop) {
//                cur.constant = (self.height-self.startBtn.height)/2;
//            }
//        }
//    }
}

- (void)updateLeadingCons
{
//    self.startBtn.top = (self.height-self.startBtn.height)/2;
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* cur in cons) {
        if (cur.firstItem == self.startBtn) {
            if (cur.firstAttribute == NSLayoutAttributeTop) {
                cur.constant = (self.height - self.startBtn.height)/2;
            }
        }
    }
    
    if ((SCREEN_WIDTH > SCREEN_HEIGHT) && kDevice_Is_iPhoneX) {
        self.playBtnLeadingCons.constant = kStatuBarHeight + 15.f;
        self.lastRigtBtnTrainingCons.constant = kTabBarHeight - 49.f + 15.f;
    } else {
        self.playBtnLeadingCons.constant = 15.f;
        self.lastRigtBtnTrainingCons.constant = 15.f;
    }
}

- (WVRPlayerToolVStatus )getStatus {
    
    return _mStatus;
}

- (void)registEvents {
    
    [self.startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullBtn addTarget:self action:@selector(fullBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.launchBtn addTarget:self action:@selector(launchOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.processSlider addTarget:self action:@selector(sliderDragEnd:) forControlEvents:UIControlEventValueChanged];
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.gViewModel.delegate respondsToSelector:@selector(playOnClick:)])
    {
        self.gIsPlay = sender.selected;
        [self.gViewModel.delegate playOnClick:sender.selected];
    }
}

- (void)fullBtnOnClick:(UIButton *)sender {
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(fullOnClick:)]) {
        [self.gViewModel.delegate fullOnClick:nil];
    }
}

static NSTimeInterval _klaunchOnClickTime = 0;

- (void)launchOnClick:(UIButton *)sender {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - _klaunchOnClickTime < 0.7) {
        return;
    }
    _klaunchOnClickTime = now;
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(launchOnClick:)]) {
        [self.gViewModel.delegate launchOnClick:sender];
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
    if (self.gViewModel.gPayStatus == WVRPlayerToolVStatusWatingPay) {//如果是等待支付状态，一切操作都不响应
        
        return;
    }
    self.fullBtn.enabled = YES;
    switch (status) {
        case WVRPlayerToolVStatusDefault:
            [self enableDefaultStatus];
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
        default:
            break;
    }
}

- (void)updatePlayBtnStatus:(BOOL)isPlaying {
    
    int status = isPlaying ? 1 : 0;
    if (self.startBtn.tag == status) { return; }
    
    self.startBtn.tag = status;
    self.startBtn.selected = isPlaying;
}

- (void)enableNotClockStatus {
    self.hidden = NO;
//    if (self.gIsPlay) {
//        [self enablePlayingStatus];
//    } else {
//
//    }
}

- (void)enableDefaultStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = NO;
    self.processSlider.enabled = NO;
}

- (void)enablePreparedStatus {
    
    self.startBtn.selected = YES;
    self.startBtn.userInteractionEnabled = YES;
    self.processSlider.enabled = YES;
    self.fullBtn.userInteractionEnabled = YES;
    self.defiButton.userInteractionEnabled = YES;
}

- (void)enablePlayingStatus {
    
    self.startBtn.selected = YES;
    self.startBtn.userInteractionEnabled = YES;
    self.processSlider.enabled = YES;
    self.launchBtn.userInteractionEnabled = YES;
    self.defiButton.userInteractionEnabled = YES;
}

- (void)enablePauseStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;
    self.processSlider.enabled = YES;
    self.launchBtn.userInteractionEnabled = YES;
    self.defiButton.userInteractionEnabled = YES;
}

- (void)enableStopStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;
    self.processSlider.enabled = YES;
    self.launchBtn.userInteractionEnabled = YES;
    self.defiButton.userInteractionEnabled = YES;
}

- (void)enableCompleteStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;
    self.processSlider.enabled = YES;
    [self updatePosition:0 buffer:0 duration:((WVRPlayBottomCellViewModel*)self.gViewModel).duration];
    self.launchBtn.userInteractionEnabled = YES;
    self.defiButton.userInteractionEnabled = YES;
}

- (void)enableErrorStatus {
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = NO;
    self.processSlider.enabled = NO;
//    self.hidden = YES;
}

- (void)enableChangeQuStatus {
    
    self.startBtn.selected = YES;
    self.startBtn.userInteractionEnabled = NO;
    self.processSlider.enabled = NO;
    self.fullBtn.enabled = NO;
    self.launchBtn.userInteractionEnabled = NO;
    self.defiButton.userInteractionEnabled = NO;
}

- (void)enableSlidingStatus {
    
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = NO;
    self.processSlider.enabled = NO;
    self.launchBtn.userInteractionEnabled = NO;
    self.defiButton.userInteractionEnabled = NO;
    self.fullBtn.enabled = NO;
}

-(void)enableWatingPayStatus
{
    self.hidden = YES;
}

-(void)enablePaySuccessStatus
{
    self.hidden = NO;
}

- (void)updatePosition:(CGFloat)curPosition buffer:(CGFloat)buffer duration:(CGFloat)duration {
    
    [self.processSlider updatePosition:curPosition buffer:buffer duration:duration];
    self.curTimeL.text = [self numberToTime:curPosition/1000];
    self.totalTimeL.text = [self numberToTime:duration/1000];
}

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)time/60, (int)time%60];
}

#pragma mark - 子类调用

- (UIColor *)enableColor {
    
    return [UIColor whiteColor];
}

- (UIColor *)disableColor {
    
    return [UIColor colorWithWhite:0.8 alpha:1];
}


//-(BOOL)playerUINotAutoShow
//{
//    return (self.gViewModel.lockStatus == WVRPlayerToolVStatusLock);
//}

@end

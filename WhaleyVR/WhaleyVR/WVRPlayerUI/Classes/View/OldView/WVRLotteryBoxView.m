//
//  WVRLotteryBoxView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLotteryBoxView.h"
#import "WVRComputeTool.h"
#import "UIColor+Extend.h"
#import "WVRWidgetToastHeader.h"

//#import "UIView+Shake.h"

#define Angle(angle) ((angle) / 180.0 * M_PI)

#define MARGIN_TOP (4.f)

@interface WVRLotteryBoxView ()

@property (nonatomic, weak) UIImageView *lottery;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) CALayer *bgLayer;
@property (nonatomic, weak) UILabel *tmpLabel;
@property (nonatomic, assign) long time;

@property (nonatomic, assign) BOOL isAnimate;

@property (nonatomic, strong) NSDate *tapDate;

@property (nonatomic, assign) BOOL boxSwitch;
@property (nonatomic, assign) BOOL closeByUser;

@property (nonatomic, assign) BOOL notAutoShow;

@end


@implementation WVRLotteryBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        [self closeBtn];
        [self lottery];
        [self timeLabel];
        [self addBacgorundLayer];
        
        [self registeNotifications];
    }
    return self;
}

- (void)setNotAutoShow:(BOOL)notAutoShow {
    if (notAutoShow) {
        self.hidden = YES;
    } else if ([self isVisible]) {
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
    _notAutoShow = notAutoShow;
}

- (void)addBacgorundLayer {
    
    CALayer *layer = [[CALayer alloc] init];
    float x = fitToWidth(8);
    layer.frame = CGRectMake(x, x + MARGIN_TOP, self.width - 2 * x - MARGIN_TOP, self.height - 2 * x - MARGIN_TOP);
    //    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7].CGColor;
    layer.cornerRadius = fitToWidth(10.f);
    layer.masksToBounds = YES;
    
    [self.layer insertSublayer:layer atIndex:0];
    _bgLayer = layer;
}

#pragma mark - getter

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, adaptToWidth(20), adaptToWidth(20));
        btn.bottomX = self.width;
        [btn setImage:[UIImage imageNamed:@"player_lottery_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UIImageView *)lottery {
    
    if (!_lottery) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, self.height - MARGIN_TOP, self.height - MARGIN_TOP)];
//        CGFloat x = self.isLandscape? self.width-imgV.width-MARGIN_TOP:0;
//        imgV.x = x;
        imgV.image = [UIImage imageNamed:@"player_lottery_box"];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boxTapAction)];
        [imgV addGestureRecognizer:tap];
        
        [self addSubview:imgV];
        _lottery = imgV;
    }
    return _lottery;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        
        float x = self.lottery.bottomX + 6;
        
        UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(x, MARGIN_TOP, 80, self.height-MARGIN_TOP)];
        tmp.font = [UIFont systemFontOfSize:11.5];
        tmp.textColor = [UIColor whiteColor];
        tmp.text = @"离下次抽奖\n还剩";
        tmp.numberOfLines = 2;
        
        [self addSubview:tmp];
        _tmpLabel = tmp;
        
        CGSize size = [WVRComputeTool sizeOfString:@"还剩" Size:CGSizeMake(800, 800) Font:tmp.font];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + size.width + 1, (self.height+MARGIN_TOP)/2.0, 80, size.height + 1)];
        label.textColor = [UIColor colorWithHex:0xF7D154];
        label.font = tmp.font;
        label.text = [self timeToString:0];
        
        [self addSubview:label];
        _timeLabel = label;
    }
    return _timeLabel;
}

#pragma mark - notification

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registeNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)updateBoxXForDisplayMode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat x = self.isLandscape? self.width-self.lottery.width-MARGIN_TOP:0;
        self.lottery.x = x;
    });
}

- (void)appWillEnterForeground:(NSNotification *)noti {
    
    if (_isAnimate && self.superview) {
        [self boxStartAnimation];
    }
}

#pragma mark - external func

- (void)setBoxSwitch:(BOOL)isOpen {
    
    _boxSwitch = isOpen;
    if (!isOpen) {
        self.hidden = YES;
    } else if (self.notAutoShow) {
        self.hidden = YES;
    } else {
        if ([self isVisible]) {
            self.hidden = NO;
        } else {
            self.hidden = YES;
        }
    }
}

- (BOOL)isVisible {
    
    return (self.boxSwitch && !self.closeByUser);   // 用户手动关闭也算关闭
}

//- (BOOL)isClose {
//    
//    return self.closeByUser;
//}

- (void)updateCountDown:(long)time isShow:(BOOL)isShow {
    
    if (![self isVisible]) { return; }
    
    self.hidden = !isShow;
    _time = time;
    self.timeLabel.text = [self timeToString:time];
    
    if (time == 0) {
        [self boxStartAnimation];
    } else {
        
        [self hideOrShowSubviews:NO];
        
        [self boxStopAnimation];
    }
}

- (NSString *)timeToString:(long)time {
    
//    return [NSString stringWithFormat:@"%02d分%02d秒", (int)time/60, (int)time%60];
    return [NSString stringWithFormat:@"%d分%d秒", (int)time/60, (int)time%60];
}

#pragma mark - action

- (void)closeBtnClick:(UIButton *)sender {
    
    self.closeByUser = YES;
    [self boxStopAnimation];
    self.hidden = YES;
//    [self removeFromSuperview];
}

- (void)boxTapAction {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self.superview respondsToSelector:@selector(scheduleHideControls)]) {
        [self.superview performSelector:@selector(scheduleHideControls)];
    }
#pragma clang diagnostic pop
    
    if ([WVRReachabilityModel sharedInstance].isNoNet) {
        SQToastInKeyWindow(kNetError);
        return;
    }
    
    if (![self.liveDelegate actionCheckLogin]) { return; }
    
    if (![self.realDelegate isCharged]) {
        SQToastIn(kToastChargeLottery, self.superview);
        return;
    };
    
    if (self.time > 0) {
        
        NSString *str = [NSString stringWithFormat:@"离下次抽奖还剩%@", [self timeToString:_time]];
        SQToastInKeyWindow(str);
    } else {
        
        [self boxStopAnimation];
        
        if (_tapDate) {
            NSDate *now = [NSDate date];
            
            NSTimeInterval time = 0;
            time = [now timeIntervalSinceDate:_tapDate];
            if (time < 1.5) {
                return;         // 规避双击
            }
        }
        
        if ([self.liveDelegate respondsToSelector:@selector(actionEasterEggLottery)]) {
            [self.liveDelegate actionEasterEggLottery];
            _tapDate = [NSDate date];
        }
    }
}

- (void)boxStartAnimation {
    
    [self hideOrShowSubviews:YES];
    [self updateBoxXForDisplayMode];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[ @(Angle(-7)), @(Angle(7)), @(Angle(-7)) ];
    anim.repeatCount = LONG_MAX;
    anim.duration = 0.17;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.lottery.layer addAnimation:anim forKey:@"Shake"];
    
    _isAnimate = YES;
}

- (void)boxStopAnimation {
    self.lottery.x = 0;
    [self.lottery.layer removeAnimationForKey:@"Shake"];
    
    _isAnimate = NO;
}

- (void)hideOrShowSubviews:(BOOL)isHide {
    
    _closeBtn.hidden = isHide;
    _bgLayer.hidden = isHide;
    _timeLabel.hidden = isHide;
    _tmpLabel.hidden = isHide;
}

- (void)sleepForControllerChanged {
    
    if (_isAnimate) {
        [self.lottery.layer removeAnimationForKey:@"Shake"];
    }
}

- (void)resumeForControllerChanged {
    
    if (_isAnimate) {
        [self boxStartAnimation];
    }
}

- (BOOL)playerUINotAutoShow {
    
    return _notAutoShow;
}

- (BOOL)playerUINotAutoHide {
    
    return NO;
}

- (BOOL)closeByUser
{
    return _closeByUser;
}

@end


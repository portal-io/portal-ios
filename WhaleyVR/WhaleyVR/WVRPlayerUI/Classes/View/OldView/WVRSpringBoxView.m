//
//  WVRSpringBoxView.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 2018新春活动抽奖宝箱

#import "WVRSpringBoxView.h"
#import "WVRComputeTool.h"
#import "UIColor+Extend.h"
#import "WVRWidgetToastHeader.h"

#import "WVRSpring2018Manager.h"

//#import "UIView+Shake.h"

#define Angle(angle) ((angle) / 180.0 * M_PI)

#define MARGIN_TOP (4.f)

#define SECOND_TIME (60)

@interface WVRSpringBoxView ()

@property (nonatomic, weak) UIImageView *lottery;

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


@implementation WVRSpringBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (SCREEN_WIDTH == MIN(SCREEN_WIDTH, SCREEN_HEIGHT)) {
            // 竖屏状态下初始化完先隐藏
            self.hidden = YES;
        }
        
        [self lottery];
        [self timeLabel];
        [self addBacgorundLayer];
        
        [self registeNotifications];
        
        [self installRAC];
    }
    return self;
}

- (void)installRAC {
    @weakify(self);
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([[WVRUserModel sharedInstance] isisLogined]) {
            [self installLoginRAC];
        } else {
            [self refreshUINotLogin];
        }
    }];
}

- (void)installLoginRAC {
    
    self.hidden = YES;
    
    @weakify(self);
    [[[RACObserve([WVRSpring2018Manager shareInstance], leftCount) skip:1] take:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatusAfterLogin];
    }];
}

- (void)updateStatusAfterLogin {
    
    if (self.superview.width == MAX(SCREEN_WIDTH, SCREEN_HEIGHT)) {
        self.hidden = NO;
    }
    
    if ([[WVRSpring2018Manager shareInstance] leftCount] > 0) {
        
        _tmpLabel.text = @"离下次送福卡\n还剩";
        _timeLabel.text = [NSString stringWithFormat:@"%d秒", SECOND_TIME];
//        [self makeConstraintsToLeft];
    } else {
        [self leftCountUseUp];
    }
}

- (void)setNotAutoShow:(BOOL)notAutoShow {
//    if (notAutoShow) {
//        self.hidden = YES;
//    } else if ([self isVisible]) {
//        self.hidden = NO;
//    } else {
//        self.hidden = YES;
//    }
//    _notAutoShow = notAutoShow;
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

- (UIImageView *)lottery {
    
    if (!_lottery) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, self.height - MARGIN_TOP, self.height - MARGIN_TOP)];
//        CGFloat x = self.isLandscape? self.width-imgV.width-MARGIN_TOP:0;
//        imgV.x = x;
        imgV.image = [UIImage imageNamed:@"icon_spring_box_icon"];
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
        
        int count = [WVRSpring2018Manager shareInstance].leftCount;
        
        UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(x, MARGIN_TOP, 80, self.height-MARGIN_TOP)];
        tmp.font = [UIFont systemFontOfSize:11.5];
        tmp.textColor = [UIColor whiteColor];
        
        if (count > 0) {
            tmp.text = @"离下次送福卡\n还剩";
        } else {
            tmp.text = @"今天的机会已\n经用完";
        }
        tmp.numberOfLines = 2;
        
        [self addSubview:tmp];
        _tmpLabel = tmp;
        
        CGSize size = [WVRComputeTool sizeOfString:@"还剩" Size:CGSizeMake(800, 800) Font:tmp.font];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + size.width + 1, (self.height+MARGIN_TOP)/2.0, 80, size.height + 1)];
        label.textColor = [UIColor colorWithHex:0xF7D154];
        label.font = tmp.font;
        label.text = [self timeToString:0];
        if (count <= 0) {
            label.hidden = YES;
        }
        
        [self addSubview:label];
        _timeLabel = label;
    }
    return _timeLabel;
}

// MARK: - Constraints

- (void)makeConstraintsToLeft {
    
    if (self.superview) {
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(adaptToWidth(15));
            make.top.mas_equalTo(50);
            make.width.mas_equalTo(fitToWidth(160));
            make.height.mas_equalTo(fitToWidth(60));
        }];
    } else {
        DDLogError(@"makeConstraintsToLeft Error!!!");
    }
}

//- (void)makeConstraintsToRight {
//
//    if (self.superview) {
//
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(adaptToWidth(-10));
//            make.centerY.equalTo(self.superview);
//            make.width.mas_equalTo(fitToWidth(160));
//            make.height.mas_equalTo(fitToWidth(60));
//        }];
//    } else {
//        DDLogError(@"makeConstraintsToRight Error!!!");
//    }
//}

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

- (void)updateBoxXForDisplayMode {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CGFloat x = self.isLandscape ? (self.width - self.lottery.width - MARGIN_TOP) : 0;
//        self.lottery.x = x;
//    });
}

- (void)appWillEnterForeground:(NSNotification *)noti {
    
    if (_isAnimate && self.superview) {
        [self boxStartAnimation];
    }
}

#pragma mark - external func

- (BOOL)isVisible {
    
    return self.boxSwitch;
}

- (void)updateCountDown:(long)time isShow:(BOOL)isShow {
    
//    if (![self isVisible]) { return; }
    
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

/// 抽卡次数用完
- (void)leftCountUseUp {
    
//    [self makeConstraintsToRight];
    
    [self hideOrShowSubviews:NO];
    
    _tmpLabel.text = @"今天的机会已\n经用完";
    _timeLabel.hidden = YES;
}

/// 未登录时的状态
- (void)refreshUINotLogin {
    
//    [self makeConstraintsToLeft];
    
    [self hideOrShowSubviews:NO];
    
    _tmpLabel.text = @"登录后\nN张福卡可领取";
    _timeLabel.hidden = YES;
}

- (NSString *)timeToString:(long)time {
    
//    return [NSString stringWithFormat:@"%02d分%02d秒", (int)time/60, (int)time%60];
    int min = (int)time/SECOND_TIME;
    if (min > 0) {
        
        return [NSString stringWithFormat:@"%d分%d秒", min, (int)time%SECOND_TIME];
    } else {
        
        return [NSString stringWithFormat:@"%d秒", (int)time%SECOND_TIME];
    }
}

#pragma mark - action

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
    
    if (![self.realDelegate actionCheckLogin]) { return; }
    
    if (self.time > 0) {
        
//        NSString *str = [NSString stringWithFormat:@"离下次送福卡还剩%@", [self timeToString:_time]];
//        SQToastInKeyWindow(str);
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
        
//        [self.boxDelegate lotteryForSpring2018Card];
        
        _tapDate = [NSDate date];
    }
    
    [self.boxDelegate springBoxTapAction:self.time];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview) {
        return;
    }
    if ((SCREEN_WIDTH>SCREEN_HEIGHT)&&(self.left==15.f)) {
        CGFloat offset = (SCREEN_WIDTH>SCREEN_HEIGHT)&kDevice_Is_iPhoneX? kStatuBarHeight:15.f;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset);
        }];
    }
    
}
@end

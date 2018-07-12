//
//  WVRLiveCarImageController.m
//  WhaleyVR
//
//  Created by Bruce on 2018/3/26.
//  Copyright © 2018年 Snailvr. All rights reserved.
//

#import "WVRLiveCarImageController.h"


@interface WVRCarImageBtn: UIButton

@property (nonatomic, assign) BOOL hasData;

@end


@implementation WVRCarImageBtn

- (void)setHidden:(BOOL)hidden {
    
    // 没有填充数据，就不应该被显示出来
    if (!self.hasData) {
        hidden = YES;
    }
    [super setHidden:hidden];
}

- (BOOL)playerUINotAutoShow {

    return YES;
}

- (BOOL)playerUINotAutoHide {

    return YES;
}

@end


@interface WVRLiveCarImageController ()

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) BOOL playerIsPrepared;

@property (nonatomic, weak) WVRCarImageBtn *carImageBtn1;
@property (nonatomic, weak) WVRCarImageBtn *carImageBtn2;
@property (nonatomic, weak) WVRCarImageBtn *carImageBtn3;

@property (nonatomic, assign) BOOL touchValid;

@property (nonatomic, assign) BOOL hiddenByOutside;

@end


@implementation WVRLiveCarImageController

#define kLiveCarImageOffset 15

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)configSelf {
    
    [self carImageBtn2];
    [self carImageBtn1];
    [self carImageBtn3];
    
//    NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [self performSelector:@selector(setViewsHidden:) withObject:@(NO) afterDelay:0.7f];
    
    self.touchValid = YES;
    
    // 监听通知，显示机位选择时，按钮失效
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kLiveCarChooseCameraStandNoti" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        @strongify(self);
        BOOL cameraStandShow = [x.object boolValue];
        self.touchValid = !cameraStandShow;
    }];
    
    // 进前台之后重新倒计时
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        @strongify(self);
        [self setViewsHidden:@(NO)];
    }];
}

- (void)setTouchValid:(BOOL)touchValid {
    _touchValid = touchValid;
    
    _carImageBtn1.enabled = touchValid;
    _carImageBtn2.enabled = touchValid;
    _carImageBtn3.enabled = touchValid;
}

- (WVRCarImageBtn *)carImageBtn2 {
    
    if (!_carImageBtn2) {
        WVRCarImageBtn *btn = [WVRCarImageBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = 2;
        btn.hidden = YES;
        
        NSString *key = [NSString stringWithFormat:@"%ld", btn.tag];
        NSDictionary *dict = [self.dataDict objectForKey:key];
        NSString *url = dict[@"floatPic"];
        
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        btn.hasData = (dict != nil);
        
        [btn.imageView wvr_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
            [btn setImage:image forState:UIControlStateNormal];
        }];
        
        [btn addTarget:self action:@selector(carImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.parentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(fitToWidth(62.5)));
            make.width.mas_equalTo(@(fitToWidth(125)));
            make.right.equalTo(btn.superview).offset(0-fitToWidth(kLiveCarImageOffset));
            make.centerY.equalTo(btn.superview);
        }];
        
        _carImageBtn2 = btn;
    }
    
    return _carImageBtn2;
}

- (WVRCarImageBtn *)carImageBtn1 {
    
    if (!_carImageBtn1) {
        WVRCarImageBtn *btn = [WVRCarImageBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = 1;
        btn.hidden = YES;
        
        NSString *key = [NSString stringWithFormat:@"%ld", btn.tag];
        NSDictionary *dict = [self.dataDict objectForKey:key];
        NSString *url = dict[@"floatPic"];
        
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        btn.hasData = (dict != nil);
        
        [btn.imageView wvr_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
            [btn setImage:image forState:UIControlStateNormal];
        }];
        
        [btn addTarget:self action:@selector(carImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.parentView addSubview:btn];
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakself.carImageBtn2);
            make.width.equalTo(weakself.carImageBtn2);
            make.right.equalTo(weakself.carImageBtn2);
            make.bottom.equalTo(weakself.carImageBtn2.mas_top).offset(0-fitToWidth(kLiveCarImageOffset));
        }];
        
        _carImageBtn1 = btn;
    }
    
    return _carImageBtn1;
}

- (WVRCarImageBtn *)carImageBtn3 {
    
    if (!_carImageBtn3) {
        WVRCarImageBtn *btn = [WVRCarImageBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = 3;
        btn.hidden = YES;
        
        NSString *key = [NSString stringWithFormat:@"%ld", btn.tag];
        NSDictionary *dict = [self.dataDict objectForKey:key];
        NSString *url = dict[@"floatPic"];
        
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        btn.hasData = (dict != nil);
        
        [btn.imageView wvr_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
            [btn setImage:image forState:UIControlStateNormal];
        }];
        
        [btn addTarget:self action:@selector(carImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.parentView addSubview:btn];
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakself.carImageBtn2);
            make.width.equalTo(weakself.carImageBtn2);
            make.right.equalTo(weakself.carImageBtn2);
            make.top.equalTo(weakself.carImageBtn2.mas_bottom).offset(fitToWidth(kLiveCarImageOffset));
        }];
        
        _carImageBtn3 = btn;
    }
    
    return _carImageBtn3;
}

- (void)carImageBtnClicked:(UIButton *)sender {
    
    NSString *key = [NSString stringWithFormat:@"%ld", sender.tag];
    NSDictionary *dict = [self.dataDict objectForKey:key];
    NSString *url = dict[@"floatUrl"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#define Angle(angle) ((angle) / 180.0 * M_PI)
#define CarAnimationDuration 0.67f
#define CarAnimationKey @"transformAnimation"

- (void)startAnimation {
    
    [self performSelector:@selector(firstBtnAnimation) withObject:nil afterDelay:0];
}

- (void)firstBtnAnimation {
    
    CAKeyframeAnimation *anim = [self animation];
    
    [_carImageBtn1.layer addAnimation:anim forKey:CarAnimationKey];
    
    [self performSelector:@selector(secondBtnAnimation) withObject:nil afterDelay:anim.duration + 0.17];
}

- (void)secondBtnAnimation {
    
    CAKeyframeAnimation *anim = [self animation];
    
    [_carImageBtn2.layer addAnimation:anim forKey:CarAnimationKey];
    
    [self performSelector:@selector(thirdBtnAnimation) withObject:nil afterDelay:anim.duration + 0.17];
}

- (void)thirdBtnAnimation {
    
    CAKeyframeAnimation *anim = [self animation];
    [_carImageBtn3.layer addAnimation:anim forKey:CarAnimationKey];
    
    [self performSelector:@selector(setViewsHidden:) withObject:@(YES) afterDelay:20];
}

- (CAKeyframeAnimation *)animation {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[ @(Angle(0)), @(Angle(5)), @(Angle(-5)), @(Angle(0)) ];
    anim.duration = CarAnimationDuration;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return anim;
}

- (void)stopAnimation {
    
    [_carImageBtn1.layer removeAllAnimations];
    [_carImageBtn2.layer removeAllAnimations];
    [_carImageBtn3.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setViewsHidden:(NSNumber *)hidden {
    
    if (self.hiddenByOutside) {     // 当被外界隐藏时，停止自己的定时器
        return;
    }
    
    BOOL isHide = hidden.boolValue;
    
    _carImageBtn1.hidden = isHide;
    _carImageBtn2.hidden = isHide;
    _carImageBtn3.hidden = isHide;
    
    // 定时器被打乱，重新计时
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (isHide) {
        [self performSelector:@selector(setViewsHidden:) withObject:@(NO) afterDelay:120];
    } else {
        [self startAnimation];
    }
}

#pragma mark - WVRPlayerUIProtocol

- (BOOL)addControllerWithParams:(NSDictionary *)params {
    
//    [params conformsToProtocol:@protocol(WVRPlayerUIProtocol)];
    
    self.parentView = params[@"parentView"];
    self.dataDict = params[@"dataDict"];
    self.playerIsPrepared = [params[@"playerIsPrepared"] boolValue];
    
    [self configSelf];
    
    return NO;
}

- (void)pauseController {
    
}

- (void)resumeController {
    
}

- (void)removeController {
    
    [_carImageBtn1 removeFromSuperview];
    [_carImageBtn2 removeFromSuperview];
    [_carImageBtn3 removeFromSuperview];
    _carImageBtn1 = nil;
    _carImageBtn2 = nil;
    _carImageBtn3 = nil;
    
    [self stopAnimation];
}

- (unsigned long)priority {
    
    return 1;
}

/// 协议方法，本类请勿调用
- (WVRPlayerUIEventCallBack *)dealWithEvent:(WVRPlayerUIEvent *)event {
    
    NSString *selName = [event.name stringByAppendingString:@":"];
    SEL sel = NSSelectorFromString(selName);
    
    // 不支持此方法，则返回nil
    if (![self respondsToSelector:sel]) { return nil; }
    
    WVRPlayerUIEventCallBack *callback = [self performSelector:sel withObject:event.params];
    
    // 如果方法直接返回callback，则可直接return出去
    if ([callback isKindOfClass:[WVRPlayerUIEventCallBack class]]) { return callback; }
    
    return [[WVRPlayerUIEventCallBack alloc] init];
}

#pragma mark - on

//- (WVRPlayerUIEventCallBack *)playerui_PreparedWithDuration:(NSDictionary *)params {
//
//    [self setViewsHidden:@(NO)];
//
////    [self startAnimation];
//
//    return nil;
//}

// 本控件作为一个悬浮组件，类似于宝箱弹幕，弹幕隐藏的时候，本控件也应当隐藏
- (WVRPlayerUIEventCallBack *)playerui_setDanmuHiden:(NSDictionary *)params {
    
    NSNumber *hidden = params[@"danmuHiden"];
    
    if (!hidden.boolValue) {
        self.hiddenByOutside = hidden.boolValue;
    }
    
    [self setViewsHidden:hidden];
    
    if (hidden.boolValue) {
        self.hiddenByOutside = hidden.boolValue;
    }
    
    return nil;
}

@end


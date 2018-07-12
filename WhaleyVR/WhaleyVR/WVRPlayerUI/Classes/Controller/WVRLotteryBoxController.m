//
//  WVRLotteryBoxController.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLotteryBoxController.h"
#import "WVRLotteryBoxView.h"

@interface WVRLotteryBoxController ()

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) NSDictionary *ve;

@property (nonatomic, strong) WVRLotteryBoxView *box;

@property (atomic, assign) BOOL isGlassesMode;

@property (atomic, assign) BOOL isLandscape;

@property (nonatomic, assign) BOOL shouldHidden;

@property (nonatomic, assign) BOOL isSwitchOn;

@end


@implementation WVRLotteryBoxController

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)configSelf {
    
    [self box];
//    if (![[self startView] superview]) {
//        [self.parentView addSubview:[self startView]];
//    }
}

- (WVRLotteryBoxView *)box {
    
    if (!_box) {
        WVRLotteryBoxView *box = [[WVRLotteryBoxView alloc] initWithFrame:CGRectMake(adaptToWidth(15), 86, fitToWidth(160), fitToWidth(60))];
        box.liveDelegate = (id)self.uiManager;
        box.realDelegate = (id)self.uiManager;
        
        [self.parentView addSubview:box];
        _box = box;
        NSInteger displayMode = [self.ve[@"displayMode"] integerValue];
        BOOL curIsLands = (displayMode == WVRLiveDisplayModeHorizontal);
        box.isLandscape = curIsLands;
        self.isLandscape = curIsLands;
        if (curIsLands) {
            [box mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(adaptToWidth(-15));
                make.centerY.equalTo(self.box.superview);
                make.width.mas_equalTo(fitToWidth(160));
                make.height.mas_equalTo(fitToWidth(60));
            }];
        }else{
            [box mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(adaptToWidth(15));
                make.top.mas_equalTo(kDevice_Is_iPhoneX? kStatuBarHeight+86:86);
                make.width.mas_equalTo(fitToWidth(160));
                make.height.mas_equalTo(fitToWidth(60));
            }];
        }
        
//        [_box setBoxSwitch:[self.ve[@"lotterySwitch"] boolValue]];一开始只创建不显示，因为没有time
    }
    
    return _box;
}

#pragma mark - WVRPlayerUIProtocol

- (BOOL)addControllerWithParams:(NSDictionary *)params {
    
//    [params conformsToProtocol:@protocol(WVRPlayerUIProtocol)];
    
    self.parentView = params[@"parentView"];
    self.ve = params[@"ve"];
    
    [self configSelf];
    
    return NO;
}

- (void)pauseController {
    
}

- (void)resumeController {
    
}

- (void)removeController {
    
    [_box boxStopAnimation];
    [_box removeFromSuperview];
    _box = nil;
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
    [self checkIsGlassesMode];
    // 如果方法直接返回callback，则可直接return出去
    if ([callback isKindOfClass:[WVRPlayerUIEventCallBack class]]) { return callback; }
    
    return [[WVRPlayerUIEventCallBack alloc] init];
}

#pragma mark - on

- (WVRPlayerUIEventCallBack *)playerui_resumeForControllerChanged:(NSDictionary *)params {
    
    [_box resumeForControllerChanged];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_sleepForControllerChanged:(NSDictionary *)params {
    
    [_box sleepForControllerChanged];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_boxStopAnimation:(NSDictionary *)params {
    
    [_box boxStopAnimation];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_updateCountDown:(NSDictionary *)params {
    
    long countDown = [params[@"countDown"] longValue];
    BOOL isShow = [params[@"isShow"] boolValue];
    [_box updateCountDown:countDown isShow:isShow];
    
    WVRPlayerUIEventCallBack *callback = [[WVRPlayerUIEventCallBack alloc] init];
    callback.isIntercept = YES;
    return callback;
}

- (WVRPlayerUIEventCallBack *)playerui_setBoxSwitch:(NSDictionary *)params {
    
    BOOL _switch = [params[@"switch"] boolValue];
    self.isSwitchOn = _switch;
    [_box setBoxSwitch:_switch && !self.shouldHidden];
    
    WVRPlayerUIEventCallBack *callback = [[WVRPlayerUIEventCallBack alloc] init];
    callback.isIntercept = YES;
    return callback;
}

- (WVRPlayerUIEventCallBack *)playerui_setMonocular:(NSDictionary *)params {
    
    _isGlassesMode = [params[@"isMonocular"] boolValue];
    
    [self.box setNotAutoShow:_isGlassesMode];
//    [self checkIsGlassesMode];
//    if (_isGlassesMode) {
//        self.box.hidden = _isGlassesMode;
//    }
    
    return nil;
}

//- (WVRPlayerUIEventCallBack *)playerui_setIsLandscape:(NSDictionary *)params {
//    
//    self.isLandscape = [params[@"isLandscape"] boolValue];
//    self.box.isLandscape = self.isLandscape;
//    if (self.isLandscape) {
//        [self.box mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(adaptToWidth(-15));
//            make.centerY.equalTo(self.box.superview);
//            make.width.mas_equalTo(fitToWidth(160));
//            make.height.mas_equalTo(fitToWidth(60));
//        }];
//    }else{
//        [self.box mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(adaptToWidth(15));
//            make.top.mas_equalTo(86);
//            make.width.mas_equalTo(fitToWidth(160));
//            make.height.mas_equalTo(fitToWidth(60));
//        }];
//    }
//    return nil;
//}


- (WVRPlayerUIEventCallBack *)playerui_setboxHidden:(NSDictionary *)params {
    self.shouldHidden = [params[@"boxHidden"] boolValue];
    if (self.shouldHidden) {
        self.box.hidden = YES;
    }else{
        
        if(!self.box.closeByUser)
            self.box.hidden = !self.isSwitchOn;
    }
    
    return nil;
}

- (void)checkIsGlassesMode
{
    self.box.hidden = self.isGlassesMode || self.box.hidden;
}

@end

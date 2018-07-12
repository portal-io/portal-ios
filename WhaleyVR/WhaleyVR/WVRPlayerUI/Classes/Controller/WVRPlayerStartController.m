//
//  WVRPlayerStartController.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerStartController.h"
#import "WVRPlayerStartView.h"

@interface WVRPlayerStartController ()

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, copy) NSString *videoTitle;

@property (nonatomic, weak) WVRPlayerStartView *startView;

@end


@implementation WVRPlayerStartController

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)configSelf {
    
    [self startView];
//    if (![[self startView] superview]) {
//        [self.parentView addSubview:[self startView]];
//    }
}

//- (WVRPlayerStartView *)startView {
//    
//    if (!_startView) {
//        WVRPlayerStartView *startV = [[WVRPlayerStartView alloc] initWithFrame:self.parentView.frame titleText:self.videoTitle containerView:self.parentView];
//        startV.realDelegate = self;
//        _startView = startV;
//    }
//    
//    return _startView;
//}

#pragma mark - WVRPlayerStartViewDelegate

- (void)actionRetry {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] init];
    event.name = @"playerui_actionRetry";
    event.receivers = PlayerUIEventReceiverManager;
    [self.uiManager dealWithEvent:event];
}

- (void)actionGotoBuy {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] init];
    event.name = @"playerui_actionGotoBuy";
    event.receivers = PlayerUIEventReceiverManager;
    [self.uiManager dealWithEvent:event];
}

- (void)backBtnClick:(UIButton *)sender {
    
    if ([self.uiManager respondsToSelector:@selector(backOnClick:)]) {
        [self.uiManager performSelector:@selector(backOnClick:) withObject:nil];
    }
}

#pragma mark - WVRPlayerUIProtocol

- (BOOL)addControllerWithParams:(NSDictionary *)params {
    
//    [params conformsToProtocol:@protocol(WVRPlayerUIProtocol)];
    
    self.parentView = params[@"parentView"];
    self.videoTitle = params[@"videoTitle"];
    [self configSelf];
    
    return NO;
}

- (void)pauseController {
    
}

- (void)resumeController {
    
}

- (void)removeController {
    
    [_startView dismiss];
    _startView = nil;
}

- (unsigned long)priority {
    
    return 1;
}

/// 协议方法，本类请勿调用
//- (WVRPlayerUIEventCallBack *)dealWithEvent:(WVRPlayerUIEvent *)event {
//
//    NSString *selName = [event.name stringByAppendingString:@":"];
//    SEL sel = NSSelectorFromString(selName);
//
//    // 不支持此方法，则返回nil
//    if (![self respondsToSelector:sel]) { return nil; }
//
//    WVRPlayerUIEventCallBack *callback = [self performSelector:sel withObject:event.params];
//
//    // 如果方法直接返回callback，则可直接return出去
//    if ([callback isKindOfClass:[WVRPlayerUIEventCallBack class]]) { return callback; }
//
//    return [[WVRPlayerUIEventCallBack alloc] init];
//}
//
//#pragma mark - on
//
//- (WVRPlayerUIEventCallBack *)playerui_checkStartViewAnimation:(NSDictionary *)params {
//
//    WVRPlayerUIEventCallBack *callback = [[WVRPlayerUIEventCallBack alloc] init];
//    callback.isIntercept = YES;
//
//    [_startView checkAnimation];
//
//    return callback;
//}
//
//- (WVRPlayerUIEventCallBack *)playerui_PreparedWithDuration:(NSDictionary *)params {
//
//    [_startView dismiss];
//
//    return nil;
//}
//
//- (WVRPlayerUIEventCallBack *)playerui_execPlaying:(NSDictionary *)params {
//
//    [_startView dismiss];
//
//    return nil;
//}
//
//- (WVRPlayerUIEventCallBack *)playerui_execWaitingPlay:(NSDictionary *)params {
//
//    [self.startView resetStatus:params[@"title"]];
//
//    return nil;
//}
//
//- (WVRPlayerUIEventCallBack *)playerui_onError:(NSDictionary *)params {
//
//    NSString *message = params[@"message"];
//    NSInteger code = [params[@"code"] integerValue];
//    [self.startView onErrorWithMsg:message code:code];
//
//    return nil;
//}
//
//- (WVRPlayerUIEventCallBack *)playerui_TrailOverToPay:(NSDictionary *)params {
//
//    BOOL canTrail = [params[@"canTrail"] boolValue];
//    NSString *price = params[@"price"];
//    [self.startView resetStatusToPaymentWithTrail:canTrail price:price];
//
//    return nil;
//}
//
//- (WVRPlayerUIEventCallBack *)playerui_PaymentSuccess:(NSDictionary *)params {
//
//    [_startView dismiss];
//
//    return nil;
//}

@end

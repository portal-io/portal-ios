//
//  WVRBlurBackgroundController.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBlurBackgroundController.h"
#import "WVRBlurImageView.h"

@interface WVRBlurBackgroundController ()

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, weak) WVRBlurImageView *blurView;

@end


@implementation WVRBlurBackgroundController

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)configSelf {
    
    [self blurView];
}

- (WVRBlurImageView *)blurView {
    
    if (!_blurView) {
        WVRBlurImageView *imageView = [[WVRBlurImageView alloc] initWithContainerView:self.parentView imgUrl:self.imgUrl];
        _blurView = imageView;
    }
    
    return _blurView;
}

#pragma mark - WVRPlayerUIProtocol

- (BOOL)addControllerWithParams:(NSDictionary *)params {
    
//    [params conformsToProtocol:@protocol(WVRPlayerUIProtocol)];
    
    self.parentView = params[@"parentView"];
    self.imgUrl = params[@"imgUrl"];
    [self configSelf];
    
    return NO;
}

- (void)pauseController {
    
}

- (void)resumeController {
    
}

- (void)removeController {
    
    [_blurView removeFromSuperview];
    _blurView = nil;
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

- (WVRPlayerUIEventCallBack *)playerui_PreparedWithDuration:(NSDictionary *)params {
    _blurView.hidden = YES;
//    [_blurView removeFromSuperview];
//    _blurView = nil;
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_Complete:(NSDictionary *)params {
    _blurView.hidden = NO;
//    [_blurView removeFromSuperview];
//    _blurView = nil;
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_TrailOverToPay:(NSDictionary *)params {
    
    if (![[self blurView] superview]) {
        [self.parentView insertSubview:[self blurView] atIndex:0];
    }
    
    return nil;
}

@end

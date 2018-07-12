//
//  WVRLiveCompleteViewPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveCompleteViewPresenter.h"
//#import <React/RCTBundleURLProvider.h>
//#import <React/RCTRootView.h>

@interface WVRLiveCompleteViewPresenter()

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, strong) UIView *gCompleteView;

@property (nonatomic, strong) NSDictionary * gParams;

@end

@implementation WVRLiveCompleteViewPresenter
- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (UIView *)gCompleteView {
    
    if (!_gCompleteView) {
        UIView * cur = nil;//[self loadReactNativeView];
        [self.parentView addSubview:cur];
        @weakify(self);
        [cur mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.parentView);
            make.bottom.equalTo(self.parentView);
            make.left.equalTo(self.parentView);
            make.right.equalTo(self.parentView);
        }];
        _gCompleteView = cur;
    }
    
    return _gCompleteView;
}

//-(RCTRootView*)loadReactNativeView
//{
//    NSURL *jsCodeLocation;
//    jsCodeLocation = [NSURL
//                      URLWithString:@"http://172.29.2.1.xip.io:8081/index.bundle?platform=ios&dev=true&minify=false"];
//    //    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//
//    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
//                                                        moduleName:@"whaley_react_native"
//                                                 initialProperties:@{@"routeName":@"LiveCompleteView"}
//                                                     launchOptions:nil];
//    rootView.backgroundColor = [UIColor clearColor];
//    for (UIView * cur in rootView.subviews) {
//        cur.backgroundColor = [UIColor clearColor];
//    }
//    return rootView;
//}

#pragma mark - WVRPlayerUIProtocol

- (BOOL)addControllerWithParams:(NSDictionary *)params {
    
//    //    [params conformsToProtocol:@protocol(WVRPlayerUIProtocol)];
//    [self videoEntity].showMembers = model.isTip;
//    [self videoEntity].showGifts = model.isGift;
//    [self videoEntity].tempCode = model.giftTemplate;
    self.parentView = params[@"parentView"];
    self.gParams = params;
    [self gCompleteView];
    return NO;
}

- (void)pauseController {
    
}

- (void)removeController {
    
    [self.gCompleteView removeFromSuperview];
    self.gCompleteView = nil;
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

@end

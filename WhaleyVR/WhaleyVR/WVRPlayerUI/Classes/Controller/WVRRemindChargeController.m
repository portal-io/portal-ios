//
//  WVRRemindChargeController.m
//  WhaleyVR
//
//  Created by Bruce on 2017/10/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRemindChargeController.h"
#import "WVRLiveRemindChargeView.h"
#import "WVRVideoEntity.h"
#import "WVRVideoEntityLive.h"

@interface WVRRemindChargeController ()<WVRLiveRemindChargeViewDelegate>

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) WVRVideoEntity *ve;

@property (nonatomic, assign) BOOL isProgramSet;

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, weak) WVRLiveRemindChargeView *remindView;
@property (nonatomic, weak) YYLabel *remindLabel;

@end


@implementation WVRRemindChargeController

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)configSelf {
    
}

- (WVRLiveRemindChargeView *)remindView {
    
    if (![self.ve isKindOfClass:[WVRVideoEntityLive class]]) {
        return nil;
    }
    if (!_remindView) {
        
        WVRLiveRemindChargeView *view = [[WVRLiveRemindChargeView alloc] initWithPrice:self.ve.price endTime:((WVRVideoEntityLive *)self.ve).endTime isProgramSet:self.isProgramSet];
        
        view.viewDelegate = self;
        [self.parentView addSubview:view];
        _remindView = view;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(adaptToWidth(310));
            make.height.mas_equalTo(adaptToWidth(205));
            make.center.equalTo(view.superview);
        }];
    }
    [_remindView updateRemindLabelWithEndTime:((WVRVideoEntityLive *)self.ve).endTime];
    
    return _remindView;
}

- (void)updateremindLabel {
    
    [_remindLabel removeFromSuperview];     // 销毁原来的，重新创建
    
    if (self.ve.streamType != STREAM_VR_VOD && self.ve.streamType != STREAM_VR_LIVE) { return; }
    
    SEL sel = NSSelectorFromString(@"isCharged");
    if (![self.uiManager respondsToSelector:sel]) {
        DDLogError(@"error：相关方法未实现");
        return;
    }
    BOOL isCharged = [self.uiManager performSelector:sel];
    if (isCharged || self.ve.freeTime <= 0) {
        
        return;             // 已支付或无试看，则不显示购买提示label
    }
    
    YYLabel *label = [[YYLabel alloc] init];
    
    UIView *startView = nil;
    for (UIView *view in self.parentView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"WVRPlayerLoadingView")]) {
            startView = view;
            break;
        }
    }
    if (startView) {
        [self.parentView insertSubview:label belowSubview:startView];
    } else {
        [self.parentView addSubview:label];
    }
    _remindLabel = label;
    
    long freeTime = self.ve.freeTime;
    long price = self.ve.price;

    NSMutableAttributedString *text = [self remindLabelText:freeTime price:price];
    
    CGSize tmpSize = CGSizeMake(CGFLOAT_MAX, 100);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:tmpSize text:text];
    CGSize size = layout.textBoundingSize;
    float gap = adaptToWidth(18);
    label.size = CGSizeMake(size.width + gap, size.height + gap);
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    label.attributedText = text;
    
    // beta 待精确适配
//    if ([self streamType] == STREAM_VR_LIVE || _isLandscape) {
//
//        label.centerY = self.height * 0.5f;
//    } else {
//        label.bottomY = self.height - adaptToWidth(90);
//    }
//    label.centerX = self.width / 2.f;
    
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    label.layer.cornerRadius = label.height / 2.f;
    label.layer.masksToBounds = YES;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(label.width);
        make.height.mas_equalTo(label.height);
        make.centerX.equalTo(label.superview);
        make.centerY.equalTo(label.superview);
    }];
}

#pragma mark - WVRPlayerUIProtocol

- (BOOL)addControllerWithParams:(NSDictionary *)params {
    
//    [params conformsToProtocol:@protocol(WVRPlayerUIProtocol)];
    
    self.parentView = params[@"parentView"];
    self.ve = params[@"ve"];
    self.isProgramSet = [params[@"isProgramSet"] boolValue];
    
    [self configSelf];
    
    return NO;
}

- (void)pauseController {
    
}

- (void)resumeController {
    
}

- (void)removeController {
    
    [_remindView removeFromSuperview];
    [_remindLabel removeFromSuperview];
    _remindLabel = nil;
    _remindView = nil;
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
    
    [self updateremindLabel];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_PreparedWithEndTime:(NSDictionary *)params {
    
    [self updateremindLabel];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_TrailOverToPay:(NSDictionary *)params {
    
    BOOL isProgramSet = [params[@"isProgramSet"] boolValue];
    _isProgramSet = isProgramSet;
    
    [_remindLabel removeFromSuperview];
    [self remindView];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_PaymentSuccess:(NSDictionary *)params {
    
    [_remindLabel removeFromSuperview];
    [_remindView removeFromSuperview];
    
    return nil;
}

#pragma mark - private function

- (NSMutableAttributedString *)remindLabelText:(long)freeTime price:(long)price {
    
    if (self.ve.streamType == STREAM_VR_LIVE) {
        
        NSString *str = [NSString stringWithFormat:@"试看%@，%@购买观看完整直播 立即购买", [WVRComputeTool numToTime:freeTime], [WVRComputeTool numToPrice:price]];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFontFitForSize(14), NSForegroundColorAttributeName : [UIColor whiteColor] }];
        
        kWeakSelf(self);
        NSRange range = NSMakeRange(str.length - 4, 4);
        [text yy_setTextHighlightRange:range
                                 color:k_Color15
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                 [weakself payForVideo];
                             }];
        return text;
    } else {
        
        NSString *str = [NSString stringWithFormat:@"试看%@，购买观看券即可获得完整视频", [WVRComputeTool numToTime:freeTime]];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFontFitForSize(14), NSForegroundColorAttributeName : [UIColor whiteColor] }];
        
        return text;
    }
}

#pragma mark - viewDelegate

- (void)payForVideo {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] init];
    event.name = @"playerui_actionGotoBuy";
    event.receivers = PlayerUIEventReceiverManager;
    [self.uiManager dealWithEvent:event];
}

- (void)goRedeemPage {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] init];
    event.name = @"playerui_actionGoRedeemPage";
    event.receivers = PlayerUIEventReceiverManager;
    [self.uiManager dealWithEvent:event];
}

@end

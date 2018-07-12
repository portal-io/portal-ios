//
//  WVRDanmuController.m
//  WVRDanmu
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRDanmuController.h"
#import "WVRDanmuListView.h"
#import "WVRLiveTextField.h"
#import <Masonry/Masonry.h>

#import "WVRWebSocketMsg.h"
#import "WVRWebSocketClient.h"

@interface WVRDanmuController ()<WVRLiveTextFieldDelegate>

@property (nonatomic, weak) WVRDanmuListView *danmuListView;

@property (nonatomic, weak) WVRLiveTextField *liveTextField;

@property (nonatomic, strong) NSDictionary *ve;
///**
// 轮询弹幕开关
// */
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, assign) BOOL danmuSwitch;

@property (atomic, assign) BOOL isGlassesMode;

@property (atomic, assign) BOOL gHidenDanmuV;

@end


@implementation WVRDanmuController

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)configSelf {
    
    [self danmuListView];
}

- (WVRDanmuListView *)danmuListView {
    
    if (!_danmuListView) {
        CGFloat offset = (SCREEN_WIDTH>SCREEN_HEIGHT)&kDevice_Is_iPhoneX? kStatuBarHeight:0;
        CGFloat Y_offset = (SCREEN_WIDTH<SCREEN_HEIGHT)&kDevice_Is_iPhoneX? kTabBarHeight-49.f:0;
        WVRDanmuListView *danm = [[WVRDanmuListView alloc] initWithFrame:CGRectMake(offset, Y_DANMU, WIDTH_DANMU_VIEW, HEIGHT_DANMU_LIST_VIEW) delegate:self.uiManager];

        [self.parentView addSubview:danm];
        [danm registerObserverEvent];       // 执行完addSubview才注册通知
        
        danm.hidden = _isGlassesMode||self.gHidenDanmuV;
        
        _danmuListView = danm;
        
        [danm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(danm.superview).offset(offset);
            make.height.equalTo(@(HEIGHT_DANMU_LIST_VIEW));
            make.width.equalTo(@(WIDTH_DANMU_VIEW));
            make.bottom.equalTo(danm.superview).offset(0 - (HEIGHT_TEXTFILED_VIEW + MARGIN_BETWEEN_DANMU_TEXTFILED+Y_offset));
        }];
        
        [self eventBindForParentView];
        self.danmuSwitch = [self.ve[@"danmuSwitch"] boolValue];
        [danm setSwitchOn:self.danmuSwitch];
    }
    return _danmuListView;
}

- (void)eventBindForParentView {
    
    SEL sel = NSSelectorFromString(@"toggleControls");
    if ([self.parentView respondsToSelector:sel]) {
        
        UITapGestureRecognizer *tapDanM = [[UITapGestureRecognizer alloc] initWithTarget:self.parentView action:sel];
        tapDanM.delegate = (id)self.parentView;
        
        [self.danmuListView addGestureRecognizer:tapDanM];
    }
}

- (WVRLiveTextField *)liveTextField {

    if (!_liveTextField) {
        WVRLiveTextField *textF = [[WVRLiveTextField alloc] init];
        
        [self.parentView addSubview:textF];
        _liveTextField = textF;
        textF.realDelegate = self;
        CGFloat offset_leading = (SCREEN_WIDTH>SCREEN_HEIGHT)&kDevice_Is_iPhoneX? kStatuBarHeight-15:0;
        kWeakSelf(self);
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.parentView).offset(offset_leading);
            make.right.equalTo(weakself.parentView);
            make.bottom.equalTo(weakself.parentView);
            make.height.equalTo(@(MAX_LENGTH_SEND_TEXT));
        }];
    }
    return _liveTextField;
};

#pragma mark - WVRLiveTextFieldDelegate

- (void)textFieldWillReturn:(NSString *)text {
    
    if (!text.length) { return; }
    
    if (!self.danmuSwitch) {
        SQToastInKeyWindow(@"此节目不支持弹幕");
        return;
    }
    
    kWeakSelf(self);
    [[WVRWebSocketClient shareInstance] sendTextMsg:text successBlock:^{
//        SQToast(@"已发送");
        WVRWebSocketMsg * msg = [WVRWebSocketMsg new];
        msg.content = text;
        msg.senderNickName = [WVRUserModel sharedInstance].username;
        
        [weakself.danmuListView addDanmuWithArray:@[msg]];
    }];
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] initWithName:@"playerui_danmuSended" params:nil receivers:PlayerUIEventReceiverManager];
    
    [self.uiManager dealWithEvent:event];
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
    
    // 移除子视图同时也要移除通知
    [self.danmuListView removeObserverEvent];
    [self.danmuListView removeFromSuperview];
    [self.liveTextField removeFromSuperview];
    _danmuListView = nil;
    self.liveTextField = nil;
}

- (unsigned long)priority {
    
    return 1;
}

- (WVRPlayerUIEventCallBack *)dealWithEvent:(WVRPlayerUIEvent *)event {
    
    NSString *selName = [event.name stringByAppendingString:@":"];
    SEL sel = NSSelectorFromString(selName);
    
    // 不支持此方法，则返回nil
    if (![self respondsToSelector:sel]) { return nil; }
    
    WVRPlayerUIEventCallBack *callback = [self performSelector:sel withObject:event.params];
    [self checkIsGlassesMode];
    // 如果方法直接返回callback，则可直接return出去
    if ([callback isKindOfClass:[WVRPlayerUIEventCallBack class]]) { return callback; }
    
    callback = [[WVRPlayerUIEventCallBack alloc] init];
//    callback.isIntercept = YES;
    
    return callback;
}

#pragma mark - on

- (WVRPlayerUIEventCallBack *)playerui_addDanmuWithArray:(NSDictionary *)params {
    
    NSArray *arr = params[@"danmuArray"];
    [self.danmuListView addDanmuWithArray:arr];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_setDanmuSwitchOn:(NSDictionary *)params {
    
    BOOL isOn = [params[@"isOn"] boolValue];
    
    self.danmuSwitch = isOn;
    [self.danmuListView setSwitchOn:isOn];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_becomeToFirstResponder:(NSDictionary *)params {
    
    [self.liveTextField becomeFirstResponder];
    self.liveTextField.hidden = NO;
    self.liveTextField.alpha = 1;
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_setResignFirstResponder:(NSDictionary *)params {
    
    [self.liveTextField resignFirstResponder];
    self.liveTextField.hidden = YES;
    self.liveTextField.alpha = 0;
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_setMonocular:(NSDictionary *)params {
    
    _isGlassesMode = [params[@"isMonocular"] boolValue];
    
    [self.danmuListView setNotAutoShow:_isGlassesMode];
    [self checkIsGlassesMode];
//    if (_isGlassesMode) {
//        self.danmuListView.hidden = _isGlassesMode;
//    }
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_setDanmuHiden:(NSDictionary *)params {
    
    self.gHidenDanmuV = [params[@"danmuHiden"] boolValue];
    
    [self.danmuListView setNotAutoShow:self.gHidenDanmuV];
    self.danmuListView.hidden = self.gHidenDanmuV || self.danmuListView.hidden;
    return nil;
}

#pragma mark - private

- (void)textFieldBecomeFirstResponder:(NSDictionary *)params {
    
    [self.liveTextField becomeFirstResponder];
}

- (void)dealloc
{
    DDLogInfo(@"danmuController dealloc");
}

-(void)checkIsGlassesMode
{
    self.danmuListView.hidden = self.isGlassesMode || self.danmuListView.hidden;
}
@end

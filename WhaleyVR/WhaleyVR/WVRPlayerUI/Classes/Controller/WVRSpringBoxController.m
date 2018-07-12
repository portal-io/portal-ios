//
//  WVRSpringBoxController.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 新春福卡抽奖

#import "WVRSpringBoxController.h"
#import "WVRSpringBoxView.h"

#import "WVRSpring2018Manager.h"
#import "WVRSpringGetCardView.h"
#import "WVRGotoNextTool.h"
#import "WVRPlayerHelper.h"
#import "WVRDetailVC.h"

#define COUNT_DOWN_NUM (@60)

@interface WVRSpringBoxController ()<WVRSpringBoxViewDelegate, WVRSpringGetCardViewDelegate> {
    
    RACDisposable *_startTimerHandler;
    RACDisposable *_stopTimerHandler;
}

@property (nonatomic, weak) id<WVRPlayerUIManagerProtocol> uiManager;

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) NSDictionary *ve;

@property (nonatomic, strong) WVRSpringBoxView *box;

@property (atomic, assign) BOOL isGlassesMode;

@property (nonatomic, assign) BOOL shouldHidden;

@property (nonatomic, strong) NSNumber *countdown;

@property (nonatomic, assign) BOOL isRequesting;

/// timer for countdown
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation WVRSpringBoxController

- (instancetype)initWithDelegate:(id<WVRPlayerUIManagerProtocol>)delegate {
    self = [super init];
    if (self) {
        [self setUiManager:delegate];
    }
    return self;
}

- (void)dealloc {
    
    DDLogInfo(@"WVRSpringBoxController dealloc");
}

- (void)configSelf {
    
    [self box];
    
    [self setCountdown:COUNT_DOWN_NUM];
    
    [self startTimer];
    
    [self installRAC];
}

- (void)installRAC {
    
    @weakify(self);
    [[[self.parentView wvr_viewController] rac_signalForSelector:@selector(viewDidAppear:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self startTimer];
    }];
    [[[self.parentView wvr_viewController] rac_signalForSelector:@selector(viewDidDisappear:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self stopTimer];
    }];
}

- (WVRSpringBoxView *)box {
    
    if (!_box) {
        WVRSpringBoxView *box = [[WVRSpringBoxView alloc] initWithFrame:CGRectMake(adaptToWidth(15), 86, fitToWidth(160), fitToWidth(60))];
        
        box.realDelegate = (id)self.uiManager;
        box.boxDelegate = self;
        
        [self.parentView insertSubview:box atIndex:0];
        _box = box;
        
        box.isLandscape = (self.parentView.width == MAX(SCREEN_HEIGHT, SCREEN_WIDTH));
        
//        int count = [[WVRSpring2018Manager shareInstance] leftCount];
        BOOL isLogined = [WVRUserModel sharedInstance].isLogined;
        
        if (!isLogined) {
            [box refreshUINotLogin];
        }
//        else if (count <= 0) {
//            [box makeConstraintsToRight];
//        } else {
//            [box makeConstraintsToLeft];
//        }
        
        [box makeConstraintsToLeft];
    }
    
    return _box;
}

/// 抽完奖更新UI
- (void)checkUIStatus {
    
    if ([WVRSpring2018Manager shareInstance].leftCount > 0) {
        
        self.countdown = COUNT_DOWN_NUM;
        [self.box updateCountDown:self.countdown.intValue isShow:!self.box.hidden];
    } else {
        
        [self.box leftCountUseUp];
    }
}

#pragma mark - timer

- (void)startTimer {
    
    if ([_timer isValid]) { return; }
    if (!self.box.window) { return; }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
}

- (void)timerCountdown {
    
    if (![WVRUserModel sharedInstance].isLogined || [WVRSpring2018Manager shareInstance].leftCount <= 0) {
        return;
    }
    if (![[WVRPlayerManager sharedInstance].vrPlayer isPrepared]) {
        return;
    }

    BOOL isLandscape = [self.uiManager performSelector:@selector(isLandscape)];
    BOOL viewsShow = ![self.parentView performSelector:@selector(isContorlsHide)];
    
    int countdown = self.countdown.intValue;
    BOOL valid = [WVRSpring2018Manager checkSpring2018Valid];
    BOOL isShow = (isLandscape && viewsShow);
    if (countdown >= 0) {

        [_box updateCountDown:countdown isShow:isShow && valid];
        self.countdown = @(countdown - 1);
    }
}

#pragma mark - WVRSpringBoxViewDelegate

- (void)springBoxTapAction:(NSTimeInterval)time {
    
    if ([[WVRSpring2018Manager shareInstance] leftCount] <= 0 || time > 0) {
        
        [self showAlertForActivityTip];
    } else {
        
        [self lotteryForSpring2018Card];
    }
}

- (void)lotteryForSpring2018Card {
    
    if (self.isRequesting) {
        DDLogInfo(@"lotteryForSpring2018Card self isRequesting");
        return;
    }
    
    self.isRequesting = YES;
    
    kWeakSelf(self);
    [WVRSpringCardModel requestForGetCard:^(WVRSpringCardModel *model, NSError *error) {
        
        if (model) {
            
            [weakself showCardViewWithModel:model];
        }else if(error.code == 510){
            SQToastInKeyWindow(@"活动已结束");
            weakself.box.hidden = YES;
            [WVRSpring2018Manager checkSpring2018Valid];
        }
        weakself.isRequesting = NO;
    }];
}

- (void)showAlertForActivityTip {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] initWithName:@"playerui_actionPause" params:nil receivers:PlayerUIEventReceiverManager];
    
    [self.uiManager dealWithEvent:event];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否离开当前播放，去往活动页面？" preferredStyle:UIAlertControllerStyleAlert];
    
    kWeakSelf(self);
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"继续观看", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] initWithName:@"playerui_actionResume" params:nil receivers:PlayerUIEventReceiverManager];
        
        [weakself.uiManager dealWithEvent:event];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"离开", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself jumpToSpringH5WebVC];
        });
    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    
    [[self.box wvr_viewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)showCardViewWithModel:(WVRSpringCardModel *)model {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] initWithName:@"playerui_actionPause" params:nil receivers:PlayerUIEventReceiverManager];
    
    [self.uiManager dealWithEvent:event];
    
    WVRSpringGetCardView *view = [[WVRSpringGetCardView alloc] initWithModel:model];
    view.delegate = self;
    
    UIViewController *vc = [UIViewController getCurrentVC_RootVC];
    [vc.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view.superview);
        make.size.equalTo(view.superview);
    }];
}

#pragma mark - WVRSpringGetCardViewDelegate

- (void)cardClosed {
    
    WVRPlayerUIEvent *event = [[WVRPlayerUIEvent alloc] initWithName:@"playerui_actionResume" params:nil receivers:PlayerUIEventReceiverManager];
    
    [self.uiManager dealWithEvent:event];
    
    [self checkUIStatus];
    
    NSLog(@"WVRSpringGetCardViewDelegate cardClosed");
}

- (void)gotoMyCardVC {
    
    [self checkUIStatus];
    
    [self jumpToSpringH5WebVC];
    
    NSLog(@"WVRSpringGetCardViewDelegate gotoMyCardVC");
}

- (void)jumpToSpringH5WebVC {
    
    WVRSpring2018InfoModel *infoModel = [WVRSpring2018Manager shareInstance].infoModel;
    
    WVRItemModel *model = [[WVRItemModel alloc] init];
    model.linkArrangeType = LINKARRANGETYPE_H5_INNER;
    model.linkArrangeValue = infoModel.url;
    model.code = infoModel.code;
    UIViewController * vc = [UIViewController getCurrentVC];
    if ([vc isKindOfClass:NSClassFromString(@"WVRPlayerVCTopic")]) {
        model.shouldPresent = YES;
    } else {
        WVRDetailVC * detailVC = (WVRDetailVC *)vc;
        model.backDelegate = detailVC;
//        detailVC.shouldScreenFull = YES;
//        @weakify(detailVC);
//        model.backCallBlock = ^{
//            @strongify(detailVC);
//            [detailVC.playerUI changeViewFrameForFull];
//        };
        [self.uiManager changeViewFrameForSmall];
    }
    [WVRGotoNextTool gotoNextVC:model nav:[UIViewController getCurrentVC].navigationController];
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
    
    [self stopTimer];
    
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

- (WVRPlayerUIEventCallBack *)playerui_execUpdateCountdown:(NSDictionary *)params {
    
    return nil;
}

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

- (WVRPlayerUIEventCallBack *)playerui_setMonocular:(NSDictionary *)params {
    
    _isGlassesMode = [params[@"isMonocular"] boolValue];
    
    [self.box setNotAutoShow:_isGlassesMode];
//    [self checkIsGlassesMode];
//    if (_isGlassesMode) {
//        self.box.hidden = _isGlassesMode;
//    }
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_setIsLandscape:(NSDictionary *)params {

    BOOL isLandscape = [params[@"isLandscape"] boolValue];
    self.box.isLandscape = isLandscape;
    if (isLandscape) {
        self.box.hidden = NO;
    } else {
        self.box.hidden = YES;
    }
    return nil;
}

- (void)checkIsGlassesMode {
    
//    self.box.hidden = self.isGlassesMode || self.box.hidden;
}

@end

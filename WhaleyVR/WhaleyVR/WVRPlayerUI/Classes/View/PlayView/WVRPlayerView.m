//
//  WVRPlayerView.m
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRPlayerView.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"
#import "WVRCameraStandTipView.h"
#import "WVRTrackEventMapping.h"
#import "WVRPlayerUIHeader.h"

#import "WVRPlayViewViewModel.h"

@interface WVRPlayerView () {
    
    BOOL _isRotationAnimating;
    UIView *_cameraStandTipView;
}

@property (nonatomic, readonly) NSString *errorMsg;

@property (nonatomic, weak) UIView *placeHolderView;    // forin循环的时候会用到

@property (nonatomic, weak) UITapGestureRecognizer *tap;

@property (nonatomic, readonly) BOOL isLandscape;

/// 仅供子类调用，外部慎用
@property (nonatomic, strong, readonly) NSMutableArray<UIView *> *hideArray;

@property (nonatomic, weak) UIView * gLoadingView;
@property (nonatomic, weak) UIView * gBackAnimationView;

/// 播放界面UI是否是隐藏状态
@property (atomic, assign) BOOL subviewsHidden;

@property (nonatomic, strong) NSMutableDictionary * gReusableNibsWithIdDic;

@end


@implementation WVRPlayerView
@synthesize viewStyle = _viewStyle;
@synthesize isVRMode = _isVRMode;
@synthesize ve = _tmpVE;
@synthesize gViewModel = _gViewModel;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildDatawithStyle:WVRPlayerViewStyleHalfScreen videoEntity:nil];
        [self createGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        [self buildDatawithStyle:WVRPlayerViewStyleHalfScreen videoEntity:nil];
        [self createGesture];
    }
    return self;
}

/// 通用初始化方法
- (instancetype)initWithFrame:(CGRect)frame style:(WVRPlayerViewStyle)style videoEntity:(NSDictionary *)ve delegate:(id)delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setDelegate:delegate];
        
        [self buildDatawithStyle:style videoEntity:ve];
        
        [self drawUI];
        [self createGesture];
    }
    return self;
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    [self setRealDelegate:delegate];
}

-(NSMutableDictionary *)gReusableNibsWithIdDic
{
    if (!_gReusableNibsWithIdDic) {
        _gReusableNibsWithIdDic = [[NSMutableDictionary alloc] init];
    }
    return _gReusableNibsWithIdDic;
}

- (void)reloadData {
    [self loadSubViews];
    [self createLayout];
    [self layoutIfNeeded];
}

- (void)loadSubViews
{
    [self.gLoadingView removeFromSuperview];
    [self.gBackAnimationView removeFromSuperview];
    
    UIView * loadingView = [self.dataSource loadingViewForPlayerView:self];
    [self insertSubview:loadingView atIndex:0];
    self.gLoadingView = loadingView;
    UIView * backView = [self.dataSource backAnimationViewForPlayerView:self];
//    backView.frame = CGRectMake(0, 0, 100, HEIGHT_TOP_VIEW_DEFAULT);
    [self insertSubview:backView atIndex:0];
    self.gBackAnimationView = backView;
}

- (void)createLayout
{
    [self.gLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
    }];
    [self.gBackAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TOP_VIEW_DEFAULT);
//        make.bottom.equalTo(self).offset([self.dataSource heightForTopView]-self.height);
        make.width.mas_equalTo(100);
    }];
}

- (void)fillData:(WVRPlayViewViewModel *)args {
    
    if (_gViewModel == args) {
        return;
    }
    _gViewModel = args;
    [self installRAC];
}

- (void)installRAC
{
//    @weakify(self);
//    //    RAC(self.titleL, text) = RACObserve(self.gViewModel, title);
//    [RACObserve(self.gViewModel, title) subscribeNext:^(id  _Nullable x) {
//
//        self.titleL.text = x;
//    }];
}

- (void)createGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _tap = tap;
}

- (void)buildDatawithStyle:(WVRPlayerViewStyle)style videoEntity:(NSDictionary *)ve {
    
    _viewStyle = style;
    self.ve = ve;
    
    _hideArray = [NSMutableArray array];
    
    // 初始化横竖屏状态的值
    _isLandscape = (style == WVRPlayerViewStyleLandscape);
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self placeHolderView];
    
//    [self loadingView];
}

#pragma mark - setter getter

- (WVRStreamType)streamType {
    
    return [self.ve[@"streamType"] integerValue];
}

#pragma mark - subviews

- (UIView *)placeHolderView {

    if (!_placeHolderView) {

        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        _placeHolderView = view;
    }
    return _placeHolderView;
}

#pragma mark - external func

- (void)resetVRMode {
    
    _isVRMode = NO;
//    [self.loadingView switchVR:NO];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.loadingView.center = CGPointMake(self.width/2.f, self.height/2.f);
}

- (void)addLayerToButton:(UIButton *)btn size:(CGSize)size {
    
    if (size.width == 0) {
        size = [WVRComputeTool sizeOfString:btn.titleLabel.text Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
    }
    
    CALayer *layer = [[CALayer alloc] init];
    float height = size.height + 6;
    float y = (btn.height - height) / 2.0;
    layer.frame = CGRectMake(0, y, btn.width, height);
    
    layer.cornerRadius = layer.frame.size.height / 2.0;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    [btn.layer insertSublayer:layer atIndex:0];
}

#pragma mark - Player

// 重新开始、播放下一个视频，显示startView
- (void)execWaitingPlay {
    
    self.gViewModel.errorCode = 0;
    if ([self streamType] != STREAM_VR_LIVE) {

        [self controlsShowHideAnimation:NO];
    } else {
//        [self.loadingView startAnimating:NO];
    }
}

- (void)execSuspend {
    
}

- (void)execStalled {
    
//    [self.loadingView startAnimating:self.isVRMode];
}

- (void)execError:(NSString *)message code:(NSInteger)code {
    
    self.gViewModel.errorCode = code;
    
//    if ([self streamType] == STREAM_VR_LIVE) {    // mark 针对直播
//        // 注：直播目前只有全屏界面
//        if (code == WVRPlayerErrorCodeNet) {
//            [SQToastTool showMessageCenter:self withMessage:kNetError];
//        } else {
//            [SQToastTool showMessageCenter:self withMessage:kPlayError];
//        }
//    } else if (!_isRotationAnimating) {
//
//        [self.startView onErrorWithMsg:message code:code];
//
//    } else {
//        _errorMsg = message;
////        [SQToastTool showMessage:self withMessage:kPlayError];
//    }
}

- (void)execPlaying {
    
//    [self.loadingView stopAnimating];
}

// 切换完清晰度也会走这里
- (void)execPreparedWithDuration:(long)duration {
    
    self.ve = [self.realDelegate actionGetVideoInfo:YES];
    
    self.gViewModel.errorCode = 0;
//    [self updateRemindChargeLabel];
    
//    [self.loadingView stopAnimating];
    [self scheduleHideControls];
    
    if (_isLandscape) {
        [self shouldShowCameraTipView];
    }
}

- (void)execDownloadSpeedUpdate:(long)speed {
    
    if ([self streamType] == STREAM_VR_LOCAL) { return; }
    
    DDLogInfo(@"speed: %ld", speed);
    
//    [self.loadingView updateNetSpeed:speed];
}

// 支付成功
- (void)execPaymentSuccess {
    
//    [_remindChargeLabel removeFromSuperview];
}

- (void)execFreeTimeOverToCharge:(long)freeTime duration:(long)duration {
    
    // 子类实现
    
    [self controlsShowHideAnimation:NO];
}

- (void)execDestroy {
    
//    [_startView dismiss];
//    [self.loadingView stopAnimating];
}

#pragma mark - getter

- (BOOL)isContorlsHide {
    
    return _subviewsHidden;
}

#pragma mark - private func

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)time/60, (int)time%60];
}

// View点击事件
- (void)toggleControls {
    
    [self.window endEditing:YES];
    if (self.gViewModel.playStatus == WVRPlayerToolVStatusWatingPay) {
        return;
    }
    [self controlsShowHideAnimation:![self isContorlsHide]];
}

- (void)scheduleHideControls {
    
    if (!self.superview) { return; }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];    // 清空schedule队列
    [self performSelector:@selector(hideControlsFast) withObject:nil afterDelay:kHideToolBarTime];
}

- (void)hideControlsFast {
    
    if ([self.realDelegate isWaitingForPlay]) { return; }
    
    [self controlsShowHideAnimation:YES];
}

- (void)controlsShowHideAnimation:(BOOL)isHide {
    self.gViewModel.viewIsHiden = isHide;
    if (self.gViewModel.isKeyBoardShow) { return; }     // 用户输入弹幕时不自动隐藏UI
//    if ([self isContorlsHide] == isHide) { return; }//此处不注释需要点击两次才隐藏
    if (_cameraStandTipView.superview) { return; }
    
    if (!_isLandscape) {
        BOOL hide = isHide;
        if ([self.realDelegate isOnError]) {
            hide = NO;
        }
        if ([self.realDelegate respondsToSelector:@selector(actionSetControlsVisible:)]) {
            [self.realDelegate actionSetControlsVisible:!isHide];
        }
    }

    if (isHide) {
        
        _subviewsHidden = YES;
        
        for (UIView *view in self.subviews) {
            
            BOOL notAutoHide = NO;
            if ([view respondsToSelector:@selector(playerUINotAutoHide)]) {
                id<WVRUINotAutoShowProtocol> cur = (id<WVRUINotAutoShowProtocol>)view;
                notAutoHide = [cur playerUINotAutoHide];
            }
            
            if (view.hidden == NO && !notAutoHide) {
                view.hidden = YES;
                [_hideArray addObject:view];
            }
        }
    } else {
        
        _subviewsHidden = NO;
        NSMutableArray * curHideArray = [NSMutableArray arrayWithArray:_hideArray];
        for (UIView *view in curHideArray) {
            
            BOOL notAutoShow = NO;
            if ([view respondsToSelector:@selector(playerUINotAutoShow)]) {
                id<WVRUINotAutoShowProtocol> cur = (id<WVRUINotAutoShowProtocol>)view;
                notAutoShow = [cur playerUINotAutoShow];
            }
            if (notAutoShow) {
                continue;
            }
            view.hidden = NO;
            [_hideArray removeObject:view];
        }

        [self scheduleHideControls];
    }
}

//MARK: - 横竖屏转换完成, UI适配 横屏（true）  竖屏（false）
- (void)screenRotationCompleteWithStatus:(BOOL)isLandscape {
    
    _isRotationAnimating = NO;
    _isLandscape = isLandscape;
    
    if (!isLandscape) {
        _isVRMode = NO;
    }
    
    Class loadingCls = NSClassFromString(@"WVRPlayerLoadingView");
    for (UIView *view in self.subviews) {
        if (view.hidden == YES) {
            continue;
        }
        if ([view isKindOfClass:loadingCls]) {
            [self bringSubviewToFront:view];
        }
    }
//    if (_errorCode != 0) {
//        [self.startView onErrorWithMsg:_errorMsg code:_errorCode];
//    }
    
    if (isLandscape) {
        [self shouldShowCameraTipView];
    }
}

- (void)shouldShowCameraTipView {
    if ([WVRAppModel sharedInstance].footballCameraTipIsShow) {
        return;
    }
    [self controlsShowHideAnimation:NO];
    
    UIView *bottomView = nil;
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"BottomView"]) {
            bottomView = subview;
            break;
        }
    }
    
    if (![bottomView respondsToSelector:@selector(isFootball)]) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGPoint point = CGPointZero; // CGPointMake(self.cameraBtn.centerX, self.cameraBtn.bottomY + 7);
        if ([bottomView respondsToSelector:@selector(cameraPoint)]) {
            NSString *pointStr = [bottomView performSelector:@selector(cameraPoint)];
            point = CGPointFromString(pointStr);
        }
        
        WVRCameraStandTipView *view = [[WVRCameraStandTipView alloc] initWithX:point.x y:point.y];
        [self.superview addSubview:view];
        _cameraStandTipView = view;
    });
    [WVRAppModel sharedInstance].footballCameraTipIsShow = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (_isRotationAnimating) { return NO; }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (gestureRecognizer == _tap) {
        return (touch.view == self);
    }
    return YES;
}

#pragma mark - touches

static bool _touchSelf = false;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        _touchSelf = true;
        [self.realDelegate actionTouchesBegan];
    } else {
        _touchSelf = false;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!_touchSelf) { return; }
    
    UITouch *touch = [touches anyObject];
    int scale = 2;        // [UIScreen mainScreen].scale    // 防止6P上动的太快
    CGPoint point = [touch locationInView:self];
    [self.realDelegate actionPanGustrue:(point.x * scale) Y:(point.y * scale)];
}

#pragma WVRPlayViewProtocol

- (WVRPlayViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    WVRPlayViewCell* cell = nil;
    if (identifier.length > 0) {
        cell = self.gReusableNibsWithIdDic[identifier];
    } else {
        NSAssert(YES, @"identifier must not nil");
    }
    return cell;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    if (identifier.length > 0) {
        self.gReusableNibsWithIdDic[identifier] = nib;
    } else {
        NSAssert(YES, @"identifier must not nil");
    }
}

@end

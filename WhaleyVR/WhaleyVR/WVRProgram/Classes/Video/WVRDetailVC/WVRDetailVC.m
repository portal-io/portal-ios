//
//  WVRDetailVC.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/9.
//  Copyright © 2016年 Snailvr. All rights reserved.
//
// 详情页基类，请勿直接使用

#import "WVRDetailVC.h"
#import "WVRNavigationController.h"

#import "WVRLiveDetailVC.h"
#import "WVRBIModel.h"
#import "WVRHistoryModel.h"
#import "WVRTVDetailBaseController.h"

#import "WVRProgramPackageController.h"
#import "WVRVideoEntityMoreTV.h"

#import "WVRHttpWatchOnlineRecord.h"
#import "WVRWatchOnlineRecord.h"
#import "WVRParseUrl.h"
#import "WVRDeviceModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "WVRChartletManager.h"

#import "WVRMediator+UnityActions.h"
#import "WVRMediator+PayActions.h"
#import "WVRMediator+AccountActions.h"
#import "WVRPlayerHelper.h"
#import "WVRProgramBIModel.h"
#import "WVRPlayerDramaUIManager.h"
#import "WVRDramaDetailVC.h"

#import "WVRSpring2018Manager.h"

@interface WVRDetailVC ()<WVRPlayerUIManagerDelegate> {
    
    long _isLowFps;
    long _pollingNum;
    BOOL _shouldAutorotate;
    UIInterfaceOrientationMask _supportedInterfaceO;
    
    BOOL _isDisapper;
    BOOL _isNotFirstIn;
    id _rac_handler;
}

@property (nonatomic, weak) NSTimer  *timer;

@property (assign, atomic) BOOL parseURLComplete;         // 解析链接完成
@property (atomic, assign) BOOL requestChargedComplete;   // 请求是否付费完成

@property (nonatomic, assign) BOOL isLandspace;

@property (nonatomic, strong) WVRWatchOnlineRecord * gwOnlineRecord;

@property (nonatomic, strong) WVRChartletManager *chartletManager;

/// 横屏的时候跳转购买
@property (nonatomic, assign) BOOL buyFromLandscape;

@end


@implementation WVRDetailVC
@synthesize bar;
@synthesize playerUI = _tmpPlayerUI;        // 调用请走get方法

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // 详情页默认不会出现在tab中，所以这个属性默认置为YES
        self.hidesBottomBarWhenPushed = YES;
        
        _supportedInterfaceO = UIInterfaceOrientationMaskPortrait;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.gwOnlineRecord) {
        self.gwOnlineRecord = [WVRWatchOnlineRecord new];
    }
    [[WVRMediator sharedInstance] WVRMediator_ReportLostInAppPurchaseOrders];
    
    [self configSelf];
    
    [self buildData];
    
    [self drawUI];
    
    [self setUpRequestRAC];
    [self requestData];
    
    [self setupRACObserve];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WVRSpring2018Manager checkForSpring2018Status];
    [WVRSpring2018Manager checkForSpringLeftCount];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [WVRAppModel forceToOrientation:UIInterfaceOrientationPortrait];
    if (self.shouldScreenFull) {
        [self.playerUI changeViewFrameForFull];
        self.shouldScreenFull = NO;
    }
    if (bar) {
        
        [self.view bringSubviewToFront:bar];
        [bar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerObserverEvent];
    
    _isDisapper = NO;
    [self invalidNavPanGuesture:NO];
    self.view.window.backgroundColor = [UIColor blackColor];
    
    if (self.playerUI.dealWithUnityBack == WVRPlayerUnityBackDealRotation && (self.playerUI.tmpPlayerViewStatus == WVRPlayerUIViewStatusHalfVertical)) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.playerUI changeViewFrameForSmall];
        });
    } else if (self.playerUI.dealWithUnityBack == WVRPlayerUnityBackDealExit) {
        self.playerUI.dealWithUnityBack = WVRPlayerUnityBackDealNothing;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionOnExit];
        });
        return;
    }
    self.playerUI.dealWithUnityBack = WVRPlayerUnityBackDealNothing;
    
    // 互动剧从Unity回来后自己处理数据
    if (![self isKindOfClass:NSClassFromString(@"WVRDramaDetailVC")] || !self.playerUI.isGoUnity) {
        [self checkPlayerStatusWhenBackFromOtherPage];
    }
    
    if (_isNotFirstIn) {
        [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
    }
    _isNotFirstIn = YES;
    self.playerUI.unityBackParams = nil;
}

- (void)checkPlayerStatusWhenBackFromOtherPage {
    
    if (self.vPlayer.isFreeTimeOver) {
        
        // 试看结束后回来，不自动开播
        
    } else if (self.vPlayer.isOnDestroy || self.vPlayer.isReleased) {
        
        if (![self.playerUI isHaveStartView]) {
            [self.playerUI execStalled];
        } else {
            [self.playerUI execCheckStartViewAnimation];
        }
        
        if (self.playerUI.isLandscape) {
            [WVRAppModel changeStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        }
        if (self.playerUI.isGoUnity) {
            
            @weakify(self);                                                                             
            __block RACDisposable *handler = [RACObserve(self.playerUI, unityBackParams) subscribeNext:^(id x) {
                
                if (nil != x) {
                    
                    @strongify(self);
                    
                    [self dealwithUnityBackParams];
                    [handler dispose];
                }
            }];
            _rac_handler = handler;
            
        }else if (self.playerUI.isGoUnityFootball){
            self.curPosition = [_vPlayer getCurrentPosition];
            [self startTimer];
            [self readyToPlay];
        }
        else {
            
            [self startTimer];
            [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
        }
    }
}

- (void)dealwithUnityBackParams {
    
    NSString *definition = self.playerUI.unityBackParams[@"currentQuality"];
    long position = [self.playerUI.unityBackParams[@"currentPosition"] integerValue];
    
    if ([self.videoEntity.curDefinition isEqualToString:definition]) {
        
        [self startTimer];
        [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
    } else {
        self.curPosition = position;
        self.curDefinition = definition;
        
        [self startTimer];
        [self readyToPlay];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _isDisapper = YES;
    
    [self destroyForDisapper];
    
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    if (!self.navigationController && !self.presentingViewController) {       // pop
        
        [self invalidNavPanGuesture:NO];
        [self destroyResourceForDealloc];
        
    } else {
        BOOL isNotPortrait = ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait);
        
        [self invalidNavPanGuesture:isNotPortrait];
    }
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
    
    UIViewController *currentVC = [UIViewController getCurrentVC];
    BOOL goUnity = [currentVC isKindOfClass:NSClassFromString(@"UnityViewControllerBase")];
    if (!goUnity) {
        self.playerUI.isGoUnity = NO;
        [self playerUI].isGoUnityFootball = NO;
    }
}

- (void)destroyForDisapper {
    [self recordHistory];
    
    [self watch_online_record:NO];
    if (self.vPlayer.isValid) {
        if (!self.navigationController) {
            [_vPlayer onBackForDestroy];
        } else {
            self.vPlayer.dataParam.position = [self.vPlayer getCurrentPosition];
            
            [self.vPlayer destroyPlayer];
            [self.playerUI execSuspend];
        }
    }
    
    [self stopTimer];
}

- (void)watch_online_record:(BOOL)isComin {
    NSString * contentType = @"live";
    switch (self.videoEntity.streamType) {
        case STREAM_3D_WASU:
        case STREAM_VR_VOD:
        case STREAM_2D_TV:
            
            contentType = @"recorded";
            break;
        case STREAM_VR_LOCAL:
        case STREAM_VR_LIVE:
            return;
            break;
            
        default:
            return;
            break;
    }
    WVRWatchOnlineRecordModel * recordModel = [WVRWatchOnlineRecordModel new];
    recordModel.code = self.videoEntity.sid;
    recordModel.contentType = contentType;
    recordModel.type = [NSString stringWithFormat:@"%d", isComin];
    recordModel.deviceNo = [WVRUserModel sharedInstance].deviceId;
    if (isComin) {
        [self.gwOnlineRecord http_watch_online_record:recordModel];
    } else {
        [self.gwOnlineRecord http_watch_online_unrecord:recordModel];
    }
}

- (void)dealloc {
    
    [self destroyResourceForDealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)destroyResourceForDealloc {
    
    DDLogInfo(@"destroyResource");
    
    [self stopTimer];
    
    [self.vPlayer onBackForDestroy];
    [self.playerUI execDestroy];
}

#pragma mark - build data

// 初始化数据
- (void)buildData {
    
    _pollingNum = 1;
    
    _isLowFps = 5;
    
    [self playerUI];
}

- (void)configSelf {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNavBar];
}

// 该方法在详情页生命周期内被调用2次
- (void)drawUI {
    
    if (bar) { [self.view bringSubviewToFront:bar]; }
}

- (void)createNavBar {
    
    bar = [[WVRDetailNavigationBar alloc] init];
    
    [self.view addSubview:bar];
}

- (void)navShareSetting {
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIImage *backimage = [[UIImage imageNamed:@"icon_manual_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    item.leftBarButtonItems = @[ backItem ];
    
    UIImage *image = [[UIImage imageNamed:@"icon_detail_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *ShareItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarShareItemClick)];
    
    item.rightBarButtonItems = @[ ShareItem ];
    
    [self.bar pushNavigationItem:item animated:NO];
}

- (void)navBackSetting {
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIImage *backimage = [[UIImage imageNamed:@"icon_manual_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    
    item.leftBarButtonItems = @[ backItem ];
    
    [self.bar pushNavigationItem:item animated:NO];
}

- (void)purchaseBtnHideWithAnimation {
    // 子类有需求实现
}

- (void)dealWithDetailData {
    
    [[self playerUI] updateAfterSetParams];
}

#pragma mark - action

// 返回
- (void)leftBarButtonClick {
    
    [self stopTimer];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 分享 子类中如果有分享按钮，就把此方法实现
- (void)rightBarShareItemClick {
    
    [self.vPlayer stop];
}

- (void)invalidNavPanGuesture:(BOOL)isInvalid {
    
    WVRNavigationController *nav = (WVRNavigationController *)self.navigationController;
    nav.gestureInValid = isInvalid;
}

#pragma mark - request

- (void)setUpRequestRAC {
    
    @throw [NSException exceptionWithName:@"error" reason:@"You Must OverWrite This Function In SubClass" userInfo:nil];
}

- (void)requestData {
    
    @throw [NSException exceptionWithName:@"error" reason:@"You Must OverWrite This Function In SubClass" userInfo:nil];
}

#pragma mark - 半屏播放器

- (void)startToPlay {
    
    if (self.vPlayer.isValid) {
        [self.vPlayer stop];   // 针对连播，点击其他剧集后先把播放器停掉
    }
    
    [self createwPlayerView];
    
    [self buildInitData];
}

- (NSInteger)playerStatus {
    
    NSInteger status = 0;
    if (self.vPlayer.isComplete) {
        status = 2;
    } else if (self.vPlayer.isPlaying) {
        status = 1;
    } else {
        status = 0;
    }
    return status;
}

- (void)createwPlayerView {
    
    if (![[self playerUI] playerView]) {
        
        [self.playerUI createPlayerViewWithContainerView:self.playerContentView];
        
        [self createPlayerHelperIfNot];
        
    } else {
        
        [self.playerUI execWaitingPlay];
    }
}

- (UIView *)playerContentView {
    
    if (!_playerContentView) {
        
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        float height = roundf(width / 18.f * 11);
        
        if ([self.detailBaseModel.videoType isEqualToString:VIDEO_TYPE_VR]) {
            height = width;
        }
        if ([self isMemberOfClass:NSClassFromString(@"WVRDramaDetailVC")]) {
            height = width;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height+(kDevice_Is_iPhoneX? kStatuBarHeight:0))];
        view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view];
        
        _playerContentView = view;
        
        if (bar) { [self.view bringSubviewToFront:bar]; };
    }
    
    return _playerContentView;
}

#pragma mark - getter

- (WVRChartletManager *)chartletManager {
    if (!_chartletManager) {
        _chartletManager = [[WVRChartletManager alloc] init];
    }
    return _chartletManager;
}

- (WVRPlayerDetailUIManager *)playerUI {
    if (!_tmpPlayerUI) {

        _tmpPlayerUI = [[WVRPlayerDetailUIManager alloc] init];
        _tmpPlayerUI.uiDelegate = self;
        [_tmpPlayerUI installAfterSetParams];
        if (self.detailBaseModel) {
            [_tmpPlayerUI updateAfterSetParams];
        }
    }
    return _tmpPlayerUI;
}

#pragma mark - init Data

- (void)buildInitData {
    
    [self checkForCharge];
    [self dealWithPlayUrl];
}

// 付费流程检测
- (void)checkForCharge {
    
    _isCharged = NO;
    _requestChargedComplete = NO;
    
    BOOL chargeable = self.detailBaseModel.isChargeable;
    BOOL notFree = YES;        // (self.detailBaseModel.price > 0)
    
    if (chargeable && notFree) {
        
        [self requestForPaied];
    } else {
        _requestChargedComplete = YES;
        _isCharged = YES;
    }
}

- (void)requestForPaied {
    
    PurchaseProgramType type = PurchaseProgramTypeVR;
    if (self.videoEntity.streamType == STREAM_VR_LIVE) {
        type = PurchaseProgramTypeLive;
    }
    _requestChargedComplete = NO;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        @strongify(self);
        [self dealWithCheckVideoPaied:[input boolValue]];
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            return nil;
        }];
    }];
    
    param[@"goodNo"] = self.detailBaseModel.sid;
    param[@"goodType"] = @"recorded";
    param[@"cmd"] = cmd;

    [[WVRMediator sharedInstance] WVRMediator_CheckVideoIsPaied:param];
}

- (void)dealWithCheckVideoPaied:(BOOL)isCharged {
    
    if (self.vPlayer.isOnBack) { return; }
    
    _requestChargedComplete = YES;
    self.isCharged = isCharged;
    
    [self dealWithPaymentOver:YES];
}

// 检测支付/支付流程结束 调用 isCheck区分：检测支付/支付流程结束
- (void)dealWithPaymentOver:(BOOL)isCheck {
    
    if (_isCharged) { [self purchaseBtnHideWithAnimation]; }
    
    if (self.isCharged || self.vPlayer.isFreeTimeOver == NO) {
        [self startTimer];
    }
    
    if (self.vPlayer.isValid) {
        
        if (_isCharged || self.vPlayer.getCurrentPosition/1000.f < _detailBaseModel.freeTime) {
            
            [self.vPlayer start];
            
            if (_isCharged && !isCheck) {
                [self.playerUI execPaymentSuccess];
            }
            if ([self.vPlayer isPlaying]) {
                [self.playerUI execPlaying];
            }
        }
        
    } else if (self.vPlayer.isOnDestroy || self.vPlayer.isReleased) {
        
        WVRDataParam *dataM = self.vPlayer.dataParam;
        dataM.position = [self.vPlayer getCurrentPosition];
        if (_buyFromLandscape) {
            
            kWeakSelf(self);
            [self.playerUI forceToOrientationMaskLandscapeRightWithAnimation:^{
                
                [weakself rotaionAnimations:YES];
                
            } completion:^{
                
                weakself.buyFromLandscape = NO;
                
                [weakself.vPlayer setParamAndPlay:dataM];
            }];
            
        } else {
            [self.vPlayer setParamAndPlay:dataM];
        }
        
        if (_isCharged && !isCheck) {
            [self.playerUI execPaymentSuccess];
        }
        [self.playerUI execWaitingPlay];
        
    } else {
        [self readyToPlay];
    }
}

- (void)dealWithPlayUrl {
    
    _parseURLComplete = NO;
    
    kWeakSelf(self);
    
    [_videoEntity parserPlayUrl:^{
        
        if (weakself.vPlayer.isOnBack) { return; }
        
        if (weakself.videoEntity.haveValidUrlModel) {
            
            DDLogInfo(@"parserPlayUrl 解析成功");
            weakself.parseURLComplete = YES;
            [weakself readyToPlay];
            
        } else {
            weakself.parseURLComplete = NO;
            
            if ([weakself reParserPlayUrl]) {
                
                [weakself buildInitData];
                [weakself.playerUI execWaitingPlay];
                
            } else {
                BOOL netOK = [WVRReachabilityModel isNetWorkOK];
                NSString *err = netOK ? kNoNetAlert : kLinkError;
                [weakself dealWithError:err code:(netOK ? WVRPlayerErrorCodePlay : WVRPlayerErrorCodeNet)];
            }
        }
    }];
}

- (void)dealWithError:(NSString *)err code:(int)code {
    
    [self.playerUI execError:err code:code];
    [self.vPlayer playError:err code:code videoEntity:_videoEntity];
}

#pragma mark - Notification

- (void)registerObserverEvent {      // 界面"暂停／激活"事件注册
    
    // 防止重复监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)setupRACObserve {
    
    kWeakSelf(self);
    [[RACObserve(self, videoEntity) skip:1] subscribeNext:^(id  _Nullable x) {
        
        weakself.playerUI.videoEntity = weakself.videoEntity;
    }];
    
    [[RACObserve(self, detailBaseModel) skip:1] subscribeNext:^(id  _Nullable x) {
        
        weakself.playerUI.detailBaseModel = weakself.detailBaseModel;
    }];
    [[RACObserve(self, vPlayer) skip:1] subscribeNext:^(id  _Nullable x) {
        
        weakself.playerUI.vPlayer = weakself.vPlayer;
    }];
    [[RACObserve(self, isCharged) skip:0] subscribeNext:^(id  _Nullable x) {
        
        weakself.videoEntity.isCharged = weakself.isCharged;
    }];
}

- (void)appWillEnterBackground:(NSNotification *)notification {
    
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[WVRUMShareView class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
    
    if (!self.vPlayer.isValid) { return; }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.vPlayer isOnPrepared]) {
//            [self.playerUI execPlaying];
//            [self startTimer];
        } else {
            [self.playerUI execCheckStartViewAnimation];
        }
    });
}

#pragma mark - WVRPlayerHelperDelegate

- (void)restartUI {
    
    [self.playerUI execPlaying];
}

- (void)pauseUI {
    
    [self.playerUI execSuspend];
}

- (BOOL)respondNetStatusChange {
    
    return [self isCurrentViewControllerVisible];
}

- (void)onVideoPrepared {
    
    [self startTimer];
    
    [self createPlayerBottomImage];
    
    [self.playerUI execPreparedWithDuration:[_vPlayer getDuration]];
    
    [self watch_online_record:YES];
//    [self recordHistory];
    
    if (_isDisapper) {
        [self destroyForDisapper];
    }
    
//    if (self.isCharged) {
//        [self.playerUI execPaymentSuccess];
//    }
}

- (void)onCompletion {      // 互动剧重写该方法
    
    [self stopTimer];
    
    BOOL netOK = [WVRReachabilityModel isNetWorkOK];
    if (!netOK) {
        [self.playerUI execSuspend];
        
        return;
    }
    [self recordHistory];
    [self watch_online_record:NO];
    // 连播
    if (self.videoEntity.streamType == STREAM_2D_TV) {
        WVRVideoEntityMoreTV *ve = (WVRVideoEntityMoreTV *)_videoEntity;
            
        if ([ve canPlayNext]) {
            [self playNextVideo];
            [self.playerUI execWaitingPlay];
            
            return;     // 播放到最后一集就结束
        }
    }
    
    [self.playerUI execCompletion];
}

- (void)onError:(int)what {
    self.curPosition = [self.vPlayer getCurrentPosition];
    NSString *err = [NSString stringWithFormat:@"%d", what];
    
    [self stopTimer];
    if (!self.playerUI.isLandscape) {
        self.bar.hidden = NO;   // 竖屏播放模式下，onError后把导航栏和返回按钮显示出来
    }
    BOOL netOK = [WVRReachabilityModel isNetWorkOK];
    if (!netOK) {
//        [self.playerUI execSuspend];
        [self dealWithError:err code:(netOK ? WVRPlayerErrorCodeLink : WVRPlayerErrorCodeNet)];
        return;
    }
    if ([self reParserPlayUrl]) {
        
        [self buildInitData];
        [self.playerUI execWaitingPlay];
        
    } else {
        
        BOOL netOK = [WVRReachabilityModel isNetWorkOK];
        [self dealWithError:err code:(netOK ? WVRPlayerErrorCodeLink : WVRPlayerErrorCodeNet)];
    }
}

// 播放卡顿
- (void)onBuffering {
    
    [self.playerUI execStalled];
}

- (void)onBufferingOff {
    
    [self.playerUI execPlaying];
}

- (void)reParserUrlForNetChanged:(long)position {
    _curPosition = position;
    
    [self dealWithPlayUrl];
    [[self playerUI] execStalled];
}

- (void)onGLKVCdealloc {
    
    if ([self.detailBaseModel isFootball]) {
        
        [self showFootballUnity];
    
    } else {
        
        [self showUnityView];
    }
}

#pragma mark - timer

- (void)startTimer {
    
    if ([_timer isValid]) { return; }
    
    //MARK: - 直播详情页目前不播放视频
    if (self.videoEntity.streamType == STREAM_VR_LIVE) { return; }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(syncScrubber) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
}

// 此刷新函数每隔interval执行一次
- (void)syncScrubber {
    
    long speed = [[WVRAppModel sharedInstance] checkInNetworkflow];
    if (![_vPlayer isPlaying]) {
        
        [self.playerUI execDownloadSpeedUpdate:speed];
        
    } else {
        
        long time = [_vPlayer getCurrentPosition];
        [self checkFreeTime:time];
        
        long buffer = [_vPlayer getPlayableDuration];
        
        [self.playerUI execPositionUpdate:time buffer:buffer duration:[_vPlayer getDuration]];
        
//        [self checkFps];
        [self checkChargeDevice];
    }
    
//    [self.playerUI execUpdateCountdown];
    
    _pollingNum ++;
    _isLowFps ++;
}

//- (void)checkFps {
//
//    float fps = [_vPlayer getFps];
//    if (fps < 15 && _isLowFps >= 5) {
//
//        _videoEntity.biEntity.bitrate = fps;
//        [_vPlayer trackEventForLowbitrate];
//        _isLowFps = 0;      // not track in 5 second
//    }
//}

// time = ms
- (void)checkFreeTime:(long)time {
    
    if (!self.isCharged && time / 1000 >= _detailBaseModel.freeTime) {
        
        [_vPlayer destroyPlayer];
        _vPlayer.isFreeTimeOver = YES;
        
        [self.playerUI execFreeTimeOverToCharge:_detailBaseModel.freeTime];
        _curPosition = 0.1;
        self.vPlayer.dataParam.position = 0;
    }
}

- (void)checkChargeDevice {
    
    if (_pollingNum % 10 == 0 && self.isCharged && _detailBaseModel.isChargeable) {
        
        @weakify(self);
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self dealWithPlayDeviceUnsigned];
                return nil;
            }];
        }];
        NSDictionary *dict = @{ @"cmd":cmd };
        
        [[WVRMediator sharedInstance] WVRMediator_CheckDevice:dict];
    }
}

- (void)dealWithPlayDeviceUnsigned {
    
    [self controlOnPause];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self actionOnExit];
            return nil;
        }];
    }];
    NSDictionary *dict = @{ @"cmd":cmd };
    [[WVRMediator sharedInstance] WVRMediator_ForceLogout:dict];
}

#pragma mark - ready

- (BOOL)requestDataOver {
    
    return (_requestChargedComplete && _parseURLComplete);
}

// 只有需要购买并且尚未购买的视频才会走到试看逻辑
- (BOOL)videoCanTrail {
    
    if (self.videoEntity.streamType == STREAM_VR_LIVE) {
        // 直播试看过一次之后就不允许再次试看
        if ([[WVRAppModel sharedInstance].liveTrailDict objectForKey:self.detailBaseModel.code]) {
            return NO;
        }
    }
    
    if (self.detailBaseModel.freeTime > 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)checkReadyToPlay {
    
    if (![self requestDataOver]) { return NO; }
    
    if (self.isCharged || [self videoCanTrail]) {
        
        return YES;
    }
    return NO;
}

- (void)readyToPlay {
    
    if (self.vPlayer.isOnBack) { return; }
    if (![self isCurrentViewControllerVisible]) { return; };
    
    if ([self checkReadyToPlay]) {
        
        if (_detailBaseModel.isChargeable && _isCharged) {
            
            [[WVRMediator sharedInstance] WVRMediator_PayReportDevice:nil];
        }
        [self actionPlay:NO];
        
    } else if ([self requestDataOver] && ![self videoCanTrail]) {
        // 该视频付费，且无法试看
        [self.playerUI execFreeTimeOverToCharge:0];
    }
}

- (void)createPlayerBottomImage {       // 底图
    
    [self createPlayerFootballBackgroundImageWithVIP:[self.videoEntity isCameraStandVIP]];
    
    [self.chartletManager createPlayerBottomImageWithVideoEntity:[self videoEntity] player:self.vPlayer detailModel:self.detailBaseModel];
}

- (void)createPlayerFootballBackgroundImageWithVIP:(BOOL)isVIP {       // 180背景图
    
    [self.chartletManager createPlayerFootballBackgroundImageWithVIP:isVIP ve:[self videoEntity] player:self.vPlayer detailModel:self.detailBaseModel];
}

- (void)createPlayerHelperIfNot {
    
    if (nil == self.vPlayer) {
        self.vPlayer = [[WVRPlayerHelper alloc] initWithContainerView:self.playerContentView MainController:self];
        self.vPlayer.playerDelegate = self;
        self.vPlayer.biModel.screenType = 2;
    }
}

#pragma mark - WVRPlayerViewDelegate

- (void)actionGotoBuy {
    
    if (self.playerUI.isLandscape) {
        
        kWeakSelf(self);
        _buyFromLandscape = YES;
        [self.playerUI forceToOrientationPortrait:^{
            [weakself didGoBuy];
        }];
    } else {
        _buyFromLandscape = NO;
        [self didGoBuy];
    }
}

- (void)didGoBuy {
    
    [self controlOnPause];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSInteger payResult = [input[@"success"] integerValue];
            @strongify(self);
//            if (payResult == 1 || payResult == 3) {
//                [self toOrientation];
//            }
            BOOL success = (payResult == 1);
            [self dealWithPaymentResult:success];
            
            return nil;
        }];
    }];
    
//    @{ @"itemModel":WVRItemModel, @"streamType":WVRStreamType , @"cmd":RACCommand }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"streamType"] = @(self.videoEntity.streamType);
    dict[@"itemModel"] = self.detailBaseModel;
    dict[@"cmd"] = cmd;
    
    [[WVRMediator sharedInstance] WVRMediator_PayForVideo:dict];
}

- (void)dealWithPaymentResult:(BOOL)isSuccess {
    
    self.isCharged = isSuccess;
    if (isSuccess) {

        [[WVRMediator sharedInstance] WVRMediator_PayReportDevice:nil];

        [self dealWithPaymentOver:NO];

    } else {
        
        [self controlOnResume];
    }
}

- (void)actionOnExit {
    if (self.playerUI.isLandscape) {
        
        kWeakSelf(self);
        [self.playerUI forceToOrientationPortrait:^{
            [weakself leftBarButtonClick];
        }];
        
    } else {
        [self leftBarButtonClick];
    }
}

- (void)actionPause {
    
    [self stopTimer];
}

- (void)actionResume {
    
    [self startTimer];
}

- (BOOL)actionCheckLogin {
    
    [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    
    RACCommand *successCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    
    RACCommand *cancelCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [WVRAppModel sharedInstance].shouldContinuePlay = NO;
            return nil;
        }];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"completeCmd"] = successCmd;
    dict[@"cancelCmd"] = cancelCmd;
    
    BOOL isLogin = [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:dict];
    
    return isLogin;
}

#pragma mark - 私有方法

- (void)controlOnPause {
    
    [self stopTimer];
    [self.vPlayer stop];
    [self.playerUI execSuspend];
}

- (void)controlOnResume {
    
    if ([self.vPlayer isValid]) {
        
        [self startTimer];
        
        [self.vPlayer start];
        if (self.vPlayer.isPlaying) {
            [self.playerUI execPlaying];
        }
    }
}

#pragma mark - goto Launcher

- (void)showUnityView {

    [self watch_online_record:NO];
    
    self.playerUI.isGoUnity = YES;
    
    [[WVRMediator sharedInstance] WVRMediator_showU3DView:NO];
    
    NSString *tag = nil;
    
    if ([self.detailBaseModel respondsToSelector:@selector(tags)]) {
        id tmp_tags = [self.detailBaseModel performSelector:@selector(tags)];
        if ([tmp_tags isKindOfClass:[NSString class]]) {
            
            tag = tmp_tags;
        }
    }
    
    double progress = [_vPlayer getCurrentPosition] / (double)[_vPlayer getDuration];
    
    NSDictionary *linkDict = _videoEntity.currentLinkDict;
    NSMutableArray *pathArr = [NSMutableArray array];
    BOOL needFilter = (![WVRDeviceModel is4KSupport] && linkDict.count >= 2);
    
    for (WVRPlayUrlModel *model in linkDict.allValues) {
        WVRUnityActionPlayPathModel *pathModel = [[WVRUnityActionPlayPathModel alloc] init];
        
        pathModel.url = model.url.absoluteString;
        pathModel.renderType = model.renderType;
        pathModel.bittype = model.definition;
        
        // bug 11584, 不支持4k将链接直接过滤(链接数大于等于2),如果只有一个链接,就在播放时不跳转Unity
        if (needFilter && [model.definition isEqualToString:kDefinition_HD]) {
            continue;
        }
        
        [pathArr addObject:pathModel];
    }
    
    [[WVRMediator sharedInstance] WVRMediator_setPlayerHelper:self.vPlayer];
    [[WVRMediator sharedInstance] WVRMediator_setUIManager:self.playerUI];
    
    WVRUnityActionPlayModel *model = [[WVRUnityActionPlayModel alloc] init];
    model.sid = self.videoEntity.sid;
    model.title = self.videoEntity.videoTitle;
    model.pathArray = pathArr;
    model.streamType = self.videoEntity.streamType;
    model.detailType = self.videoEntity.detailModel.detailType;
    model.progress = progress;
    model.duration = [_vPlayer getDuration];
    model.tags = tag;
    model.videoFormat = [self videoFormat];
    model.contentType = [self biContentType];
    model.isChargeable = self.detailBaseModel.isChargeable;
    
    if (needFilter && [self.videoEntity.curDefinition isEqualToString:kDefinition_HD]) {
        WVRUnityActionPlayPathModel *pathModel = [pathArr firstObject];
        
        model.quality = pathModel.bittype;
        model.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:model.quality renderTypeStr:pathModel.renderType];
    } else {
        
        model.quality = self.videoEntity.curDefinition;
        model.renderType = self.vPlayer.getRenderType;
    }
    
//    model.renderTypeStr = self.videoEntity.curUrlModel.renderType;
    
    model.videoInfo = [self videoInfo];
    
    if (!self.isCharged) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"freeTime"] = @(self.detailBaseModel.freeTime);
        if (self.detailBaseModel.contentPackageQueryDtos.count) {
            dict[@"contentPackageQueryDtos"] = self.detailBaseModel.contentPackageQueryDtos;
        }
        if (self.detailBaseModel.couponDto.price) {
            dict[@"couponDto"] = self.detailBaseModel.couponDto;
        }
        model.payModel = dict;
    }
    
    [[WVRMediator sharedInstance] WVRMediator_sendUnityToPlay:model];
}

- (void)showFootballUnity {
    self.playerUI.isGoUnityFootball = YES;
    [[WVRMediator sharedInstance] WVRMediator_showU3DView:NO];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    dict[@"behaviour"] = self.detailBaseModel.behavior;
    dict[@"matchId"] = @([[[self.detailBaseModel.behavior componentsSeparatedByString:@"="] lastObject] intValue]);
    dict[@"defaultSlot"] = self.videoEntity.currentStandType;
    long position = [_vPlayer getCurrentPosition];
    dict[@"currentProgress"] = @(position);
    WVRUnityActionMessageModel *model = [[WVRUnityActionMessageModel alloc] init];
    
    model.message = @"StartScene";
    model.arguments = @[ @"startSoccerVR", @"MatchInfo", [[dict toJsonString] stringByReplacingOccurrencesOfString:@"\\" withString:@""], ];
    
    [[WVRMediator sharedInstance] WVRMediator_sendMsgToUnity:model];
}

#pragma mark - start play

- (void)actionPlay:(BOOL)isRepeat {
    
    [self actionPlay:isRepeat needSeek:NO];
}

- (void)actionPlay:(BOOL)isRepeat needSeek:(BOOL)needSeek {
    
    if (!_videoEntity.haveValidUrlModel) {
        SQToastInKeyWindow(@"播放链接解析为空！");
        return;
    }
    
    [self createPlayerHelperIfNot];
    
    long position = 0;
    
    if (!isRepeat) {
        
//        self.vPlayer.dataParam.isMonocular = YES;
        self.vPlayer.dataParam.isLooping = NO;
        
        if (_videoEntity.streamType == STREAM_2D_TV) {
            
            self.vPlayer.dataParam.url = [(WVRVideoEntityMoreTV *)_videoEntity bestDefinitionUrl];
            self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForStreamType:_videoEntity.streamType definition:_videoEntity.curDefinition renderTypeStr:_videoEntity.renderTypeStr];
        } else {
            
            if (self.curDefinition) {
                self.vPlayer.dataParam.url = [self.videoEntity playUrlForDefinition:self.curDefinition];
                self.curDefinition = nil;
            } else {
                
                self.vPlayer.dataParam.url = [self.videoEntity playUrlForStartPlay];
            }
            
            if (self.detailBaseModel.isFootball) {
                
                self.vPlayer.dataParam.renderType = [self.videoEntity renderTypeForFootballCurrentCameraStand];
            } else {
                
                self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:self.videoEntity.curDefinition renderTypeStr:self.videoEntity.curUrlModel.renderType];
            }
        }
        if (needSeek) {
            position = [_vPlayer getCurrentPosition];
        } else if (_curPosition > 0) {
            
            position = _curPosition;
            _curPosition = 0;
        }
    } else {
        [self.vPlayer performSelector:@selector(setDramaStartPlay:) withObject:@(NO)];
    }
    
    [self.playerUI execUpdateDefiBtnTitle];
    
    self.vPlayer.dataParam.position = position;
    self.vPlayer.ve = _videoEntity;
    
    [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
}

- (void)actionRetry {
    
    // 重新解析URL
    [self buildInitData];
}

/// 有需求的子类可以重写
- (void)actionRestart {
    
    [self actionPlay:YES];
}

- (void)actionSetControlsVisible:(BOOL)isControlsVisible {
    
    if (!_isLandspace) { self.bar.hidden = !isControlsVisible; }
}

#pragma mark - 旋转屏幕

- (void)rotaionAnimations:(BOOL)isLandspace {
    
    _isLandspace = isLandspace;
    
    self.bar.hidden = isLandspace;
    
    float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    float height = roundf(width / 18.f * 11);
    if (_videoEntity.streamType == STREAM_VR_VOD) {
        height = width;
    }
    
    self.playerContentView.frame = isLandspace ? self.navigationController.view.bounds : CGRectMake(0, 0, width, height);
}

#pragma mark - status bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return [WVRAppContext sharedInstance].gStatusBarHidden;     // _isLandspace
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}

#pragma mark - 子类实现

- (void)uploadViewCount {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)uploadPlayCount {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)reParserPlayUrl {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)playNextVideo {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - history

- (void)recordHistory {
    if (self.videoEntity.streamType == STREAM_VR_LOCAL || self.videoEntity.streamType == STREAM_VR_LIVE) {
        return;
    }
    if (!self.vPlayer.isOnPrepared) {
        return;
    }
    WVRHistoryModel * historyModel = [WVRHistoryModel new];
    historyModel.programCode = self.videoEntity.sid;
    if ([self isKindOfClass:[WVRTVDetailBaseController class]]) {
        historyModel.programType = PROGRAMTYPE_MORETV;
    } else if ([self isKindOfClass:[WVRDramaDetailVC class]]) {
        historyModel.programType = PROGRAMTYPE_DRAMA;
    }
    else {
        historyModel.programType = PROGRAMTYPE_PROGRAM;
    }
    historyModel.playTime = [NSString stringWithFormat:@"%ld", [self playerStatus] == 2 ? [_vPlayer getDuration] : [_vPlayer getCurrentPosition]];
    historyModel.totalPlayTime = [NSString stringWithFormat:@"%ld", [_vPlayer getDuration]];
    historyModel.playStatus = [NSString stringWithFormat:@"%ld", [self playerStatus]];
    [WVRPlayerTool recordPlayHistory:historyModel];
}

#pragma mark - rotation

- (BOOL)shouldAutorotate {
    
    return [WVRAppContext sharedInstance].gShouldAutorotate;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return [WVRAppContext sharedInstance].gSupportedInterfaceO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [WVRAppContext sharedInstance].gPreferredInterfaceO;    // 登录返回或新浪网页分享返回时闪退的问题
}

- (void)detailNetworkFaild {
    
    [self hideProgress];
    @weakify(self);
    if ([WVRReachabilityModel isNetWorkOK]) {
        @weakify(self);
        [self showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self requestData];
        }];
        [self.view bringSubviewToFront:self.bar];
    } else {
        [self showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self requestData];
        }];
    }
    [self.view bringSubviewToFront:bar];
}

#pragma mark - BI

/// 对应BI埋点的pageId字段，直播预告页面已重写该方法
- (NSString *)currentPageId {
    
    return @"videoDetails";
}

/// 电视猫电影电视剧已经重写此字段
- (NSString *)videoFormat {
    
    return self.detailBaseModel.videoType;
}

/// 电视猫电影电视剧已经重写此字段
- (NSString *)biPageName {
    
    return self.detailBaseModel.title;
}

/// 电视猫电影电视剧已经重写此字段
- (NSString *)biPageId {
    
    return self.detailBaseModel.sid;
}

- (NSString *)biContentType {
    
    return self.detailBaseModel.type;
}

- (int)biIsChargeable {
    
    return self.detailBaseModel.isChargeable;
}

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.currentPageId = [self currentPageId];
    model.biPageId = [self biPageId];
    model.biPageName = [self biPageName];
    model.videoFormat = [self videoFormat];
    model.contentType = [self biContentType];
    model.isChargeable = [self biIsChargeable];
    model.isProgram = YES;
    
    return model;
}

- (void)trackEventForBrowseDetailPage {
    
    [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
}

- (void)trackEventForShare {
    
    [WVRProgramBIModel trackEventForShare:[self biModel]];
}

- (NSDictionary *)videoInfo {
    
    return nil;
}

- (void)backForResult:(id)info resultCode:(NSInteger)resultCode
{
    if (resultCode == 10) {
        [self.playerUI changeViewFrameForFull];
    }
}

@end



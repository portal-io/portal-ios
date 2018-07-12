//
//  WVRPlayerVC.m
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/18.
//  Copyright © 2016年 Snailvr. All rights reserved.
//
// 全屏播放控制器基类，请勿直接使用
// 目前支持全屏播放的类型有：点播VR全景视频、直播全景视频、本地缓存全景视频

#import "WVRPlayerVC.h"
#import "WVRNavigationController.h"

#import "WVRHistoryModel.h"
#import "WVRPlayerTool.h"

#import "WVRVideoEntityLocal.h"
#import "WVRWatchOnlineRecord.h"
#import "WVRDeviceModel.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "WVRChartletManager.h"

#import "WVRMediator+UnityActions.h"
#import "WVRMediator+PayActions.h"
#import "WVRMediator+AccountActions.h"

#import "WVRPlayerFullSUIManager.h"
#import "WVRSpring2018Manager.h"

@interface WVRPlayerVC () {
    
    long _isLowFps;
    id _rac_handler;
}

@property (nonatomic, weak  ) NSTimer  *timer;

@property (assign, atomic) BOOL parseURLComplete;         // 解析链接完成
@property (atomic, assign) BOOL requestChargedComplete;   // 请求是否付费完成

@property (nonatomic, strong) WVRWatchOnlineRecord * gwOnlineRecord;

//@property (nonatomic, assign) BOOL gStartForDiddisapper;

@property (nonatomic, strong) WVRChartletManager *chartletManager;

@end


@implementation WVRPlayerVC
@synthesize playerUI = _tmpPlayerUI;         // 请使用get方法调用

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self startTimer];
    [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    
    [[WVRMediator sharedInstance] WVRMediator_ReportLostInAppPurchaseOrders];
    
    [self configureSelf];
    [self buildData];
    [self buildInitData];
    
    [self createLayoutView];
    
    [self setupRACObserve];
}

- (void)installAfterViewLoadForbanner
{
    [self startTimer];
    [[WVRMediator sharedInstance] WVRMediator_ReportLostInAppPurchaseOrders];
    [self buildData];
    [self createLayoutView];
    [self setupRACObserve];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WVRSpring2018Manager checkForSpring2018Status];
    [WVRSpring2018Manager checkForSpringLeftCount];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self buildInitData];     // 此处不应该调用此方法
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerObserverEvent];
    
    [(WVRNavigationController *)self.navigationController setGestureInValid:YES];
//    [WVRAppModel sharedInstance].preVcisOrientationPortraitl = YES;
    
    if (![WVRAppModel sharedInstance].shouldContinuePlay) { return; }
    [WVRAppModel sharedInstance].shouldContinuePlay = NO;
    
    [self.playerUI execResumeForControllerChanged];
    
    self.view.window.backgroundColor = [UIColor blackColor];
    
    if (self.playerUI.dealWithUnityBack == WVRPlayerUnityBackDealRotation) {
        
        if (self.playerUI.tmpPlayerViewStatus == WVRPlayerUIViewStatusHalfVertical && self.videoEntity.streamType == STREAM_VR_LIVE) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.playerUI changeViewFrameForSmall];
            });
        }
    } else if (self.playerUI.dealWithUnityBack == WVRPlayerUnityBackDealExit) {
        self.playerUI.dealWithUnityBack = WVRPlayerUnityBackDealNothing;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionOnExit];
        });
        return;
    }
    self.playerUI.dealWithUnityBack = WVRPlayerUnityBackDealNothing;
    
    [self performSelector:@selector(checkPlayerStatusWhenBackFromOtherPage) withObject:nil afterDelay:0.3];
}

-(void)setPlayerStatusForDisappear
{
    if (!self.navigationController && !self.presentingViewController) {
        
        [self destroyResourceForDealloc];
        
    } else if (self.vPlayer.isValid) {
        
        [self.playerUI execSleepForControllerChanged];
        self.vPlayer.dataParam.position = [self.vPlayer getCurrentPosition];
        
        [self.vPlayer destroyPlayer];
        [self.playerUI execSuspend];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.view.window.backgroundColor = [UIColor whiteColor];
//    [(WVRNavigationController *)self.navigationController setGestureInValid:NO];
    
    [self stopTimer];
    
    [self recordHistory];
    [self watch_online_record:NO];
//    self.gStartForDiddisapper = YES;
    
    [self setPlayerStatusForDisappear];
    
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    // fixbug: 9803 手机未安转微博客户端，竖屏播放直播时，通过微博分享，返回直播时画面黑屏
    UIViewController *currentVC = [UIViewController getCurrentVC];
    if ([currentVC isKindOfClass:NSClassFromString(@"WBSDKComposerWebViewController")]) {
        [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    
    } else if ([NSStringFromClass([currentVC class]) containsString:@"Login"]) {
        
        self.notDealFromLogin = YES;
    } else {
        
        BOOL goUnity = [currentVC isKindOfClass:NSClassFromString(@"UnityViewControllerBase")];
        if (!goUnity) {
            self.playerUI.isGoUnity = NO;
            [self playerUI].isGoUnityFootball = NO;
        }
    }
}

- (void)dealloc {
    
    DDLogInfo(@"WVRPlayerVC - dealloc");
    
    [self destroyResourceForDealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)destroyResourceForDealloc {
    
    DDLogInfo(@"destroyResource");
    
    [self stopTimer];
    [_vPlayer onBackForDestroy];
    
    [self.playerUI execDestroy];
}

#pragma mark - event

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
            
            // 如果执行到这里就已经有值，就不用RAC监听，防止出bug（第一次无法销毁）
            if ([[self playerUI] unityBackParams]) {
                
                [self dealwithUnityBackParams];
            } else {
                
                @weakify(self);
                __block RACDisposable *handler = [RACObserve(self.playerUI, unityBackParams) subscribeNext:^(id x) {
                    
                    if (nil != x) {
                        
                        @strongify(self);
                        
                        [self dealwithUnityBackParams];
                        [handler dispose];
                    }
                }];
                _rac_handler = handler;
            }
            
        } else {
            
            [self startTimer];
            [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
        }
    }
}

- (void)dealwithUnityBackParams {
    
    NSString *definition = self.playerUI.unityBackParams[@"currentQuality"];
    long position = [self.playerUI.unityBackParams[@"currentPosition"] integerValue];
    
    if (self.videoEntity.streamType == STREAM_VR_LIVE) {
        if (self.playerUI.unityBackParams[@"playTime"]) {
            
            long leftTime = [self.playerUI.unityBackParams[@"playTime"] integerValue];
            long playTime = self.detailBaseModel.freeTime - leftTime;
            if (playTime > 0) {
                
                [[WVRAppModel sharedInstance].liveTrailDict setValue:@(playTime) forKey:self.detailBaseModel.code];
                [[WVRAppModel sharedInstance] saveLiveTrailDict];
            }
        }
    }
    
    if (self.videoEntity.streamType == STREAM_VR_LOCAL || [self.videoEntity.curDefinition isEqualToString:definition]) {
        
        [self startTimer];
        [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
    } else {
        self.curPosition = position;
        self.curDefinition = definition;
        
        [self startTimer];
        [self readyToPlay];
    }
}

- (void)watch_online_record:(BOOL)isComin {
    
    NSString * contentType = @"live";
    switch (self.videoEntity.streamType) {
        case STREAM_3D_WASU:
        case STREAM_VR_VOD:
        case STREAM_2D_TV:
            
            contentType = @"recorded";
            break;
            
        case STREAM_VR_LIVE:
            contentType = @"live";
            break;
            
        case STREAM_VR_LOCAL:
            return;
            break;
        default:
            return;
            break;
    }
    WVRWatchOnlineRecordModel * recordModel = [WVRWatchOnlineRecordModel new];
    recordModel.code = self.videoEntity.sid;
    recordModel.contentType = contentType;
    recordModel.type = [NSString stringWithFormat:@"%d",isComin];
    recordModel.deviceNo = [WVRUserModel sharedInstance].deviceId;
    if (isComin) {
        [self.gwOnlineRecord http_watch_online_record:recordModel];
    } else {
        [self.gwOnlineRecord http_watch_online_unrecord:recordModel];
    }
}

#pragma mark - dismiss

- (void)dismissViewController {
    @weakify(self);
    [[self playerUI] forceToOrientationPortrait:^{
        @strongify(self);
        [self stopTimer];
        [_vPlayer onBackForDestroy];
        
        if ([self presentingViewController]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - ready to play

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
    
    if ([self checkReadyToPlay]) {
        
        if (_detailBaseModel.isChargeable && self.isCharged) {
            
            [[WVRMediator sharedInstance] WVRMediator_PayReportDevice:nil];
        }
        [self actionPlay:NO];
        
    } else if ([self requestDataOver] && ![self videoCanTrail]) {
        // 该视频付费，且无法试看
        [self.playerUI execFreeTimeOverToCharge:0];
    }
}

/// 检测支付/支付流程结束 调用
- (void)dealWithPaymentOver {
    if (self.isCharged) {
        [self.playerUI execPaymentSuccess];
    }
    if (self.vPlayer.isValid) {
        
        if (self.isCharged || self.vPlayer.getCurrentPosition/1000.f < _detailBaseModel.freeTime) {
            
            [self controlOnResume];
            
//            if (self.isCharged) {
//                [self.playerUI execPaymentSuccess];
//            }
        }
        
    } else if (self.vPlayer.isOnDestroy || self.vPlayer.isReleased) {
        
        WVRDataParam *dataM = self.vPlayer.dataParam;
        dataM.position = [self.vPlayer getCurrentPosition];
        [self.vPlayer setParamAndPlay:dataM];
        
//        if (self.isCharged) {
//            [self.playerUI execPaymentSuccess];
//        }
        [self.playerUI execWaitingPlay];
        
    } else {
        [self readyToPlay];
    }
}

//#pragma mark - getter

//- (WVRVideoEntity *)videoEntity {
//
//    return _tmpVideoEntity;
//}

- (WVRChartletManager *)chartletManager {
    if (!_chartletManager) {
        _chartletManager = [[WVRChartletManager alloc] init];
    }
    return _chartletManager;
}

- (WVRPlayerUIManager *)playerUI {
    
    if (!_tmpPlayerUI) {
        _tmpPlayerUI = [[WVRPlayerFullSUIManager alloc] init];
        _tmpPlayerUI.uiDelegate = self;
        
        _tmpPlayerUI.videoEntity = [self videoEntity];
        _tmpPlayerUI.detailBaseModel = [self detailBaseModel];
        _tmpPlayerUI.vPlayer = self.vPlayer;
        _tmpPlayerUI.uiDelegate = self;
        [_tmpPlayerUI installAfterSetParams];
    }
    return _tmpPlayerUI;
}

#pragma mark - init Data

- (void)buildInitData {
    
//    [self.playerUI resetVRMode];
    
    if (!self.gwOnlineRecord) {
        self.gwOnlineRecord = [WVRWatchOnlineRecord new];
    }
    if (!self.vPlayer) {
        
        self.vPlayer = [[WVRPlayerHelper alloc] initWithContainerView:self.view MainController:self];
        self.vPlayer.playerDelegate = self;
        self.vPlayer.biModel.screenType = 1;
    }
    
    if (self.videoEntity.streamType == STREAM_VR_LOCAL) {
        
        _requestChargedComplete = YES;
        self.isCharged = YES;
//        _videoEntity.renderTypeStr = model.renderType;
        
        [self dealWithPlayUrl:self.videoEntity.sid];
        
    } else {
        
        [self requestForDetailData];
    }
}

// 付费流程检测
- (void)checkForCharge {
    
    self.isCharged = NO;
    
    BOOL chargeable = self.detailBaseModel.isChargeable;
    BOOL notFree = YES;     // (self.detailBaseModel > 0)
    
    if (chargeable && notFree) {
        
        [self requestForPaied:NO];
    } else {
        _requestChargedComplete = YES;
        self.isCharged = YES;
    }
}

- (void)requestForPaied:(BOOL)onlyDealWithPaid {
    
    PurchaseProgramType type = PurchaseProgramTypeVR;
    if (self.videoEntity.streamType == STREAM_VR_LIVE) {
        type = PurchaseProgramTypeLive;
    }
    _requestChargedComplete = NO;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            if (!onlyDealWithPaid || [input boolValue]) {
                
                [self dealWithCheckVideoPaied:[input boolValue]];
            }
            if (onlyDealWithPaid && [input boolValue]) {
                
                [[self playerUI] execPaymentSuccess];
            }
            
            return nil;
        }];
    }];
    
    param[@"goodNo"] = self.detailBaseModel.code;
    if (self.videoEntity.streamType == STREAM_VR_LIVE) {
        param[@"goodType"] = @"live";
    } else {
        param[@"goodType"] = @"recorded";
    }
    param[@"cmd"] = cmd;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckVideoIsPaied:param];
}

- (void)dealWithCheckVideoPaied:(BOOL)isCharged {
    
    if (self.vPlayer.isOnBack) { return; }
    
    _requestChargedComplete = YES;
    
    self.isCharged = isCharged;
    [self readyToPlay];
}

// 子类重写
- (void)requestForDetailData {
    
}

/// 目前只有直播在调用
- (void)parserBaseData:(WVRItemModel *)model {
    
    if (self.videoEntity.streamType != STREAM_VR_LOCAL) {
        
        long speed = [[WVRAppModel sharedInstance] checkInNetworkflow];
        [self.playerUI execDownloadSpeedUpdate:speed];
    }
    self.videoEntity.biEntity.playCount = (long)model.playCount.longLongValue;
    self.videoEntity.needParserURL = model.playUrl;
    self.videoEntity.needParserURLDefinition = [model definitionForPlayURL];
    self.videoEntity.relatedCode = model.relatedCode;
    self.videoEntity.biEntity.videoTag = model.tags;
    self.videoEntity.isChargeable = model.isChargeable;
    self.videoEntity.freeTime = model.freeTime;
    self.videoEntity.price = model.price;
    self.videoEntity.behavior = model.behavior;
    self.videoEntity.bgPic = model.bgPic;
    self.videoEntity.biEntity.contentType = model.type;
    self.videoEntity.biEntity.totalTime = ((WVRVideoDetailVCModel *)model).duration.intValue;
    
    self.isFootball = [model isFootball];
    self.videoEntity.isFootball = self.isFootball;
    
    self.detailBaseModel = model;
    
    [self checkForCharge];
    [self dealWithPlayUrl:self.videoEntity.sid];
}

- (void)dealWithDetailData:(WVRItemModel *)model {
    
    if (self.videoEntity.streamType != STREAM_VR_LOCAL) {
        
        long speed = [[WVRAppModel sharedInstance] checkInNetworkflow];
        [self.playerUI execDownloadSpeedUpdate:speed];
    }
    
    self.videoEntity.biEntity.playCount = (long)model.playCount.longLongValue;
    self.videoEntity.needParserURL = model.playUrl;
    self.videoEntity.needParserURLDefinition = [model definitionForPlayURL];
    self.videoEntity.relatedCode = model.relatedCode;
    self.videoEntity.biEntity.videoTag = model.tags;
    self.videoEntity.isChargeable = model.isChargeable;
    self.videoEntity.freeTime = model.freeTime;
    self.videoEntity.price = model.price;
    self.videoEntity.behavior = model.behavior;
    self.videoEntity.bgPic = model.bgPic;
    self.videoEntity.biEntity.contentType = model.type;
    self.videoEntity.biEntity.totalTime = ((WVRVideoDetailVCModel *)model).duration.intValue;
    self.videoEntity.detailModel = model.detailModel;
    
    self.isFootball = [model isFootball];
    self.videoEntity.isFootball = self.isFootball;
    if (self.isFootball) {
        self.videoEntity.mediaDtos = model.mediaDtos;
    } else {
        self.videoEntity.mediaDtos = nil;
    }
    
    self.detailBaseModel = model;
    
    [self checkForCharge];
    [self dealWithPlayUrl:self.videoEntity.sid];
    
    [[self playerUI] updateAfterSetParams];
}

- (void)dealWithPlayUrl:(NSString *)sid {
    
    _parseURLComplete = NO;
    
    @weakify(self);
    [self.videoEntity parserPlayUrl:^{
        @strongify(self);
        //banner滑动时要判断是不是当前显示的banner的解析成功返回
        if (![self.videoEntity.sid isEqualToString:sid]) {
            return;
        }
        if (self.isDestroy) {
            return;
        }
        if (self.vPlayer.isOnBack) { return; }
        
        if (self.videoEntity.haveValidUrlModel) {
            
            DDLogInfo(@"parserPlayUrl 解析成功");
            self.parseURLComplete = YES;
            
        } else {
            self.parseURLComplete = NO;
            
            BOOL netOK = [WVRReachabilityModel isNetWorkOK];
            NSString *err = netOK ? kNoNetAlert : kLinkError;
            [self dealWithError:err code:(netOK ? WVRPlayerErrorCodePlay : WVRPlayerErrorCodeNet)];
            [self dealForParserErrorWithError:err code:(netOK ? WVRPlayerErrorCodePlay : WVRPlayerErrorCodeNet)];
        }
        [self readyToPlay];
    }];
}

- (void)dealForParserErrorWithError:(NSString *)err code:(int)code {
    
}

- (void)dealWithError:(NSString *)err code:(int)code {
    
    [self.playerUI execError:err code:code];
    [self.vPlayer playError:err code:code videoEntity:self.videoEntity];
}

#pragma mark - init layoutView

- (void)configureSelf {
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.window.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)buildData {
    
    _isLowFps = 5;
    _syncScrubberNum = 1;    // 轮询计数
    
    [self playerUI];
    
    [self setupRequestRAC];
}

- (void)setupRequestRAC {
    
    @throw [NSException exceptionWithName:@"error" reason:@"You Must OverWrite This Function In SubClass" userInfo:nil];
}

- (void)createLayoutView {
    
    [self.playerUI createPlayerViewWithContainerView:self.view];
}

- (void)createPlayerBottomImage {       // 底图
    
    [self createPlayerFootballBackgroundImageWithVIP:[self.videoEntity isCameraStandVIP]];
    
    [self.chartletManager createPlayerBottomImageWithVideoEntity:[self videoEntity] player:self.vPlayer detailModel:self.detailBaseModel];
}

- (void)createPlayerFootballBackgroundImageWithVIP:(BOOL)isVIP {       // 180背景图
    
    [self.chartletManager createPlayerFootballBackgroundImageWithVIP:isVIP ve:[self videoEntity] player:self.vPlayer detailModel:self.detailBaseModel];
}

#pragma mark - goto Launcher

// onGLKDealloc 的时候调用
- (void)showUnityView {
    
    if ([self.detailBaseModel isFootball]) {
        [self showFootballUnity];
    } else {
        [self showCommonLiveUnity];
    }
}

- (void)showFootballUnity {
    
    self.playerUI.isGoUnityFootball = YES;
    
    [[WVRMediator sharedInstance] WVRMediator_showU3DView:NO];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[@"behaviour"] = self.videoEntity.behavior;
    dict[@"matchId"] = @([[[self.videoEntity.behavior componentsSeparatedByString:@"="] lastObject] intValue]);
    dict[@"defaultSlot"] = self.videoEntity.currentStandType;
    long position = [_vPlayer getCurrentPosition];
    dict[@"currentProgress"] = @(position);
    WVRUnityActionMessageModel *model = [[WVRUnityActionMessageModel alloc] init];
    model.message = @"StartScene";
    model.arguments = @[ @"startSoccerVR", @"MatchInfo", [[dict toJsonString] stringByReplacingOccurrencesOfString:@"\\" withString:@""], ];
    
    [[WVRMediator sharedInstance] WVRMediator_sendMsgToUnity:model];
}

- (void)showCommonLiveUnity {
    
    self.playerUI.isGoUnity = YES;
    
    [[WVRMediator sharedInstance] WVRMediator_showU3DView:NO];
    
    NSString *tag = nil;
    if ([self.detailBaseModel isKindOfClass:[WVRVideoDetailVCModel class]]) {
        WVRVideoDetailVCModel *model = (WVRVideoDetailVCModel *)self.detailBaseModel;
        tag = model.tags;
    }
    
    double progress = [_vPlayer getCurrentPosition] / (double)[_vPlayer getDuration];
    
    NSString *renderTypeStr = nil;
    if (self.videoEntity.streamType == STREAM_VR_LOCAL) {
        
        switch (_vPlayer.getRenderType) {
            case MODE_OCTAHEDRON:
                renderTypeStr = RENDER_TYPE_360_2D_OCTAHEDRAL;
                break;
            case MODE_SPHERE:
                renderTypeStr = RENDER_TYPE_360_2D;
                break;
            case MODE_RECTANGLE_STEREO:
                renderTypeStr = RENDER_TYPE_PLANE_3D_LR;
                break;
            case MODE_RECTANGLE_STEREO_TD:
                renderTypeStr = RENDER_TYPE_PLANE_3D_UD;
                break;
            case MODE_SPHERE_STEREO_LR:
                renderTypeStr = RENDER_TYPE_360_3D_LF;
                break;
            case MODE_SPHERE_STEREO_TD:
                renderTypeStr = RENDER_TYPE_360_3D_UD;
                break;
            case MODE_HALF_SPHERE:
                renderTypeStr = RENDER_TYPE_180_PLANE;
                break;
            case MODE_HALF_SPHERE_TD:
                renderTypeStr = RENDER_TYPE_180_3D_UD;
                break;
            case MODE_HALF_SPHERE_LR:
                renderTypeStr = RENDER_TYPE_180_3D_LF;
                break;
            case MODE_OCTAHEDRON_STEREO_LR:
                renderTypeStr = RENDER_TYPE_360_OCT_3D;
                break;
            case MODE_OCTAHEDRON_HALF_LR:
                renderTypeStr = RENDER_TYPE_180_3D_OCT;
                break;
                
            default:
                renderTypeStr = self.videoEntity.renderTypeStr ?: RENDER_TYPE_360_2D;
                break;
        }
    }
    WVRUnityActionPlayModel *model = [[WVRUnityActionPlayModel alloc] init];
    
    NSMutableArray *pathArr = [NSMutableArray array];
    if (self.videoEntity.streamType == STREAM_VR_LOCAL) {
        
        if (_vPlayer.getRenderType == MODE_OCTAHEDRON) {
            
            model.quality = kDefinition_SD;
        } else if (_vPlayer.getRenderType == MODE_OCTAHEDRON_STEREO_LR) {
            
            model.quality = kDefinition_SDA;
        } else {
            model.quality = self.videoEntity.curDefinition ?: kDefinition_ST;
        }
        model.renderType = self.vPlayer.getRenderType;
        
        WVRUnityActionPlayPathModel *pathModel = [[WVRUnityActionPlayPathModel alloc] init];
        
        pathModel.url = [[self.videoEntity.parserdUrlModelDict.allValues firstObject].allValues firstObject].url.absoluteString;
        pathModel.renderType = renderTypeStr;
        pathModel.bittype = model.quality;
        
        [pathArr addObject:pathModel];
        
    } else {
        
        BOOL needFilter = (![WVRDeviceModel is4KSupport] && _videoEntity.currentLinkDict.count >= 2);
        
        for (WVRPlayUrlModel *tmpModel in [self.videoEntity.currentLinkDict allValues]) {
            WVRUnityActionPlayPathModel *pathModel = [[WVRUnityActionPlayPathModel alloc] init];
            
            pathModel.url = tmpModel.url.absoluteString;
            pathModel.renderType = tmpModel.renderType;
            pathModel.bittype = tmpModel.definition;
            
            // bug 11584, 不支持4k将链接直接过滤(链接数大于等于2),如果只有一个链接,就在播放时不跳转Unity
            if (needFilter && [tmpModel.definition isEqualToString:kDefinition_HD]) {
                continue;
            }
            
            [pathArr addObject:pathModel];
        }
        
        if (needFilter && [self.videoEntity.curDefinition isEqualToString:kDefinition_HD]) {
            WVRUnityActionPlayPathModel *pathModel = [pathArr firstObject];
            
            model.quality = pathModel.bittype;
            model.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:model.quality renderTypeStr:pathModel.renderType];
        } else {
            
            model.quality = self.videoEntity.curDefinition;
            model.renderType = self.vPlayer.getRenderType;
        }
    }
    
    [[WVRMediator sharedInstance] WVRMediator_setPlayerHelper:self.vPlayer];
    [[WVRMediator sharedInstance] WVRMediator_setUIManager:self.playerUI];
    
    model.sid = self.videoEntity.sid;
    model.title = self.videoEntity.videoTitle;
    model.pathArray = pathArr;
    model.streamType = self.videoEntity.streamType;
    model.detailType = self.videoEntity.detailModel.detailType;
    model.progress = progress;
    model.duration = [_vPlayer getDuration];
    model.tags = tag;
    model.playCount = self.videoEntity.biEntity.playCount;
    model.videoFormat = self.detailBaseModel.videoType;
    model.contentType = self.detailBaseModel.type;
    model.isChargeable = self.detailBaseModel.isChargeable;
    
    model.isFromBanner = [NSStringFromClass([self class]) containsString:@"PlayerBanner"];
    
    if (!self.isCharged) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"freeTime"] = @(self.detailBaseModel.freeTime);
        dict[@"playTime"] = [[WVRAppModel sharedInstance].liveTrailDict objectForKey:self.detailBaseModel.code];
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

#pragma mark - WVRPlayerHelperDelegate

- (void)restartUI {
    
    [self.playerUI execPlaying];
}

- (void)pauseUI {
    
    [self stopTimer];
    [self.playerUI execSuspend];
}

- (BOOL)respondNetStatusChange {
    
    if (self.videoEntity.streamType == STREAM_VR_LOCAL) {
        
        return NO;
    }
    
    return [self isCurrentViewControllerVisible];
}

- (void)onVideoPrepared {
    
    [self startTimer];
    
    [self createPlayerBottomImage];
    
    [self.playerUI execPreparedWithDuration:[_vPlayer getDuration]];
//    if ([[self playerUI] isKindOfClass:[WVRPlayerFullSUIManager class]]) {
//
//        [(WVRPlayerFullSUIManager *)[self playerUI] updatePlayStatus:WVRPlayerToolVStatusPlaying];
//    }
    
    [self watch_online_record:YES];
    
//    if (self.isCharged) {
//        [self.playerUI execPaymentSuccess];
//    }
}

- (void)onCompletion {
    
    [self recordHistory];
    [self stopTimer];
    [self watch_online_record:NO];
    if (self.videoEntity.streamType != STREAM_VR_LOCAL) {
        BOOL netOK = [WVRReachabilityModel isNetWorkOK];
        if (!netOK) {
            [self.playerUI execSuspend];
            return;
        }
    }
    
    [self.playerUI execCompletion];
}

- (void)onError:(int)what {
    self.curPosition = [self.vPlayer getCurrentPosition];
    NSString *err = [NSString stringWithFormat:@"%d", what];
    
    [self stopTimer];
    
    BOOL netOK = [WVRReachabilityModel isNetWorkOK];
    
    if (!netOK) {
        
        [self dealWithError:err code:WVRPlayerErrorCodeNet];
        
    } else if (self.videoEntity.canTryNextPlayUrl) {
        
        [self.videoEntity nextPlayUrlVE];
        [self buildInitData];
        [self.playerUI execWaitingPlay];
    } else {
        [self dealWithError:err code:WVRPlayerErrorCodeLink];
    }
    // 子类已重写该方法
//    else if (self.videoEntity.streamType == STREAM_VR_LIVE) {
//    }
}

// 播放卡顿
- (void)onBuffering {
    
    [self.playerUI execStalled];
}

- (void)onBufferingOff {
    
    [self startTimer];
    [self.playerUI execPlaying];
}

- (void)reParserUrlForNetChanged:(long)position {
    _curPosition = position;
    
    [self dealWithPlayUrl:self.videoEntity.sid];
    [[self playerUI] execStalled];
}

- (void)onGLKVCdealloc {
    
    [self showUnityView];
}

#pragma mark - timer

- (void)startTimer {
    
    if ([_timer isValid]) { return; }
    if (!self.view.window) { return; }
    
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
    
    // 保护
    if (![self isCurrentViewControllerVisible]) { return; }
    if (nil == [self.vPlayer curPlaySid]) { return; }           // 播放器尚未初始化
    
    long speed = [[WVRAppModel sharedInstance] checkInNetworkflow];
    
    if (![_vPlayer isPlaying]) {
        
        if (self.videoEntity.streamType != STREAM_VR_LOCAL) {
            
            [self.playerUI execDownloadSpeedUpdate:speed];
        } else {
            [self.playerUI execDownloadSpeedUpdate:-1];
        }
    } else {
        
        [self checkFreeTime];
        
        if (self.syncScrubberNum % 10 == 0 && self.isCharged && _detailBaseModel.isChargeable) {
            
            [self checkDeviceForVipVideo];
        }
    }
    
//    [self.playerUI execUpdateCountdown];
    
    _syncScrubberNum ++;
}

- (void)checkDeviceForVipVideo {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [self dealWithDeviceCheckFailed];
            
            return nil;
        }];
    }];
    param[@"cmd"] = cmd;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckDevice:param];
}

- (void)dealWithDeviceCheckFailed {
    
    [self controlOnPause];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            [self dismissViewController];
            return nil;
        }];
    }];
    NSDictionary *param = @{ @"cmd":cmd };
    [[WVRMediator sharedInstance] WVRMediator_ForceLogout:param];
}

- (void)checkFreeTime {
    // 子类有需求实现
}

#pragma mark - WVRPlayerUIManagerDelegate

// live中已重写，目前除了直播，其他视频还没有在全屏播放器页支付的需求（20170711）
- (void)actionGotoBuy {
    
    [self.view.window endEditing:YES];
    
    [self controlOnPause];
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSInteger payResult = [input[@"success"] integerValue];
            @strongify(self);
//            if (payResult==1 || payResult==3) {
////                [self toOrientation];
//            }
            BOOL success = (payResult==1);
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
        
        [self dealWithPaymentOver];
        
    } else {
        
        [self controlOnResume];
    }
}

- (void)actionOnExit {
    
    [self dismissViewController];
}

- (void)actionResume {
    
    [self startTimer];
}

- (void)actionPause {
    
    [self stopTimer];
}

// 是否为播放结束后再次播放
- (void)actionPlay:(BOOL)isRepeat {
    
    if (!self.videoEntity.haveValidUrlModel) {
        SQToastInKeyWindow(@"播放链接解析为空！");
        return;
    }
    
    long position = 0;
    if (!isRepeat) {
        
        if (self.curDefinition) {
            self.vPlayer.dataParam.url = [self.videoEntity playUrlForDefinition:self.curDefinition];
            self.curDefinition = nil;
        } else {
            
            self.vPlayer.dataParam.url = [self.videoEntity playUrlForStartPlay];
        }
        
        if (self.isFootball) {
            
            self.vPlayer.dataParam.renderType = [self.videoEntity renderTypeForFootballCurrentCameraStand];
        } else {
            
            self.vPlayer.dataParam.renderType = [WVRVideoEntity renderTypeForStreamType:self.videoEntity.streamType definition:self.videoEntity.curDefinition renderTypeStr:self.videoEntity.curUrlModel.renderType];
        }
        
//        self.vPlayer.dataParam.isMonocular = !self.videoEntity.isDefaultVRMode;
        
        [self.playerUI execUpdateDefiBtnTitle];
        
        if (self.isCharged && !self.playerUI.isGoUnity) {
            [self.playerUI execWaitingPlay];
        }
        
        if (self.videoEntity.streamType == STREAM_VR_LOCAL) {
            
//            self.vPlayer.dataParam.framOritation = ((WVRVideoEntityLocal *)self.videoEntity).oritaion;
            self.vPlayer.dataParam.renderType = ((WVRVideoEntityLocal *)self.videoEntity).renderType;
            
        } else {
            
            if (_curPosition > 0) {
                
                position = _curPosition;
                _curPosition = 0;
            }
        }
    } else {
        [self.vPlayer performSelector:@selector(setDramaStartPlay:) withObject:@(NO)];
    }
    
    self.vPlayer.dataParam.position = position;
    self.vPlayer.ve = self.videoEntity;
    [self startTimer];
    [self.vPlayer setParamAndPlay:self.vPlayer.dataParam];
}

- (void)actionRetry {
    
    DDLogInfo(@"");
    [self buildInitData];   // 重新解析URL
}

/// 有需求的子类可以重写
- (void)actionRestart {
    
    [self actionPlay:YES];
}

/// 专题连播 播放下一个
- (void)actionPlayNext {
    
    [self.videoEntity nextVideoEntity];
    [self buildInitData];
    [self.playerUI execWaitingPlay];
}

- (void)actionSetControlsVisible:(BOOL)isControlsVisible {
    
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

#pragma mark - Notification

- (void)setupRACObserve {
    
    kWeakSelf(self);
    [[RACObserve(self, videoEntity) skip:0] subscribeNext:^(id  _Nullable x) {
        
        [weakself playerUI].videoEntity = weakself.videoEntity;
    }];
    [[RACObserve(self, detailBaseModel) skip:0] subscribeNext:^(id  _Nullable x) {
        
        [weakself playerUI].detailBaseModel = weakself.detailBaseModel;
    }];
    [[RACObserve(self, vPlayer) skip:0] subscribeNext:^(id  _Nullable x) {
        
        [weakself playerUI].vPlayer = weakself.vPlayer;
    }];
    [[RACObserve(self, isCharged) skip:0] subscribeNext:^(id  _Nullable x) {
        
        weakself.videoEntity.isCharged = weakself.isCharged;
    }];
}

- (void)registerObserverEvent {      // 界面"暂停／激活"事件注册
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)networkStatusChanged:(NSNotification *)notification {
    
    // 保护
    if (![self isCurrentViewControllerVisible]) { return; }
    
//    [self.playerUI execNetworkStatusChanged];
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    
    // 保护
    if (!self.vPlayer.isValid) { return; }
    
    if (self.videoEntity.streamType != STREAM_VR_LIVE && [self isCurrentViewControllerVisible]) {
        
        // 防止屏幕横竖屏状态出现异常
//        [WVRAppModel forceToOrientation:UIInterfaceOrientationLandscapeRight];
    }
    
    if (self.videoEntity.streamType == STREAM_VR_LIVE && [self.vPlayer isPaused]) {
        
        // BUG #8594 直播节目播放时，分享到第三方app，回到app，直播会停住
        if ([self isClearInWindow]) {
            
            [self controlOnResume];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.vPlayer isPlaying]) {
            [self.playerUI execPlaying];
            [self startTimer];
        }
    });
}

- (void)dealWithBuySuccessNoti:(NSNotification *)noti {
    
    if (self.isCharged) { return; }
    NSString *coupon = noti.userInfo[@"goodsCode"];
    
    if ([coupon isEqualToString:self.detailBaseModel.couponDto.code] || [coupon isEqualToString:self.detailBaseModel.contentPackageQueryDto.couponDto.code]) {
        
        self.isCharged = YES;
        [self.playerUI execPaymentSuccess];
    }
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

#pragma mark - record history

- (HistoryPlayStatus)playerStatus {
    
    NSInteger status = HistoryPlayStatusUnknow;
    if (self.vPlayer.isComplete) {
        status = HistoryPlayStatusComplate;
    } else if (self.vPlayer.isPlaying) {
        status = HistoryPlayStatusPlaying;
    }
    return status;
}

// 已经将直播类和本地视频播放recordHistory重写为空方法
- (void)recordHistory {
    
//    if (!self.vPlayer.isPrepared) {
//        return;
//    }
    WVRHistoryModel * historyModel = [WVRHistoryModel new];
    historyModel.programCode = self.videoEntity.sid;
    if (self.videoEntity.streamType == STREAM_2D_TV) {
        historyModel.programType = PROGRAMTYPE_MORETV;
    } else {
        historyModel.programType = PROGRAMTYPE_PROGRAM;
    }
    historyModel.playTime = [NSString stringWithFormat:@"%ld", [self playerStatus] == HistoryPlayStatusComplate ? [self.vPlayer getDuration] : [self.vPlayer getCurrentPosition]];
    historyModel.totalPlayTime = [NSString stringWithFormat:@"%ld", [self.vPlayer getDuration]];
    historyModel.playStatus = [NSString stringWithFormat:@"%ld", [self playerStatus]];
    
    [WVRPlayerTool recordPlayHistory:historyModel];
}

#pragma mark - status bar

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationSlide;
}

#pragma mark - orientation setting

- (BOOL)shouldAutorotate {
    
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeRight;
}

@end

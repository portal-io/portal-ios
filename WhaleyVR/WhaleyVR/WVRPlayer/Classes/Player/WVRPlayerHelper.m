//
//  WVRPlayerHelper.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/19.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRPlayerHelper.h"
#import "WLYPlayerUtils.h"
#import "WVRPlayerBackgroundModel.h"
#import "WVRAppContextHeader.h"
#import "UIAlertController+Extend.h"
#import "UIViewController+HUD.h"
#import "UIView+Extend.h"

#import "WVRPlayerHelper+BI.h"
#import "WVRPlayer+BI.h"

#import "UnityAppController.h"

@interface WVRPlayerHelper ()<VRPlayerDelegate> {
    
    long _currentPosition;
    long _totalTime;
    BOOL _playingBeforeAppResignActive;
    NSTimeInterval _appEnterBackgroundTime;
    NSTimeInterval _appEnterForegroundTime;
}

@property (nonatomic, weak) GLKViewController *gController;
@property (nonatomic, weak) GLKView *gView;           // vrPlayer的glkView

@property (nonatomic, assign) BOOL gNeedSetParamAndPlay;

@property (nonatomic, weak) UIAlertController * gAlertController;

@property (nonatomic, assign) BOOL gIsComplete;
@property (nonatomic, assign) BOOL gIsError;
@property (nonatomic, assign) BOOL gIsCellularNetWaitSurePlay;

@property (nonatomic, strong, readonly) WVRPlayerBackgroundModel *imageModel;
@property (nonatomic, assign) BOOL gHaveAllow4gPlay;

@property (nonatomic, assign) NSNumber *dramaStartPlay;

@end


@implementation WVRPlayerHelper
@synthesize imageModel = _tmpImageModel;    // 调用时使用打点调用

#pragma mark 生命周期函数

- (instancetype)init NS_UNAVAILABLE {
    
    return nil;
}

// viewDidLoad调用
- (instancetype)initWithContainerView:(UIView *)containerView MainController:(UIViewController *)viewController {
    
    self = [super init];
    if (self) {
        
        _containerView = containerView;
        _containerController = viewController;
        
        _dataParam = [[WVRDataParam alloc] init];
        _dataParam.useHardDecoder = YES;
        _dataParam.isMonocular = YES;
        _biModel = [[WVRPlayerBIModel alloc] init];
        
        [self registNotification];
        
        [WVRPlayer enableLogger:(kAppEnvironmentTest == 1)];
    }
    return self;
}

- (void)createPlayerIfNot {
    
    _isReleased = NO;
    _isOnDestroy = NO;
    if (nil == self.vrPlayer) {
        DDLogInfo(@"WVRPlayerHelper createPlayerIfNot %@", self.ve.videoTitle);
        _vrPlayer = [[WVRPlayerManager sharedInstance] vrPlayer]; // [[WVRPlayer alloc] initPlayerInstance];
    }
    self.vrPlayer.playerDelegate = self;
}

- (void)createGLKControllerIfNot {
    
    DDLogInfo(@"WVRPlayerHelper createGLKControllerIfNot %@", self.ve.videoTitle);
    
    // 此工作vrplayer会做
//    if ([WVRPlayerManager sharedInstance].glView) {
//        [[WVRPlayerManager sharedInstance].glView removeFromSuperview];
//        [[[WVRPlayerManager sharedInstance] glController] removeFromParentViewController];
//    }
    
//    if (!_gController) {
    
        GLKViewController *gController = [_vrPlayer createPlayerViewController];
        
        [self.vrPlayer setPlayerViewController:gController inViewController:self.containerController];
        
        [_containerView setAutoresizesSubviews:YES];
        
        gController.view.frame = _containerView.bounds;
        [gController.view setBackgroundColor:[UIColor blackColor]];
        [_containerView insertSubview:gController.view atIndex:0];
        
        _gController = gController;
        _gView = (GLKView *)gController.view;
        
        [[WVRPlayerManager sharedInstance] setGlView:_gView];
        [[WVRPlayerManager sharedInstance] setGlController:_gController];
//    }
    
    DDLogInfo(@"WVRPlayerHelper createGLKControllerIfNot End %@", self.ve.videoTitle);
}

- (void)resetGLKView {
    
    [_gView removeFromSuperview];
    
    _gController.view.frame = _containerView.bounds;
    [_containerView insertSubview:_gController.view atIndex:0];
}

#pragma mark - notifination

- (void)registNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged:)
                                                 name:kNetStatusChagedNoti
                                               object:nil];
}

- (void)networkStatusChanged:(NSNotification *)notification {
    
    if (![self.containerController isCurrentViewControllerVisible]) {       // 保护
        return;
    }
    
    if ([self.playerDelegate respondsToSelector:@selector(respondNetStatusChange)]) {
        if (![self.playerDelegate respondNetStatusChange]) {
            return;
        }
    }
    if ([self playerIsDestroyed]) {
        return;
    }
    if (![self isOnPrepared]) {
        return;
    }
    if (![self.containerController isCurrentViewControllerVisible]) {
        return;
    }
    DebugLog(@"networkStatusChanged");
    if (self.ve.streamType == STREAM_VR_LOCAL) {
        return;
    }
    if ([WVRReachabilityModel isNetWorkOK]) {
        [self netWorkOk];
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    
    if (![self.containerController isCurrentViewControllerVisible]) {       // 保护
        return;
    }
    
    if (_playingBeforeAppResignActive) {
        _playingBeforeAppResignActive = NO;
        
        [self.vrPlayer start];
        [self trackEventForContinue];
    }
    if (![self.vrPlayer isPaused] && self.vrPlayer) {
        
        self.gIsComplete = NO;
    }
    DebugLog(@"paramerestart appDidBecomeActive");
    
    //    if (self.gIngnoreNetStatus) { return; }
    if ([self.playerDelegate respondsToSelector:@selector(respondNetStatusChange)]) {
        if ([self.playerDelegate respondNetStatusChange]) {
            return;
        }
    }
    
    if ([self playerIsDestroyed]) { return; }
    
    DebugLog(@"networkStatusChanged");
    
    if (self.ve.streamType == STREAM_VR_LOCAL) { return; }
    
    if ([WVRReachabilityModel isNetWorkOK] && !_isPauseStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self checkNeedSetparamAndStart];
        });
    }
}

- (void)appDidEnterBackground:(NSNotification *)noti {
    
    if (![self.containerController isCurrentViewControllerVisible]) {       // 保护
        return;
    }
    
    if ([_vrPlayer isPrepared] && !_isReleased && !_isOnDestroy) {
        
        _appEnterBackgroundTime = [[NSDate date] timeIntervalSince1970];

        [self trackEventForEndPlay];
    }
}

- (void)appWillEnterForeground:(NSNotification *)noti {
    
    if (![self.containerController isCurrentViewControllerVisible]) {       // 保护
        return;
    }
    
    if ([_vrPlayer isPrepared] && !_isReleased && !_isOnDestroy) {
        
        _appEnterForegroundTime = [[NSDate date] timeIntervalSince1970];
        
        [self recordStartTime];
    }
}

#pragma mark - deal with net changed

- (void)netWorkOk {
    
    [self.gAlertController dismissViewControllerAnimated:NO completion:nil];
    
    if ([WVRReachabilityModel sharedInstance].isReachNet) {
        [self updateForReachNet];
    } else {
        [self updateForWifi];
    }
}

- (BOOL)isAllow4gPlay {
    
    return ![WVRUserModel sharedInstance].isOnlyWifi || self.gHaveAllow4gPlay;
}

- (BOOL)checkNetStatus {
    
    if ([self isAllow4gPlay]) {
        
    } else {
        [self checkNetStatusForStartPlay:self.dataParam];
    }
    return [self isAllow4gPlay];
}

- (void)updateForReachNet {
    
    /// 用户打开了4G下缓存视频，则不处理
    if ([self isAllow4gPlay]) {
        [self dealWithNetChanged];
        return;
    }
    
    self.gIsCellularNetWaitSurePlay = YES;
    if (!self.vrPlayer.isPaused) {
        [self pause];
    }
    
    [self.gAlertController dismissViewControllerAnimated:NO completion:nil];
    
    kWeakSelf(self);
    self.gAlertController = [UIAlertController alertTitle:kAlertTitle mesasge:kReachAlert preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        
        weakself.gIsCellularNetWaitSurePlay = NO;
        weakself.gHaveAllow4gPlay = YES;
        [weakself dealWithNetChanged];
        
    } confirmTitle:@"继续播放" cancleHandler:^(UIAlertAction *action) {
        
        weakself.gIsCellularNetWaitSurePlay = NO;
        [weakself pause];
        
    } cancleTitle:@"取消" viewController:[UIViewController getCurrentVC]];
}

- (void)updateForWifi {
    
    [self dealWithNetChanged];
}

- (void)dealWithNetChanged {
    
    // 走本地代理的链接需要重新解析，否则就不用处理
    if ([[self.dataParam.url absoluteString] hasPrefix:@"http://127.0.0.1:12581/?Action=agent"]) {
        
        [self.playerDelegate reParserUrlForNetChanged:[self.vrPlayer getCurrentPosition]];
        
    } else {
        
        [self setParamAndRestart];
    }
}

- (void)appWillResignActive:(NSNotification *)notification {
    if (!_isPauseStatus) {
        _playingBeforeAppResignActive = YES;
        
        [self.vrPlayer pause];
        [self trackEventForPause];
    }
}

- (void)checkNeedSetparamAndStart {
    
    if (self.gNeedSetParamAndPlay) {
        
        [self setParamAndRestart];
        DebugLog(@"paramerestart gNeedSetParamAndPlay:");
        
    } else if (self.vrPlayer.isPrepared) {
        if (self.gIsCellularNetWaitSurePlay) {
            if (!self.vrPlayer.isPaused) {
                [self pause];
            }
            return;
        }
        if (!self.vrPlayer.isPlaying) {
            [self setParamAndRestart];
        }
    }
}

- (void)setParamAndRestart {
    
    DDLogInfo(@"WVRPlayerHelper setParamAndRestart %@", self.ve.videoTitle);
    
    self.gNeedSetParamAndPlay = NO;
    long curPostion = _currentPosition;
    if (self.ve.streamType == STREAM_VR_LIVE) {
        curPostion = 0;
    }
    
    DebugLog(@"paramerestart curPostion:%ld", curPostion);
    
    self.dataParam.position = curPostion;
    [self allowPlayAfterCheckNetStatus:self.dataParam];
    
    if ([self.playerDelegate respondsToSelector:@selector(restartUI)]) {
        [self.playerDelegate restartUI];
    }
}

#pragma mark - life Cycle

// applicationWillResignActive调用, 返回YES表示pause时需更改UI为暂停状态
- (BOOL)onPause {
    
    [self.vrPlayer pause];
    [self trackEventForPause];
    
    return !_vrPlayer.isPlaying;
}

// applicationDidBecomeActive调用, 返回YES表示resume时需更改UI为播放状态
- (BOOL)onResume {
    
    [self resetGLKView];
    
    if (_vrPlayer.isPlaying) { return YES; }
    // 后台回来前台的时候如果是停止状态，不自动播放
    if (_isPauseStatus) { return NO; }
    
    [self.vrPlayer start];
    [self trackEventForContinue];
    
    return _vrPlayer.isPlaying;
}

// 按键退出时调用
- (void)onBackForDestroy {
    
    if ([self playerIsDestroyed]) { return; }      // 不能多次调用onDestroy
    
    DDLogInfo(@"unity-app-player ios-onBackForDestroy: %@", self.ve.videoTitle);
    
    _isOnBack = YES;
    
    [(UnityAppController *)[[UIApplication sharedApplication] delegate] invalidNotLockTimer];
    
    self.vrPlayer.playerDelegate = nil;
    
    [self destroyVRPlayerForRelease];
}

// 界面销毁、跳转Unity时调用

- (void)destroyForUnity {
    
    if ([self playerIsDestroyed]) { return; }      // 不能多次调用onDestroy
    
    DDLogInfo(@"destroyForUnity - %@", self.containerController);
    
    _isOnDestroy = YES;
    
    [self destroyVRPlayerForRelease];
}

// 释放播放器资源
- (void)destroyPlayer {
    
    if ([self playerIsDestroyed]) { return; }      // 不能多次调用onDestroy
    
    DDLogInfo(@"destroyPlayer - %@", self.containerController);
    
    _isReleased = YES;
    
    [(UnityAppController *)[[UIApplication sharedApplication] delegate] invalidNotLockTimer];
    
    [self destroyVRPlayerForRelease];
}

- (void)destroyVRPlayerForRelease {
    
//    DDLogInfo(@"destroyVRPlayerForRelease - %@", self.containerController);
    
    [self trackEventForEndPlay];
    
    _currentPosition = [_vrPlayer getCurrentPosition];
    _totalTime = [_vrPlayer getDuration];
    
    [self.gView removeFromSuperview];
    [self.vrPlayer releasePlayer];
    
    if (_isReleased || _isOnDestroy) { _curPlaySid = nil; }
    if (_isOnBack) { _dataParam = nil; }
    
    [self updateScreenLockStatus:NO];
}

- (void)dealloc {
    
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
        DDLogError(@"%@", exception.reason);
    }
    DDLogInfo(@"playerHelper dealloc %@", self.ve.videoTitle);
}

#pragma mark - external func

+ (void)resetLinkParserTokenForUrl:(NSString *)url {
    
    // 20170804新增, 不走本地代理的链接无需设置token
    if (![url hasPrefix:[WLYPlayerUtils proxy_url_prefix]]) {
        return;
    }
    
    NSString *tmpUrlStr = [url stringByRemovingPercentEncoding];
    
    NSString *finalToken = nil;
    
    finalToken = [[tmpUrlStr componentsSeparatedByString:@"?"] lastObject];
    
    if (finalToken) {
        [WLYPlayerUtils setToken:finalToken];
    } else {
        [WLYPlayerUtils setToken:@""];
    }
    NSLog(@"\nfinalToken = %@\n", finalToken);
}

#pragma mark - 业务逻辑相关

- (void)playError:(NSString *)err code:(int)code videoEntity:(WVRVideoParamEntity *)ve {
    
    _ve = ve;
    _errorCode = code;
    
    if (self.isPlayError) {
        [self trackEventForEndPlay];
    }
}

#pragma mark - 息屏事件控制

- (void)updateScreenLockStatus:(BOOL)isPlaying {
    
    NSDictionary *dict = @{ @"isPlaying" : @(isPlaying) };
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateScreenLockStatusNoti object:self userInfo:dict];
}

#pragma mark - 网络状态检测

- (void)tipFor4gPlay {
    
    [self stop];
    [self.playerDelegate pauseUI];
    
    [self.gAlertController dismissViewControllerAnimated:NO completion:nil];
    
    kWeakSelf(self);
    self.gAlertController = [UIAlertController alertTitle:kAlertTitle mesasge:kReachAlert preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        weakself.gIsCellularNetWaitSurePlay = NO;
        weakself.gHaveAllow4gPlay = YES;
        [weakself allowPlayAfterCheckNetStatus:self.dataParam];
        
    } confirmTitle:@"继续播放" cancleHandler:^(UIAlertAction *action) {
        
        weakself.gIsCellularNetWaitSurePlay = NO;
        
    } cancleTitle:@"取消" viewController:[UIViewController getCurrentVC]];
}

- (void)checkNetStatusForStartPlay:(WVRDataParam *)dataParam {
    if ([WVRReachabilityModel isNetWorkOK]) {
        if ([WVRReachabilityModel sharedInstance].isWifi) {
            return;
        }
        [self tipFor4gPlay];
    } else {
        if ([self.playerDelegate respondsToSelector:@selector(pauseUI)]) {
            [self.playerDelegate pauseUI];
        }
        
        [self.gAlertController dismissViewControllerAnimated:NO completion:nil];
        self.gAlertController = [UIAlertController alertMesasge:kNoNetAlert confirmHandler:^(UIAlertAction *action) {
            
        } viewController:[UIViewController getCurrentVC]];
        
        return;
    }
}

- (void)allowPlayAfterCheckNetStatus:(WVRDataParam *)dataParam {
    
    if (_isOnBack) {
        DDLogError(@"播放器已经彻底销毁 无法执行 setParamAndPlay");
        return;
    }
    if (dataParam.url.absoluteString.length < 1) {
        DDLogError(@"nil == dataParam.url");
        [self.playerDelegate onError:WVRPlayerErrorCodeLink];
        return;
    }
    if (self.ve.streamType == STREAM_VR_LIVE) {
        dataParam.position = 0;
    }
    
    self.isFreeTimeOver = NO;
    
    [WVRPlayerHelper resetLinkParserTokenForUrl:dataParam.url.absoluteString];
    
    _isOnPrepared = NO;
    _isOnBuffering = YES;
    self.gIsComplete = NO;
    self.gIsError = NO;
    self.curPlaySid = _ve.sid;
    
    [self createPlayerIfNot];
    
    _isPauseStatus = NO;
    
    // 防止上次播放失败的视频没有记录到BI
    if (_errorCode != 0) {
        [self trackEventForEndPlay];
    }
    
    _biModel.startLoadTime = round([[NSDate date] timeIntervalSince1970] * 1000);
    
    _dataParam = dataParam;
    
    // 这两行代码createGLKControllerIfNot可以避免闪退，它在下面可以避免release下分屏黑屏的问题
    [self createGLKControllerIfNot];
    [self.vrPlayer setParamAndPlay:dataParam];
    
    DDLogInfo(@"WVRPlayerHelper self.vrPlayer setParamAndPlay: %@", self.ve.videoTitle);
    DDLogInfo(@"_________ %@", [self.dataParam yy_modelToJSONString]);
    
    [self updateScreenLockStatus:YES];
}

//只给onError和onComplete使用
- (void)alertTipNetWorkStatus {
//    if (self.gIngnoreNetStatus) {
//        return;
//    }
//    if ([self.playerDelegate respondsToSelector:@selector(respondNetStatusChange)]) {
//        if (![self.playerDelegate respondNetStatusChange]) {
//            return;
//        }
//    }
    if (self.ve.streamType == STREAM_VR_LOCAL) {
        return;
    }
    if ([WVRReachabilityModel isNetWorkOK]) {
        
    } else {
        if ([self.playerDelegate respondsToSelector:@selector(pauseUI)]) {
            [self.playerDelegate pauseUI];
        }
        
        [self.gAlertController dismissViewControllerAnimated:NO completion:nil];
        self.gAlertController = [UIAlertController alertMesasge:kNoNetAlert confirmHandler:^(UIAlertAction *action) {
            
        } viewController:[UIViewController getCurrentVC]];
    }
}

#pragma mark 播放基础事件

- (void)setParamAndPlay:(WVRDataParam *)dataParam {
    
    DDLogInfo(@"WVRPlayerHelper setParamAndPlay: %@", self.ve.videoTitle);
    
    self.gHaveAllow4gPlay = NO;
    
    if ([self isComplete]) {
        dataParam.position = 0;
    }
    
//    if (![WVRUserModel sharedInstance].isOnlyWifi) {
        [self allowPlayAfterCheckNetStatus:dataParam];
//    } else {
//        [self checkNetStatusForStartPlay:dataParam];
//    }
}

- (void)switchDecoder:(BOOL)isHardDecode {
    
    if (!self.vrPlayer.isPrepared) { return; }
    
    [self.vrPlayer switchDecoder:isHardDecode];
}

- (void)start {
    if ([WVRReachabilityModel sharedInstance].isWifi || [self checkNetStatus]) {
        _isPauseStatus = NO;
        if (self.vrPlayer.isPrepared) {
            [self.vrPlayer start];
            [self trackEventForContinue];
        
            [self updateScreenLockStatus:YES];
        } else {
            
            DDLogInfo(@"WVRPlayerHelper setParamAndRestart %@", self.ve.videoTitle);
            
            [self allowPlayAfterCheckNetStatus:self.dataParam];
        }
    } else {
        
    }
}

- (void)resetIsPauseStatusForBanner {
    _isPauseStatus = NO;
}

- (void)stop {
    
    [self trackEventForPause];
    
    _isPauseStatus = YES;
    [self.vrPlayer pause];
    [self updateScreenLockStatus:NO];
}

- (void)pause {
    
    [self stop];
    if ([self.playerDelegate respondsToSelector:@selector(pauseUI)]) {
        [self.playerDelegate pauseUI];
    }
}

- (BOOL)isPlaying {
    
    return [self.vrPlayer isPlaying];
}

- (BOOL)isPrepared {
    
    return [self.vrPlayer isPrepared];
}

- (void)seekTo:(long)time {
    
    if (!self.vrPlayer.isPrepared) { return; }
    if (self.ve.streamType == STREAM_VR_LIVE) { return; }
    
    _isOnBuffering = YES;
    if ([WVRReachabilityModel isNetWorkOK]) {
        self.gIsComplete = NO;
        self.gIsError = NO;
    }
    [self.vrPlayer seekTo:time];
    
    [self trackEventForStartbuffer];
    
    if ([self.playerDelegate respondsToSelector:@selector(userSeekTo:)]) {
        [self.playerDelegate userSeekTo:time];
    }
}

#pragma mark - setter

- (void)setCurPlaySid:(NSString *)curPlaySid {
    
    _lastSid = _curPlaySid;
    _curPlaySid = curPlaySid;
}

#pragma mark - getter

- (long)getCurrentPosition {
    
    if ([self playerIsDestroyed]) {
        DebugLog(@"paramerestart playerIsDestroyed");
        return _currentPosition;
    }
    if ([self gIsError]) {
        DebugLog(@"paramerestart isPlayError");
        return _currentPosition;
    }
    if ([self gIsComplete]) {
        DebugLog(@"paramerestart isComplete");
        return _currentPosition;
    }
    _currentPosition = [self.vrPlayer getCurrentPosition];
    
    return _currentPosition;
}

- (long)getPlayableDuration {
    
    return [self.vrPlayer getPlayableDuration];
}

- (long)getDuration {
    
    long totalTime = [_vrPlayer getDuration];
    
    if (totalTime <= 0) {
        totalTime = _totalTime;
    }
    if (totalTime <= 0) {
        totalTime = _ve.biEntity.totalTime * 1000;       // conver second to millisecond
    }
    
    return totalTime;
}

- (BOOL)isComplete {
    
    return [self.vrPlayer isComplete];
}

- (BOOL)isPlayError {
    
    return [self.vrPlayer isPlayError];
}

- (BOOL)isPaused {
    
    return [self.vrPlayer isPaused];
}

- (float)getFps {
    
    return [self.vrPlayer getFps];
}

// private
- (BOOL)playerIsDestroyed {
    
    return _isReleased || _isOnDestroy || _isOnBack;
}

- (WVRRenderType)getRenderType {
    
    if ([self playerIsDestroyed]) {
        return _dataParam.renderType;
    }
    return [self.vrPlayer getRenderType];
}

- (BOOL)getMonocular {
    if ([self playerIsDestroyed]) {
        return _dataParam.isMonocular;
    }
    return [self.vrPlayer getMonocular];
}

- (UIDeviceOrientation)getDeviceOritation {
    
    return [self.vrPlayer getDeviceOrientation];
}

- (BOOL)isValid {
    
    if ([self playerIsDestroyed]) { return NO; }
    
    return (self.vrPlayer != nil);
}

- (WVRPlayerBackgroundModel *)imageModel {
    if (!_tmpImageModel) {
        _tmpImageModel = [[WVRPlayerBackgroundModel alloc] init];
    }
    return _tmpImageModel;
}

#pragma mark 渲染状态事件

// onVideoPrepared之后执行
- (void)genBottomView:(float)scale Image:(UIImage *)image {
    
    self.imageModel.bottomImage = image;
    self.imageModel.bottomImageScale = scale;
    
    if (self.imageModel.bottomImageHidden || !image) {
        
        [self.vrPlayer setBottomOverlayView:self.imageModel.clearImage Scale:1];
        
    } else {
        
        [self.vrPlayer setBottomOverlayView:image Scale:scale];
    }
}

- (void)setBottomViewHidden:(BOOL)isHidden {
    self.imageModel.bottomImageHidden = isHidden;
    
    if (isHidden) {
        [self.vrPlayer setBottomOverlayView:self.imageModel.clearImage Scale:1];
    } else {
        if (![self.imageModel.bottomSid isEqualToString:self.ve.sid]) {    // 播放视频已变，缓存图片置空
            self.imageModel.bottomImage = self.imageModel.clearImage;
        }
        [self.vrPlayer setBottomOverlayView:self.imageModel.bottomImage Scale:self.imageModel.bottomImageScale];
    }
}

// onVideoPrepared之后执行
- (void)setBackImage:(UIImage *)image {
    
    if (!image) { return; }
    
    [self.vrPlayer setBackImageView:image];
}

- (void)setRenderType:(WVRRenderType)renderType {
    
    [self.vrPlayer setRenderType:renderType];
}

- (void)setMonocular:(BOOL)isMonocular {
    
    _dataParam.isMonocular = isMonocular;
    [self.vrPlayer setMonocular:isMonocular];
    
    if (!isMonocular) {
        [self.vrPlayer orientationReset];   // 分屏时重新设置中心点
    }
}

- (void)orientationReset {
    
    [self.vrPlayer orientationReset];
}

- (void)viewTouchesStarted {
    
    [self.vrPlayer viewTouchesStarted];
}

- (void)viewTouchesMoved:(float)x Y:(float)y {
    
    [self.vrPlayer viewTouchesMoved:x Y:y];
}

#pragma mark - VRPlayerDelegate

- (void)onVideoPrepared {
    
    [(UnityAppController *)[[UIApplication sharedApplication] delegate] setUpNotLockTimer];
    
    DDLogInfo(@"unity-app-player ios-onVideoPrepared: %@", self.ve.videoTitle);
    
    _currentPosition = [self.vrPlayer getCurrentPosition];
    
    [self resetGLKView];
    
    // 更换视频或者重新播放记录startPlay事件
    if (![_lastSid isEqualToString:_curPlaySid]) {
        
        [self trackEventForStartPlay];
        
    } else if ((_dataParam.position == 0 && self.ve.streamType != STREAM_VR_LIVE)) {
        if (self.ve.detailModel.detailType == WVRDetailTypeDrama) {
            
            if (self.dramaStartPlay.boolValue == NO) {
                [self trackEventForStartPlay];
            }
        } else {
            [self trackEventForStartPlay];
        }
    } else {
        [self trackEventForContinue];   //  防止网络状态切换时直接调重新起播
        [self trackEventForEndbuffer];
    }
    
    self.dramaStartPlay = @(YES);
    _isOnPrepared = YES;
    _ve.biEntity.isPlayError = NO;
    _isOnBuffering = NO;
    self.gIsComplete = NO;
    
    [self.playerDelegate onVideoPrepared];
    
    if ([self.playerDelegate respondsToSelector:@selector(respondNetStatusChange)]) {
        if ([self.playerDelegate respondNetStatusChange]) {
            [self checkNetStatus];
        }
    }
}

- (void)onCompletion {
    
    // 在此修改防止因网络代理问题导致播放器误报onCompletion
    long position = [self getCurrentPosition];
    long duration = [self getDuration];
    
    if (self.ve.streamType != STREAM_VR_LIVE && duration - position > 10000) {   // 5s
        if ([WVRReachabilityModel isNetWorkOK]) {
            
            self.dataParam.position = position;
            [self setParamAndPlay:self.dataParam];
        } else {
            
            [self alertTipNetWorkStatus];
        }
        return;
    }
    self.gIsComplete = YES;
    _isOnBuffering = NO;
    
    if (self.ve.detailModel.isDrama) {
        if (self.ve.biEntity.curIsLastNode) {
            
            [self trackEventForEndPlay];
        }
    } else {
        
        [self trackEventForEndPlay];
    }
    
    [self.playerDelegate onCompletion];
    
    _isPauseStatus = YES;
    
    if (!self.ve.detailModel.isDrama || self.ve.biEntity.curIsLastNode) {
        
        _curPlaySid = nil;
    }
    
    [self updateScreenLockStatus:NO];
    [self alertTipNetWorkStatus];
}

- (void)onError:(int)what {
    self.gIsError = YES;
    _isOnBuffering = NO;
    if (_lastSid) { _ve.biEntity.isPlayError = YES; }
    _curPlaySid = nil;
    
    DDLogInfo(@"%@, player - onError: %d", [self.containerController class], what);
    [self alertTipNetWorkStatus];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    BOOL enterBackgroundJustNow = (now - _appEnterForegroundTime) < 100;
    BOOL backgroundTimeTooLong = (_appEnterForegroundTime - _appEnterBackgroundTime) > 300;
    BOOL urlIsProxy = [[self.dataParam.url absoluteString] hasPrefix:@"http://127.0.0.1:12581/?Action=agent"];
    BOOL haveNet = [WVRReachabilityModel isNetWorkOK];
    BOOL isActive = [self.containerController isCurrentViewControllerVisible];
    
    if (urlIsProxy && haveNet && isActive && enterBackgroundJustNow && backgroundTimeTooLong) {
        
        /// 进后台时间太长，需要重新解析链接
        if ([self.playerDelegate respondsToSelector:@selector(setCurPosition:)]) {
            [self.playerDelegate setCurPosition:[self getCurrentPosition]];
        }
        [self.playerDelegate reParserUrlForNetChanged:[self.vrPlayer getCurrentPosition]];
        
    } else {
        
        [self.playerDelegate onError:what];
    }
}

- (void)onBuffering {
    
    _isOnBuffering = YES;
    
    [self trackEventForStartbuffer];
    
    [self.playerDelegate onBuffering];
    
    if ([WVRReachabilityModel sharedInstance].isNoNet) {
        
        [self.gAlertController dismissViewControllerAnimated:NO completion:nil];
        self.gAlertController = [UIAlertController alertMessage:kNoNetAlert viewController:kRootViewController];
    }
}

- (void)onBufferingOff {
    
    _isOnBuffering = NO;
    
    [self trackEventForEndbuffer];
    
    [self.playerDelegate onBufferingOff];
}

- (void)onGLKVCdealloc {
    
    DDLogInfo(@"unity-app-player ios-onGLKVCdealloc: %@", self.ve.videoTitle);
    
    // 只是释放播放器资源，无需回调销毁代理
    if (!_isReleased && !_isOnBack) {
        
        [self.playerDelegate onGLKVCdealloc];
    }
    _vrPlayer = nil;
}

@end


@implementation WVRPlayerManager
@synthesize vrPlayer = _vrPlayer;

+ (instancetype)sharedInstance {
    
    static WVRPlayerManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        _sharedClient = [[WVRPlayerManager alloc] init];
    });
    return _sharedClient;
}

- (WVRPlayer *)vrPlayer {
    if (!_vrPlayer) {
        _vrPlayer = [[WVRPlayer alloc] initPlayerInstance];
        DDLogInfo(@"WVRPlayerManager initPlayerInstance");
    }
    return _vrPlayer;
}

- (void)setGlView:(GLKView *)glView {
    
    _glView = glView;
}

- (void)setGlController:(GLKViewController *)glController {
    
    _glController = glController;
}

- (BOOL)isFullScreenPlaying {
    
    float max_gl = MAX(_glView.width, _glView.height);
    float max_sc = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    return (max_gl >= max_sc);
}

- (UIImage *)screenShotForGLKView {
    
    if (self.isFullScreenPlaying) {
        return _glView.snapshot;
    }
    return nil;
}

@end

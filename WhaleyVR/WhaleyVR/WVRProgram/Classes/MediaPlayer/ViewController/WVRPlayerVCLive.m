//
//  WVRPlayerVCLive.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerVCLive.h"

#import "WVRUMShareView.h"
#import "WVRLotteryModel.h"

#import "WVRMediator+SettingActions.h"

#import "WVRNavigationController.h"
#import "WVRRecommendItemModel.h"
#import "WVRRewardController.h"

#import "WVRWebSocketMsg.h"

#import "WVRProgramBIModel.h"

#import "WVRLivePlayerCompleteStrategy.h"
#import "WVRLivePlayerStrategyConfig.h"

#import "WVRMediator+AccountActions.h"
#import "WVRMediator+PayActions.h"
#import "WVRLiveDetailViewModel.h"
#import "WVRRNLiveCompleteVC.h"

@interface WVRPlayerVCLive () {
    
    BOOL _notRecordBI;
    BOOL _isNotFirstIn;
}

@property (nonatomic, assign) BOOL lotterySwitch;
@property (nonatomic, assign) BOOL danmuSwitch;

//@property (nonatomic, strong) NSNumber *lotteryTime;         // 秒

@property (nonatomic, strong) WVRLivePlayerCompleteStrategy * gCompleteStrategy;

@property (nonatomic, strong) WVRLiveDetailViewModel * gLiveDetailViewModel;

- (WVRVideoEntityLive *)videoEntity;

@end


@implementation WVRPlayerVCLive
@synthesize playerUI = _tmpPlayerUI;

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRACObserver];
    }
    return self;
}

- (WVRVideoEntityLive *)videoEntity {
    
    return (WVRVideoEntityLive *)[super videoEntity];
}

- (void)setupRequestRAC {
    
    @weakify(self);
    [[self.gLiveDetailViewModel gSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self liveDetailSuccessBlock:x];
    }];
    [[self.gLiveDetailViewModel gFailSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self liveDetailFailBlock];
    }];
}

- (void)setupRACObserver {
    @weakify(self);
    [[RACObserve(self, lotterySwitch) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self videoEntity].lotterySwitch = self.lotterySwitch;
        [[self playerUI] execLotterySwitch:self.lotterySwitch];
    }];
    [[RACObserve(self, danmuSwitch) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self videoEntity].danmuSwitch = self.danmuSwitch;
        [[self playerUI] execDanmuSwitch:self.danmuSwitch];
    }];
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([WVRUserModel sharedInstance].isLogined) {
            [self dealWithUserLogin];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isNotFirstIn) {        // 第一次进来不执行旋转（默认就是竖屏），防止tabbar闪一下
        
        return;
    }
//    [self toOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isNotFirstIn && !self.isCharged && !self.notDealFromLogin) {
        
        [self requestForPaied:YES];
    }
    self.notDealFromLogin = NO;
    
    if (_isNotFirstIn) {
        if ([self isMemberOfClass:[WVRPlayerVCLive class]]) {
            
            [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
        }
    }
    
    _isNotFirstIn = YES;
}

- (void)setPlayerStatusForDisappear
{
    if (self.vPlayer.isValid) {
        
        [[self playerUI] execSleepForControllerChanged];
        self.vPlayer.dataParam.position = [self.vPlayer getCurrentPosition];
        
        [self.vPlayer destroyPlayer];
        [[self playerUI] execSuspend];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {       // pop
        
        [self invalidNavPanGuesture:NO];
        
    } else {            // push or present
        
        BOOL isNotPortrait = ([self videoEntity].displayMode != WVRLiveDisplayModeVertical);
        
        [self invalidNavPanGuesture:isNotPortrait];
    }
    
    if ([self isMemberOfClass:[WVRPlayerVCLive class]]) {
        
        [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
    }
}

#pragma mark - rotation

- (void)toOrientation {
    
    switch ([self videoEntity].displayMode) {
        case WVRLiveDisplayModeVertical:
            if ([WVRAppContext sharedInstance].gSupportedInterfaceO != UIInterfaceOrientationMaskPortrait) {
                [[self playerUI] forceToOrientationPortrait];
            }
            
            break;
        case WVRLiveDisplayModeHorizontal:
            if ([WVRAppContext sharedInstance].gSupportedInterfaceO != UIInterfaceOrientationMaskLandscapeRight) {
                [[self playerUI] forceToOrientationMaskLandscapeRight];
            }
            break;
    }
}

#pragma mark - getter

- (WVRPlayerLiveUIManager *)playerUI {
    
    if (!_tmpPlayerUI) {
        _tmpPlayerUI = [[WVRPlayerLiveUIManager alloc] init];
        _tmpPlayerUI.videoEntity = [self videoEntity];
        _tmpPlayerUI.detailBaseModel = [self detailBaseModel];
        _tmpPlayerUI.vPlayer = self.vPlayer;
        _tmpPlayerUI.uiDelegate = self;
        ((WVRPlayerLiveUIManager *)_tmpPlayerUI).uiLiveDelegate = self;
        [_tmpPlayerUI installAfterSetParams];
        @weakify(self);
        [[RACObserve([self videoEntity], totalLotteryTime) skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
           [self videoEntity].curLotteryTime = [self videoEntity].totalLotteryTime;
        }];
    }
    return (WVRPlayerLiveUIManager *)_tmpPlayerUI;
}

#pragma mark - WVRLivePlayerCompleteStrategy

- (WVRLivePlayerCompleteStrategy *)gCompleteStrategy {
    
    if (!_gCompleteStrategy) {
        WVRLivePlayerStrategyConfig * config = [WVRLivePlayerStrategyConfig new];
        config.code = [self videoEntity].sid;
        kWeakSelf(self);
        WVRLivePlayerCompleteStrategy * cs = [[WVRLivePlayerCompleteStrategy alloc] initWithConfig:config completeBlock:^{
            [weakself liveCompleteBlock];
        } restartBlock:^(void (^successRestartBlock)(void)) {
            [weakself liveRestartPlayerBlock];
        } overLimitBlock:^{
            [weakself overLimitBlock];
        }];
        _gCompleteStrategy = cs;
    }
    return _gCompleteStrategy;
}

- (void)liveCompleteBlock {
    
    // banner半屏播放时不做Alert提示
    // [self isKindOfClass:NSClassFromString(@"WVRPlayerBannerLiveController")] &&
    if ([self playerUI].playerUIViewStatus == WVRPlayerUIViewStatusHalfVertical) {
        return;
    }
    
    NSString * tip = kToastLiveOver;
    if ([WVRReachabilityModel sharedInstance].isNoNet) {
        
        [self livePlayFailedTip];
        
    } else {
        [self stopTimer];
        [[self playerUI] updatePlayStatus:WVRPlayerToolVStatusComplete];
//        [self dismissViewControllerForComplete];
    }
}

- (void)dismissViewController {
    [super dismissViewController];
    
}

- (void)dismissViewControllerForComplete
{
    [self showCompleteVC];
//    @weakify(self);
//    [[self playerUI] forceToOrientationPortrait:^{
//        @strongify(self);
//        [self stopTimer];
//        [self.vPlayer onBackForDestroy];
//        
//        if ([self presentingViewController]) {
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self dismissViewControllerAnimated:NO completion:^{
//                    [self showCompleteVC];
//                }];
//            });
//        } else {
//            
//            [self.navigationController popViewControllerAnimated:NO];
//            [self showCompleteVC];
//        }
//    }];
}

- (void)showCompleteVC
{
//    WVRRNLiveCompleteVC * vc = [[WVRRNLiveCompleteVC alloc] init];
////    vc.backDelegate = self;
//    vc.createArgs = @{ @"watchCount": self.detailBaseModel.playCount };
//    [self.navigationController pushViewController:vc animated:NO];
}

- (void)liveRestartPlayerBlock {
    
    [self actionPlay:NO];
    [[self playerUI] execupdateLoadingTip:@"加载直播流中"];
    [[self playerUI] execStalled];
}

- (void)overLimitBlock {
    
    // banner半屏播放时不做Alert提示
    // [self isKindOfClass:NSClassFromString(@"WVRPlayerBannerLiveController")] &&
    if ([self playerUI].playerUIViewStatus == WVRPlayerUIViewStatusHalfVertical) {
        return;
    }
    
    [self livePlayFailedTip];
}

- (void)livePlayFailedTip {
    
    kWeakSelf(self);
    [UIAlertController alertTitle:@"提示" mesasge:@"直播遇到网络问题，请稍后重试:(" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        
        [weakself dismissViewController];
        
    } viewController:weakself];
}

#pragma mark - overwrite Notification

- (void)appDidEnterBackground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
    
    [super appDidEnterBackground:notification];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
    
    [super appWillEnterForeground:notification];
}

#pragma mark - overwrite func

- (void)buildInitData {
    if (![WVRReachabilityModel isNetWorkOK]) {
        SQToastInKeyWindow(kNetError);
        return;
    }
    [super buildInitData];
    
//    self.vPlayer.gIngnoreNetStatus = YES;
}

- (WVRLiveDetailViewModel *)gLiveDetailViewModel
{
    if (!_gLiveDetailViewModel) {
        _gLiveDetailViewModel = [[WVRLiveDetailViewModel alloc] init];
    }
    return _gLiveDetailViewModel;
}

- (void)liveDetailSuccessBlock:(WVRLiveItemModel *)model
{
    if (!model) {
        [self liveDetailValidProgramBlock];
    } else {
        [self dealWithDetailData:model];
    }
}

- (void)liveDetailValidProgramBlock {
    // 节目已失效
    [[self playerUI] forceToOrientationPortrait:^{
        
        SQToastInKeyWindow(kToastProgramInvalid);
    }];
}

- (void)liveDetailFailBlock {
    
     SQToastInKeyWindow(kNoNetAlert);
}

// MARK: - request detail data

- (void)requestForDetailData {
    
    self.gLiveDetailViewModel.code = [self videoEntity].sid;
    [self.gLiveDetailViewModel.gDetailCmd execute:nil];
}

- (void)dealWithDetailData:(WVRLiveItemModel *)model {
    
    if (!model) {
        if (self.class == [WVRPlayerVCLive class]) {
            [self livePlayFailedTip];
        }
        return;
    }
    
    self.detailBaseModel = model;
    
    [self videoEntity].videoTitle = model.title;
    self.lotterySwitch = model.isLottery > 0;
    self.danmuSwitch = model.isDanmu > 0;
    
    [self videoEntity].intro = model.intrDesc;
    [self videoEntity].address = model.address;
    [self videoEntity].beginTime = [model.beginTime longLongValue];
    [self videoEntity].endTime = [model.endTime longLongValue];
    [self videoEntity].mediaDtos = model.mediaDtos;
    [self videoEntity].icon = model.thubImageUrl;
    [self videoEntity].isFootball = model.isFootball;
    [self videoEntity].shareImageUrl = model.shareImageUrl;
    
    [self videoEntity].displayMode = model.displayMode;
    [self videoEntity].showMembers = model.isTip;
    [self videoEntity].showGifts = model.isGift;
    [self videoEntity].tempCode = model.giftTemplate;
    [self videoEntity].viewCount = [model.viewCount integerValue];
    if (model.liveStatus == WVRLiveStatusEnd) {
//        [self screenRotationAndBack];
        [[self playerUI] updatePlayStatus:WVRPlayerToolVStatusComplete];
        return;
    }
//    WVRMediaDto *selectDto = [model.mediaDtos lastObject];
//    [self videoEntity].currentStandType = selectDto.source;
    [[self playerUI] updateAfterSetParams];
    [self toOrientation];

    [self parserBaseData:model];
    
//    [super dealWithDetailData:model];
    [self easterEggAuth:nil];
    [self requestForViewCount];
    [self requestForLotterySwitch];
    if (!_notRecordBI) {
        if ([self isMemberOfClass:[WVRPlayerVCLive class]]) {
            
            [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
            _notRecordBI = YES;
        }
    }
}

// 无需记录历史
- (void)recordHistory {}

- (void)actionOnExit {
    
    if ([WVRAppContext sharedInstance].gSupportedInterfaceO == UIInterfaceOrientationMaskPortrait) {
        
        [self dismissViewController];
    } else {
        
        kWeakSelf(self);
        [[self playerUI] forceToOrientationPortrait:^{
            [weakself dismissViewController];
        }];
    }
}

#pragma mark - WVRPlayerHelperDelegate

- (void)onVideoPrepared {
    [super onVideoPrepared];

    [self.gCompleteStrategy resetStatus];
}

- (void)onCompletion {
//    [super onCompletion];
    [self.gCompleteStrategy http_liveStatus];
}

- (void)dealForParserErrorWithError:(NSString *)err code:(int)code
{
    SQToastInKeyWindow(@"直播出现问题，请稍后再试...");
    [self dismissViewController];
}

- (void)onError:(int)code {
    
    [self stopTimer];
    
    BOOL netOK = [WVRReachabilityModel isNetWorkOK];
    
    if (!netOK) {
        
        SQToastInKeyWindow(kNetError);
        
    } else if ([self videoEntity].haveValidUrlModel) {
        
        [[self playerUI] tryOtherDefinitionForPlayFailed];
    } else {
        
        // banner半屏播放时不做重试，防止进到其他页面对播放器造成印象，因为全局只有一个VRPlayer对象
        // [self isKindOfClass:NSClassFromString(@"WVRPlayerBannerLiveController")] &&
        if ([self playerUI].playerUIViewStatus == WVRPlayerUIViewStatusHalfVertical) {
            return;
        }
        
        [self.gCompleteStrategy http_liveStatus];
    }
}

#pragma mark - timer

- (void)syncScrubber {
    [super syncScrubber];
    
    if (self.syncScrubberNum % 5 == 0) {
        
        [self requestForViewCount];
        
        if (self.syncScrubberNum % 60 == 0) {
            [self requestForLotterySwitch];
        }
    }
    
    if ([self videoEntity].curLotteryTime > 0 && self.lotterySwitch) {
        
        [self videoEntity].curLotteryTime --;
        
//        _lotteryTime = [NSNumber numberWithLongLong:(_lotteryTime.longLongValue - 1)];
//        if (_lotteryTime.intValue < 0) {
//            _lotteryTime = nil;
//        }
    }
}

- (void)checkFreeTime {
    
    if (!self.isCharged && [self.vPlayer isPrepared]) {
        
        NSNumber *trailTime = [[WVRAppModel sharedInstance].liveTrailDict objectForKey:self.detailBaseModel.code];
        if (!trailTime) { trailTime = @(0); }
        
        if (trailTime.integerValue >= self.detailBaseModel.freeTime) {
            
            [self.vPlayer destroyPlayer];
            self.vPlayer.isFreeTimeOver = YES;
            
            [[self playerUI] execFreeTimeOverToCharge:self.detailBaseModel.freeTime];
            self.curPosition = 0.1;
        }
        trailTime = [NSNumber numberWithInteger:(trailTime.integerValue + 1)];
        
        [[WVRAppModel sharedInstance].liveTrailDict setValue:trailTime forKey:self.detailBaseModel.code];
        [[WVRAppModel sharedInstance] saveLiveTrailDict];
    }
}

#pragma mark - request

- (void)requestForCommpents {
    
    [self easterEggAuth:nil];
    
    [self requestForViewCount];
    [self requestForLotterySwitch];
}

- (void)requestForViewCount {
    
    kWeakSelf(self);
    [WVRStatQueryDto requestWithCode:[self videoEntity].sid block:^(WVRStatQueryDto * responseObj, NSError *error) {
        if (responseObj) {
            WVRStatQueryDto *model = responseObj;
            [[weakself playerUI] execPlayCountUpdate:model.playCount];
        }
    }];
}

- (void)requestForLotterySwitch {
    
    kWeakSelf(self);
    [WVRLotteryModel requestLotterySwitchForSid:[self videoEntity].sid block:^(id responseObj, NSError *error) {
        
        weakself.lotterySwitch = ([responseObj[@"lottery"] intValue] == 1);
        weakself.danmuSwitch = ([responseObj[@"danmu"] intValue] == 1);
        [weakself refreshSocketStatus];
    }];
}

#pragma mark - handle data

- (void)refreshSocketStatus {
    
    if (self.danmuSwitch) {
        
    } else {
        
    }
}

/// 广来后端认证
- (void)easterEggAuth:(NSDictionary *)infoDict {
    
    kWeakSelf(self);
    [WVRLotteryModel requestForAuthLottery:^(id responseObj, NSError *error) {
        
        [weakself refreshEasterEggCountdown];
    }];
}

#pragma mark - WVRPlayerUILiveManagerDelegate

- (void)shareBtnClick:(UIButton *)sender {
    
//    [[self playerUI] scheduleHideControls];
//    [self controlOnPause];
    
    WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:self.view
                                                                   sID:[self videoEntity].sid
                                                               iconUrl:[self videoEntity].shareImageUrl
                                                                 title:[self videoEntity].videoTitle
                                                                 intro:@""
                                                                 mobId:nil
                                                             shareType:WVRShareTypeLive];
    shareView.cancleBlock = ^() {
//        [weakself controlOnResume];
    };
    
    kWeakSelf(self);
    shareView.clickBlock = ^(kSharePlatform platform) {
        if (platform != kSharePlatformLink) {
            
            [WVRProgramBIModel trackEventForShare:[weakself biModel]];
        }
    };
}

- (void)vrModeBtnClick:(UIButton *)sender {
//    [self.playerUI forceToOrientationMaskLandscapeRight];
    
//    [self changeToVRMode];
}

- (void)dealWithUserLogin {
    
    [self easterEggAuth:nil];       // 宝箱抽奖认证
    [[self playerUI] execDealWithUserLogin];    // 弹幕相关处理
}

#pragma mark - WVRPlayerViewDelegate
/*
 typedef NS_ENUM(NSInteger, WVRPayManageResultStatus) {
 
 WVRPayManageResultStatusUN = 0,
 WVRPayManageResultStatusSuccess = 1,    // 之前已支付 也回调成功
 WVRPayManageResultStatusFail = 2,
 WVRPayManageResultStatusCancle = 3,
 WVRPayManageResultStatusNotHavePay = 4,
 WVRPayManageResultStatusOverTime = 5,
 };
 */
- (void)actionGotoBuy {
    
    [self.view.window endEditing:NO];
    if (self.vPlayer.isValid) {
        [self controlOnPause];
    }
    
    @weakify(self);
    [[self playerUI] forceToOrientationPortrait:^{
        //cmd只会执行一次
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSInteger payResult = [input[@"success"] integerValue];
                @strongify(self);
                if (payResult==1 || payResult==3) {
                    [self toOrientation];
                }
                BOOL success = (payResult==1);
                [self dealWithPaymentResult:success];
                
                return nil;
            }];
        }];
        
        //    @{ @"itemModel":WVRItemModel, @"streamType":WVRStreamType , @"cmd":RACCommand }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"streamType"] = @([self videoEntity].streamType);
        dict[@"itemModel"] = self.detailBaseModel;
        dict[@"cmd"] = cmd;
        
        [[WVRMediator sharedInstance] WVRMediator_PayForVideo:dict];
    }];
}

- (void)dealWithPaymentResult:(BOOL)success {
    
    self.isCharged = success;
    
    if (success) {
        [[WVRMediator sharedInstance] WVRMediator_PayReportDevice:nil];
        
        [self dealWithPaymentOver];
    } else {
        if (self.vPlayer.isValid) {
            [self controlOnResume];
        } else if (!self.vPlayer.isFreeTimeOver) {
            [self readyToPlay];
        }
    }
}

#pragma mark - WVRPlayerUILiveManagerDelegate

- (void)actionGoGiftPage {
    
//    kWeakSelf(self);
//    @weakify(self);
//    [[self playerUI] forceToOrientationPortrait:^{
//        @strongify(self);
        [self presentGiftVC];
//        WVRRewardController *vc = [[WVRRewardController alloc] init];
//        [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }];
}

- (void)presentGiftVC {
    
    WVRRewardController *vc = [[WVRRewardController alloc] init];
    WVRNavigationController *vcNav = [[WVRNavigationController alloc] initWithRootViewController:vc];
    
    [[UIViewController getCurrentVC] presentViewController:vcNav animated:YES completion:^{}];
}

- (BOOL)actionCheckLogin {
    
    [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    
    RACCommand *successCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
//            BOOL isLogined = [input boolValue];
//            if (!isLogined) {
//
//            }
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

- (void)actionEasterEggLottery {
    
    kWeakSelf(self);
    
    [WVRLotteryModel requestForLotteryWithSid:[self videoEntity].sid block:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"status"] intValue] == 1) {
            
            [[WVRMediator sharedInstance] WVRMediator_UpdateRewardDot:YES];
        }
        [[weakself playerUI] execLotteryResult:responseObj];
        
        if ([responseObj[@"countdown"] intValue] > 0) {
//            weakself.lotteryTime = [NSNumber numberWithInteger:[responseObj[@"countdown"] intValue]];
            [weakself videoEntity].totalLotteryTime = [responseObj[@"countdown"] integerValue];
        } else if ([responseObj[@"remain"] intValue] == 0) {
            
            [weakself refreshEasterEggCountdown];
        }
    }];
}

- (void)refreshEasterEggCountdown {
    
    kWeakSelf(self);
    [WVRLotteryModel requestForBoxCountdownForSid:[self videoEntity].sid block:^(id responseObj, NSError *error) {
        
        int status = [responseObj[@"status"] intValue];
        if (status == -2600) {
            // 活动已经结束
            DDLogError(@"该节目直播抽奖活动已经结束");
        }
        
        if (responseObj[@"countdown"]) {
            
//            weakself.lotteryTime = [NSNumber numberWithLongLong:[responseObj[@"countdown"] longLongValue]];
            [weakself videoEntity].totalLotteryTime = [responseObj[@"countdown"] integerValue];
        } else {
//            weakself.lotteryTime = @10;
            [weakself videoEntity].totalLotteryTime = 10;
        }
    }];
}

- (void)actionGoRedeemPage {
    
    @weakify(self);
    [[self playerUI] forceToOrientationPortrait:^{
        
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self);
                UIViewController *vc = [[WVRMediator sharedInstance] WVRMediator_MyTicketViewController];
                [self.navigationController pushViewController:vc animated:YES];
                return nil;
            }];
        }];
        
        RACCommand *cancleCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self);
                [self toOrientation];
                
                return nil;
            }];
        }];
        NSDictionary *dict = @{ @"completeCmd":cmd, @"cancelCmd":cancleCmd };
        
        [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:dict];
    }];
}

#pragma mark - rotation

- (void)screenRotationAndBack {
    
    kWeakSelf(self);
    [[self playerUI] forceToOrientationPortrait:^{
        
        [weakself.navigationController popViewControllerAnimated:YES];
        SQToastInKeyWindow(kToastLiveOver);
    }];
}

// 横屏状态下要失效掉右划返回功能
/// YES：关闭手势返回 NO：开启手势返回
- (void)invalidNavPanGuesture:(BOOL)isInvalid {
    
    WVRNavigationController *nav = (WVRNavigationController *)self.navigationController;
    nav.gestureInValid = isInvalid;
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

#pragma mark - BI

/// 对应BI埋点的pageId字段，直播预告页面已重写该方法
- (NSString *)currentPageId {
    
    return @"liveDetails";
}

- (NSString *)videoFormat {
    
    return self.detailBaseModel.videoType;
}

- (NSString *)biPageName {
    
    return self.detailBaseModel.title;
}

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

-(void)backForResult:(id)info resultCode:(NSInteger)resultCode{
    @weakify(self);
    [[self playerUI] forceToOrientationPortrait:^{
        @strongify(self);
        [self stopTimer];
        [self.vPlayer onBackForDestroy];

        if ([self presentingViewController]) {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
//    NSArray * childVCS = self.navigationController.childViewControllers;
//    for (WVRBaseViewController* cur in childVCS) {
//        if ([cur isKindOfClass:NSClassFromString(@"WVRPlayerVCLive")]) {
//            NSInteger index = [self.navigationController.childViewControllers indexOfObject:cur];
//            if (index > 0) {
//                [self.navigationController popToViewController:childVCS[index-1] animated:NO];
//            }else{
//                [self.navigationController popToRootViewControllerAnimated:NO];
//            }
//        }
//    }
}

@end

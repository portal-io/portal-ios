//
//  WVRPlayerLiveUIManager.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLiveUIManager.h"
#import "WVRPlayerViewLive.h"
#import "WVRPlayerLiveBottomView.h"
#import "UIViewController+HUD.h"

#import "WVRDanmuController.h"
#import "WVRLotteryBoxController.h"
#import "WVRBlurBackgroundController.h"

#import <Masonry/Masonry.h>
#import "WVRMediator+Danmu.h"
#import "WVRWebSocketMsg.h"

#import "WVRPlayerViewAdapter.h"
#import "WVRPlayLiveTopCellViewModel.h"
#import "WVRPlayLiveBottomCellViewModel.h"
#import "WVRVideoEntityLive.h"
#import "WVRRemindChargeController.h"
#import "WVRLiveItemModel.h"
#import "WVRLiveCarImageController.h"

#import "WVRProgramBIModel.h"

#import "WVRLiveCompleteViewPresenter.h"
//#import "WVRRNLiveCompleteVC.h"
#import "WVRBaseViewController.h"
#import "WVRMediator+WVRReactNative.h"

@interface WVRPlayerLiveUIManager ()<WVRPlayerViewLiveDelegate, WVRPlayerLiveBottomViewDelegate, WVRPlayerTopViewDelegate, WVRPlayLiveTopViewDelegate, WVRPlayerBottomViewDelegate>

@property (nonatomic, assign) BOOL onFirstResponder;

//@property (nonatomic, strong) WVRPlayViewViewModel * gPlayViewViewModel;
//@property (nonatomic, strong) WVRPlayLiveTopCellViewModel * gTopCellViewModel;
//@property (nonatomic, strong) WVRPlayLiveBottomCellViewModel * gBottomCellViewModel;

//@property (nonatomic, strong) NSMutableDictionary * gPlayAdapterOriginDic;

- (WVRVideoEntityLive *)videoEntity;

@end


@implementation WVRPlayerLiveUIManager
@synthesize gPlayerViewAdapter = _gPlayerViewAdapter;
@synthesize gTopCellViewModel = _gTopCellViewModel;
@synthesize gLeftCellViewModel = _gLeftCellViewModel;
@synthesize gRightCellViewModel = _gRightCellViewModel;
@synthesize gBottomCellViewModel = _gBottomCellViewModel;
@synthesize gLodingCellViewModel = _gLodingCellViewModel;
@synthesize gVRLoadingCellViewModel = _gVRLoadingCellViewModel;
@synthesize gVRModeBackBtnAnimationViewModel = _gVRModeBackBtnAnimationViewModel;

- (void)installAfterSetParams {
    [super installAfterSetParams];
    
    @weakify(self);
    [[RACObserve([self videoEntity], curLotteryTime) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self execEasterEggCountdown:[self videoEntity].curLotteryTime];
    }];
}

- (WVRPlayLoadingCellViewModel *)gVRLoadingCellViewModel {
    
    if (!_gVRLoadingCellViewModel) {
        WVRPlayLoadingCellViewModel * cur = [super gVRLoadingCellViewModel];
//        cur.playStatus = WVRPlayerToolVStatusDefault;
        cur.gIsLive = YES;
        cur.gHidenBack = NO;
        _gVRLoadingCellViewModel = cur;
    }
    return _gVRLoadingCellViewModel;
}

- (WVRPlayLoadingCellViewModel *)gLodingCellViewModel
{
    if (!_gLodingCellViewModel) {
        WVRPlayLoadingCellViewModel * cur = [super gLodingCellViewModel];
//        cur.playStatus = WVRPlayerToolVStatusDefault;
        cur.gIsLive = YES;
        cur.gHidenBack = NO;
        _gLodingCellViewModel = cur;
    }
    return _gLodingCellViewModel;
}

- (WVRPlayGiftContainerCellViewModel *)gGiftContainerCellViewModel
{
    if (!_gGiftContainerCellViewModel) {
        WVRPlayGiftContainerCellViewModel * viewModel = [[WVRPlayGiftContainerCellViewModel alloc] init];
        viewModel.cellNibName = @"WVRPlayGiftContainerCell";
        _gGiftContainerCellViewModel = viewModel;
        _gGiftContainerCellViewModel.gGiftStatus = WVRPlayerToolVStatusGiftHiden;
        @weakify(self);
        [RACObserve(_gGiftContainerCellViewModel, gGiftStatus) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateGiftStatus:_gGiftContainerCellViewModel.gGiftStatus];
        }];
    }
    return _gGiftContainerCellViewModel;
}

- (void)installGiftPresenter
{
    WVRGiftPresenterParams *params = [[WVRGiftPresenterParams alloc] init];
    params.showMembers = [self videoEntity].showMembers;
    params.showGifts = [self videoEntity].showGifts;
    params.tempCode = [self videoEntity].tempCode;
    params.programCode = [self videoEntity].sid;
    params.videoName = [self videoEntity].videoTitle;
    [RACObserve([self videoEntity], displayMode) subscribeNext:^(id  _Nullable x) {
        self.gGiftContainerCellViewModel.displayMode = [self videoEntity].displayMode;
    }];
    [self.gGiftContainerCellViewModel.gGiftPresenter setParams:params];
    [self.gGiftContainerCellViewModel.gGiftPresenter fetchData];
    [self updateGiftSwitch];
}

- (void)updateGiftSwitch {
    
    if ([self videoEntity].showGifts && [self videoEntity].tempCode.length > 0) {
        self.gBottomCellViewModel.canShowGift = YES;
        self.gTopCellViewModel.canShowGift = YES;
    } else {
        self.gBottomCellViewModel.canShowGift = NO;
        self.gTopCellViewModel.canShowGift = NO;
    }
}

- (UIView *)createPlayerViewWithContainerView:(UIView *)containerView {
    
    // live
    WVRPlayerViewStyle style = WVRPlayerViewStyleLive;
    float height = containerView.height;
    float width = containerView.width;
    CGRect rect = CGRectMake(0, 0, MAX(width, height), MIN(width, height));
    
    NSDictionary *veDict = [[self videoEntity] yy_modelToJSONObject];
    WVRPlayerViewLive *view = [[WVRPlayerViewLive alloc] initWithFrame:rect style:style videoEntity:veDict delegate:self];
    
    [containerView addSubview:view];
    self.playerView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.size.equalTo(view.superview);
    }];
    
    // 初始化
    self.gPlayAdapterOriginDic[kGIFTCONTAINER_PLAYVIEW] = self.gGiftContainerCellViewModel;
    [view fillData:self.gPlayViewViewModel];
    view.dataSource = self.gPlayerViewAdapter;
    [view reloadData];
    
//    [self addComponentsForFullScreenLive];   // 放在updateAfterSetParams方法里执行 确认拿到详情页数据后添加
    
    [self registerObserverEvent];
    [self installRAC];
    return view;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addComponentsForFullScreenLive {        // 全屏直播才执行此方法，子类重写
    
    [self addComponents];
}

- (void)updateAfterSetParams {
    [super updateAfterSetParams];
    
    // 在设置礼物之前设置机位按钮
    self.gBottomCellViewModel.showCameraBtn = [self.detailBaseModel.type isEqualToString:CONTENTTYPE_LIVE_CAR];
    
    [self installGiftPresenter];
}

- (void)addComponents {
    [super addComponents];

    [self addDanmuController];
    [self addLotteryBoxController];
    [self addBlurBackgroundController];
    
    [self addRemindChargeController];
    
    [self addLiveCarImageController];
}

- (void)addLiveCarImageController {
    
    WVRLiveCarImageController *controller = [[WVRLiveCarImageController alloc] initWithDelegate:self];
    
    WVRLiveItemModel *detailModel = (WVRLiveItemModel *)self.detailBaseModel;
    if (![detailModel isKindOfClass:[WVRLiveItemModel class]]) {
        return;
    }
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    if (detailModel.floatPic1.length > 0 && detailModel.floatUrl1.length > 0) {
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        dict1[@"floatName"] = detailModel.floatName1;
        dict1[@"floatPic"] = detailModel.floatPic1;
        dict1[@"floatUrl"] = detailModel.floatUrl1;
        
        [dataDict setObject:dict1 forKey:[NSString stringWithFormat:@"%ld", dataDict.count + 1]];
    }
    if (detailModel.floatPic2.length > 0 && detailModel.floatUrl2.length > 0) {
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        dict2[@"floatName"] = detailModel.floatName2;
        dict2[@"floatPic"] = detailModel.floatPic2;
        dict2[@"floatUrl"] = detailModel.floatUrl2;
        
        [dataDict setObject:dict2 forKey:[NSString stringWithFormat:@"%ld", dataDict.count + 1]];
    }
    if (detailModel.floatPic3.length > 0 && detailModel.floatUrl3.length > 0) {
        
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        dict3[@"floatName"] = detailModel.floatName3;
        dict3[@"floatPic"] = detailModel.floatPic3;
        dict3[@"floatUrl"] = detailModel.floatUrl3;
        
        [dataDict setObject:dict3 forKey:[NSString stringWithFormat:@"%ld", dataDict.count + 1]];
    }
    
    NSDictionary *dict = @{ @"parentView": [self playerView], @"dataDict": dataDict, @"playerIsPrepared": @(self.vPlayer.isOnPrepared) };
    [controller addControllerWithParams:dict];
    
    [self.components addObject:controller];
}

- (void)addDanmuController {
    
    WVRDanmuController *danmuC = [[WVRDanmuController alloc] initWithDelegate:self];
    
    NSDictionary *dict = @{ @"parentView": [self playerView], @"ve": [[self videoEntity] yy_modelToJSONObject] };
    [danmuC addControllerWithParams:dict];
    
    [self.components addObject:danmuC];
    [self openDanmuSocket];
}

- (void)openDanmuSocket {
    [self execOpenSocket];
}

- (void)removeUIComponents {
//    if (self.components.count > 0) {
        [self closeDanmuSocket];
//    }
    [super removeUIComponents];
}

- (void)closeDanmuSocket {
    [self execCloseSocket];
}

- (void)addLotteryBoxController {
    
    WVRLotteryBoxController *controller = [[WVRLotteryBoxController alloc] initWithDelegate:self];
    
    NSDictionary *dict = @{ @"parentView":[self playerView], @"ve":[[self videoEntity] yy_modelToJSONObject] };
    [controller addControllerWithParams:dict];
    
    [self.components addObject:controller];
}

- (void)removeLotteryComponent {
    
    id curComponent = nil;
    for (id<WVRPlayerUIProtocol> component in self.components) {
        if ([component isKindOfClass:[WVRLotteryBoxController class]]) {
            [component removeController];
            curComponent = component;
            break;
        }
    }
    [self.components removeObject:curComponent];
}

- (void)removeRemindComponent {
    
    id curComponent = nil;
    for (id<WVRPlayerUIProtocol> component in self.components) {
        if ([component isKindOfClass:[WVRRemindChargeController class]]) {
            [component removeController];
            curComponent = component;
            break;
        }
    }
    [self.components removeObject:curComponent];
}

- (void)addBlurBackgroundController {
    if (self.vPlayer.isPrepared) {
        return;
    }
    if (![[self videoEntity] respondsToSelector:@selector(icon)]) { return; }
    
    NSString *imgUrl = [[self videoEntity] performSelector:@selector(icon)];
    
    if (!imgUrl) { return; }
    
    // 模糊背景图
    WVRBlurBackgroundController *blurC = [[WVRBlurBackgroundController alloc] initWithDelegate:self];
    
    NSDictionary *dict = @{ @"parentView":[self playerView], @"imgUrl":imgUrl };
    [blurC addControllerWithParams:dict];
    
    [self.components addObject:blurC];
}

- (void)addRemindChargeController {
    
    WVRRemindChargeController *remindC = [[WVRRemindChargeController alloc] initWithDelegate:self];
    
    NSDictionary *dict = @{ @"parentView":[self playerView], @"ve":[self videoEntity], @"isProgramSet": @([self.detailBaseModel isProgramSet]) };
    [remindC addControllerWithParams:dict];
    
    [self.components addObject:remindC];
}

- (void)addLiveCompleteComponent {
    
    WVRLiveCompleteViewPresenter *liveCP = [[WVRLiveCompleteViewPresenter alloc] initWithDelegate:self];
    NSInteger showGift = [self videoEntity].showGifts;
    NSInteger showM = [self videoEntity].showMembers;
    NSDictionary *dict = @{ @"parentView":[self playerView], @"showGifts":@(showGift), @"showMembers":@(showM),@"tempCode":[self videoEntity].tempCode, @"pragramCode":[self videoEntity].sid, @"imgUrl":[self videoEntity].icon };
    [liveCP addControllerWithParams:dict];
    
    [self.components addObject:liveCP];
}

- (void)setPlayerView:(WVRPlayerViewLive *)playerView {
    [super setPlayerView:playerView];

    playerView.liveDelegate = self;
}

- (WVRPlayerViewLive *)playerView {
    
    return (WVRPlayerViewLive *)[super playerView];
}

- (void)execFreeTimeOverToCharge:(long)freeTime {
    [super execFreeTimeOverToCharge:freeTime];
    
    BOOL canTrail = (freeTime > 0);
    NSString *price = [NSString stringWithFormat:@"%ld", [self detailBaseModel].price];
    [self deliveryEventToComponents:@"playerui_TrailOverToPay" params:@{ @"canTrail":@(canTrail), @"price":price, @"endTime":@([self videoEntity].endTime), @"isProgramSet": @([self.detailBaseModel isProgramSet])}];
    
    [self removeLotteryComponent];
    
//    [self updatePlayStatus:WVRPlayerToolVStatusWatingPay];
}

#pragma mark - Notification

// 键盘 弹出/消失，事件注册
- (void)registerObserverEvent {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    // 保护
    if (![self.uiDelegate isKindOfClass:[UIViewController class]]) { return; }
    if (![(UIViewController *)self.uiDelegate isCurrentViewControllerVisible]) { return; }
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self execKeyboardOn:YES keyboardHeight:height animateTime:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 保护
    if (![self.uiDelegate isKindOfClass:[UIViewController class]]) { return; }
    if (![(UIViewController *)self.uiDelegate isCurrentViewControllerVisible]) { return; }
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self execKeyboardOn:NO keyboardHeight:0 animateTime:animationDuration];
}

#pragma mark - getter

- (WVRVideoEntityLive *)videoEntity {
    
    return (WVRVideoEntityLive *)[super videoEntity];
}

- (WVRPlayerViewAdapter *)gPlayerViewAdapter
{
    if (!_gPlayerViewAdapter) {
        _gPlayerViewAdapter = [[WVRPlayerViewAdapter alloc] init];
        [_gPlayerViewAdapter loadData:self.gPlayAdapterOriginDic];
    }
    return _gPlayerViewAdapter;
}

- (WVRPlayTopCellViewModel *)gTopCellViewModel
{
    if (!_gTopCellViewModel) {
        WVRPlayLiveTopCellViewModel* topCellViewModel = [[WVRPlayLiveTopCellViewModel alloc] init];
        topCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
        topCellViewModel.delegate = self;
        @weakify(self);
        [RACObserve([self videoEntity], videoTitle) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            topCellViewModel.title = [self videoEntity].videoTitle;
        }];
        topCellViewModel.height = HEIGHT_TOP_VIEW_LIVE;
        _gTopCellViewModel = (WVRPlayTopCellViewModel*)topCellViewModel;
    }
    return _gTopCellViewModel;
}

- (WVRPlayBottomCellViewModel *)gBottomCellViewModel
{
    if (!_gBottomCellViewModel) {
        WVRPlayLiveBottomCellViewModel * bottomViewModel = [[WVRPlayLiveBottomCellViewModel alloc] init];
        bottomViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
        bottomViewModel.delegate = self;
        bottomViewModel.height = HEIGHT_BOTTOM_VIEW_LIVE;
        
        _gBottomCellViewModel = (WVRPlayBottomCellViewModel*)bottomViewModel;
    }
    return _gBottomCellViewModel;
}

- (WVRPlayViewCellViewModel *)gVRModeBackBtnAnimationViewModel
{
    return nil;
}

- (void)installRAC
{
    @weakify(self);
    [[RACObserve([self videoEntity], displayMode) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([self videoEntity].displayMode == WVRLiveDisplayModeHorizontal) {
            self.gTopCellViewModel.cellNibName = @"WVRPlayerFullLiveTopView";
            self.gTopCellViewModel.height = HEIGHT_TOP_VIEW_LIVE_H;
        }else{
            self.gTopCellViewModel.cellNibName = [self parserStreamtypeForFullTopCellNibName];
        }
        [self changeViewFrameForFootball];
    }];
    
}

- (NSString *)parserStreamtypeForFullBottomCellNibName
{
    NSString * cellNibName = nil;
    cellNibName = [self liveProgramCellNibName];
    return cellNibName;
}

- (NSString *)liveProgramCellNibName
{
    NSString * cellNibName = @"WVRPlayerLiveBottomView";
    if ([self videoEntity].isFootball) {
        
        cellNibName = self.isNotMonocular ? @"WVRPlayVRLiveFootballBottomView": @"WVRPlayerLiveFootBallBottomView";
    } else {
        cellNibName = self.isNotMonocular ? @"WVRPlayVRLiveBottomView": @"WVRPlayerLiveBottomView";
    }
    return cellNibName;
}

- (NSString *)parserStreamtypeForFullTopCellNibName
{
    NSString * cellNibName = @"WVRPlayerLiveTopView";
    cellNibName = self.isNotMonocular ? @"WVRPlayerVRTopView": @"WVRPlayerLiveTopView";
    return cellNibName;
}

- (void)changeViewFrameForFootball {
//    if ([self videoEntity].isFootball) {
//        self.gBottomCellViewModel.cellClassName = @"WVRPlayerLiveFootBallBottomView";
//    } else {
//        self.gBottomCellViewModel.cellClassName = @"WVRPlayerLiveBottomView";
//    }
    self.gBottomCellViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
    [[self playerView] reloadData];
}

- (void)changeViewFrameForFull {
    [self deliveryEventToComponents:@"playerui_setMonocular" params:@{ @"isMonocular": @(self.isNotMonocular) }];
    if (self.isNotMonocular) {
//        [self removeUIComponents];
        [self updateVRStatus:WVRPlayerToolVStatusVR];
//        [self updateAnimationStatus:WVRPlayerToolVStatusAnimating];
        [self.gPlayAdapterOriginDic removeObjectForKey:kTOP_PLAYVIEW];
        self.gPlayAdapterOriginDic[kLOADING_PLAYVIEW] = self.gVRLoadingCellViewModel;
    } else {
//        [self addComponentsForFullScreenLive];
        [self updateVRStatus:WVRPlayerToolVStatusNotVR];
        self.gPlayAdapterOriginDic[kLOADING_PLAYVIEW] = self.gLodingCellViewModel;
        self.gPlayAdapterOriginDic[kTOP_PLAYVIEW] = self.gTopCellViewModel;
    }
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:[self videoEntity].curDefinition];
    self.gBottomCellViewModel.cellNibName = [self parserStreamtypeForFullBottomCellNibName];
    self.gVRLoadingCellViewModel.gHidenBack = YES;
    self.gLodingCellViewModel.gHidenBack = YES;
}

#pragma mark - other

- (void)execKeyboardOn:(BOOL)isOn keyboardHeight:(float)height animateTime:(float)time {
    
    if (!self.onFirstResponder) { return; }
    self.gPlayViewViewModel.isKeyBoardShow = isOn;
    
    // show
    if (isOn) {
        
        [[self playerView] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0 - height);
        }];
        
        [UIView animateWithDuration:time animations:^{
            
            [self playerView].y = 0 - height;
            
            ((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).isKeyboardOn = YES;
            
        } completion:^(BOOL finished) {
            
            ((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).keyboardAnimatoinDone = !((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).keyboardAnimatoinDone;
            [[self playerView] controlsShowHideAnimation:NO];
            [self execDanmuReceived:@[]];
        }];
    } else {
        
        [self deliveryEventToComponents:@"playerui_setResignFirstResponder" params:nil];
        
//        hide
        [[self playerView] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
        
        [UIView animateWithDuration:time animations:^{
            
            [self playerView].y = 0;
            
            ((WVRPlayLiveBottomCellViewModel*)[self gBottomCellViewModel]).isKeyboardOn = NO;
            
        } completion:^(BOOL finished) {
            
            [self setOnFirstResponder:NO];
            [[self playerView] controlsShowHideAnimation:NO];
            
            ((WVRPlayLiveBottomCellViewModel*)[self gBottomCellViewModel]).keyboardAnimatoinDone = !((WVRPlayLiveBottomCellViewModel*)[self gBottomCellViewModel]).keyboardAnimatoinDone;
            [self execDanmuReceived:@[]];
        }];
    }
}

#pragma mark - OverWrite WVRPlayerViewDelegate

- (void)actionSetControlsVisible:(BOOL)isControlsVisible {
    
//    [self.liveBottomView setVisibel:isControlsVisible];
}

// 暂时没用到 屏蔽掉
//- (void)actionTouchesBegan {
//    [super actionTouchesBegan];
//
//    // 退出编辑模式
//    [self deliveryEventToComponents:@"playerui_setResignFirstResponder" params:nil];
//}

- (void)execUpdateDefiBtnTitle {
    [super execUpdateDefiBtnTitle];
    
//    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:[self videoEntity].curDefinition];
}

#pragma mark - WVRPlayerViewLiveDelegate

- (void)actionEasterEggLottery {
    
    [self.uiLiveDelegate actionEasterEggLottery];
}

- (void)actionGoGiftPage {
    
    [self.uiLiveDelegate actionGoGiftPage];
}

- (BOOL)actionCheckLogin {
    
    return [self.uiLiveDelegate actionCheckLogin];
}

- (void)actionGoRedeemPage {
    
    [self.uiLiveDelegate actionGoRedeemPage];
}

- (void)shareBtnClick:(UIButton *)sender {
    
    [self.uiLiveDelegate shareBtnClick:sender];
}

#pragma mark - WVRPlayLiveTopViewDelegate

- (void)shareOnClick:(WVRPlayerLiveTopView *)view {
    
    ((WVRPlayLiveTopCellViewModel*)self.gTopCellViewModel).iconUrl = [self videoEntity].icon;
    [self.uiLiveDelegate shareBtnClick:nil];
}

- (void)gotoContribution:(WVRPlayerLiveTopView *)view
{
//    [self gotoLiveCompleteVC];
//    return;
    BOOL hasMemberRank = [self videoEntity].showMembers&&self.gGiftContainerCellViewModel.gGiftPresenter.gGiftViewModel.enableProgramMembers;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict[@"liveCode"] = [self videoEntity].sid;
    dict[@"hasMemberRank"] = @(hasMemberRank);
    WVRBaseViewController * vc = (WVRBaseViewController *)[[WVRMediator sharedInstance] WVRMediator_WVRReactNativeGoldViewController:dict];
    WVRNavigationController * nv = [[WVRNavigationController alloc] initWithRootViewController:vc];
    WVRBaseViewController * curVC = (WVRBaseViewController*)[UIViewController getCurrentVC];
    vc.backDelegate = curVC;
    //    [curVC.navigationController popViewControllerAnimated:NO];
    [curVC presentViewController:nv animated:YES completion:^{
        
    }];
}

- (void)refreshLiveAlertInfo {
    
    ((WVRPlayLiveTopCellViewModel *)self.gTopCellViewModel).beginTime = [self videoEntity].beginTime;
    self.gTopCellViewModel.title = [self videoEntity].videoTitle;
    ((WVRPlayLiveTopCellViewModel *)self.gTopCellViewModel).address = [self videoEntity].address;
    ((WVRPlayLiveTopCellViewModel *)self.gTopCellViewModel).intro = [self videoEntity].intro;
    ((WVRPlayLiveTopCellViewModel *)self.gTopCellViewModel).playCount = [self videoEntity].biEntity.playCount;
}

#pragma mark - WVRPlayerTopViewDelegate

- (void)backOnClick:(UIButton *)sender {
    
    // 直播页面是执行退出操作，banner需要重写该方法
    [self.uiDelegate actionOnExit];
}

#pragma mark - WVRPlayerLiveBottomViewDelegate

- (void)actionGiftBtnClick
{
    [self.gGiftContainerCellViewModel.gShowGiftContainerCmd execute:nil];
}

- (void)launchOnClick:(UIButton *)sender {
    
    [self actionSwitchVR];
    
//    if (self.isNotMonocular) {
//        [super forceToOrientationMaskLandscapeRight];
//    } else {
//        if ([(WVRVideoEntityLive *)[self videoEntity] displayMode] == WVRLiveDisplayModeVertical) {
//            [super forceToOrientationPortrait];
//            [WVRAppContext sharedInstance].gStatusBarHidden = YES;
//            UIViewController * vc = [UIViewController getCurrentVC];
//            if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//                [vc prefersStatusBarHidden];
//                [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//            }
//        } else {
//            [[self playerView] reloadData];
//        }
//    }
}

//MARK: - 播放器状态信息

- (BOOL)isPrepared {
    
    return [self.vPlayer isPrepared];
}

#pragma mark - exec function

- (void)execPreparedWithDuration:(long)duration {
    [super execPreparedWithDuration:duration];
    
    self.gBottomCellViewModel.defiTitle = [self definitionToTitle:[self videoEntity].curDefinition];
}

- (void)execDanmuReceived:(NSArray *)array {
    
    [self deliveryEventToComponents:@"playerui_addDanmuWithArray" params:@{ @"danmuArray":array }];
}

- (void)execPlayCountUpdate:(long)playCount {
    
    [self videoEntity].biEntity.playCount = playCount;
    ((WVRPlayLiveTopCellViewModel*)self.gTopCellViewModel).playCount = playCount;
}

- (void)execNetworkStatusChanged {
    
    [[self playerView] execNetworkStatusChanged];
}

- (void)execEasterEggCountdown:(long)time {
    
    BOOL isPortrait = YES;//!self.isLandscape;
    BOOL viewsShow = (![[self playerView] isContorlsHide]);
    
    BOOL isShow = (isPortrait && viewsShow&&!self.gPlayViewViewModel.viewIsHiden);
    
    [self deliveryEventToComponents:@"playerui_updateCountDown" params:@{ @"isShow":@(isShow), @"countDown":@(time) }];
}

- (void)execLotterySwitch:(BOOL)isOn {
    
    [self deliveryEventToComponents:@"playerui_setBoxSwitch" params:@{@"switch":@(isOn)}];
}

- (void)execDanmuSwitch:(BOOL)isOn {
    
    ((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).danmuSwitch = isOn;
    [self deliveryEventToComponents:@"playerui_setDanmuSwitchOn" params:@{ @"isOn":@(isOn) }];
}

- (void)execLotteryResult:(NSDictionary *)dict {
    
    [[self playerView] execLotteryResult:dict];
}

- (void)execOpenSocket {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"programId"] = [self videoEntity].sid;
    dict[@"programName"] = [self videoEntity].videoTitle;
    
    kWeakSelf(self);
    void(^block)(WVRWebSocketMsg *msg) = ^(WVRWebSocketMsg *msg) {
        
        if ([msg.senderUid isEqualToString:[WVRUserModel sharedInstance].showRoomUserID]) {
            
        } else {
            [weakself execDanmuReceived:@[msg]];
        }
    };
    
    dict[@"block"] = block;
    
    [[WVRMediator sharedInstance] WVRMediator_ConnectForDanmu:dict];
}

- (void)execCloseSocket {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"programId"] = [self videoEntity].sid;
    
    [[WVRMediator sharedInstance] WVRMediator_CloseForDanmu:dict];
}

- (void)execDealWithUserLogin {
    
    if ([[WVRMediator sharedInstance] WVRMediator_ConnectIsActive:nil]) {
        
        [[WVRMediator sharedInstance] WVRMediator_AuthAfterLogin:nil];
        
    } else {
        [self execOpenSocket];
    }
}

#pragma mark - live bottom view

- (void)actionDanmuMessageBtnClick {
    
    [self setOnFirstResponder:YES];
    [self deliveryEventToComponents:@"playerui_becomeToFirstResponder" params:nil];
}

- (void)changeToKeyboardOnStatu:(BOOL)isKeyboardOn {
    
    ((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).isKeyboardOn = isKeyboardOn;
    if (!isKeyboardOn) {
        [self deliveryEventToComponents:@"playerui_setResignFirstResponder" params:nil];
    }
}

- (void)keyboardAnimatoinDoneWithStatu:(BOOL)isKeyboardOn {
    
    ((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).isKeyboardOn = isKeyboardOn;
    ((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).keyboardAnimatoinDone = !((WVRPlayLiveBottomCellViewModel*)self.gBottomCellViewModel).keyboardAnimatoinDone;
}

#pragma mark - private

- (WVRPlayerUIEventCallBack *)playerui_actionGoRedeemPage:(NSDictionary *)params {
    
    [self.uiLiveDelegate actionGoRedeemPage];
    
    return nil;
}

- (WVRPlayerUIEventCallBack *)playerui_danmuSended:(NSDictionary *)params {
    
    /// 弹幕发送事件埋点
    [WVRProgramBIModel trackEventForInteraction:BIInteractionTypeDanmu biModel:[self biModel]];
    
    return nil;
}

- (void)updateLockStatus:(WVRPlayerToolVStatus)status {
    
//    self.gPlayViewStatus = status;
    self.gPlayViewViewModel.lockStatus = status;
    self.gTopCellViewModel.lockStatus = status;
    self.gBottomCellViewModel.lockStatus = status;
}

// MARK: - BI

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.biPageId = self.detailBaseModel.sid;
    model.biPageName = self.detailBaseModel.title;
    
    return model;
}

- (void)updateGiftStatus:(WVRPlayerToolVStatus)status
{
    switch (status) {
        case WVRPlayerToolVStatusGiftShow:
            self.gPlayViewViewModel.viewIsHiden = YES;
            [self deliveryEventToComponents:@"playerui_setDanmuHiden" params:@{ @"danmuHiden":@(YES) }];
            [self deliveryEventToComponents:@"playerui_setboxHidden" params:@{ @"boxHidden":@(YES) }];
            break;
        case WVRPlayerToolVStatusGiftHiden:
            self.gPlayViewViewModel.viewIsHiden = NO;
            [self deliveryEventToComponents:@"playerui_setDanmuHiden" params:@{ @"danmuHiden":@(NO) }];
            [self deliveryEventToComponents:@"playerui_setboxHidden" params:@{ @"boxHidden":@(NO) }];
            break;
        default:
            break;
    }
}

- (void)gotoLiveCompleteVC
{
    NSInteger showGift = [self videoEntity].showGifts;
    NSInteger showM = [self videoEntity].showMembers;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict[@"parentView"] = [self playerView];
    dict[@"showGifts"] = @(showGift);
    dict[@"showMembers"] = @(showM);
    dict[@"tempCode"] = [self videoEntity].tempCode;
    dict[@"pragramCode"] = [self videoEntity].sid;
    dict[@"imgUrl"] = [self videoEntity].icon;
    dict[@"watchCount"] = @([self videoEntity].viewCount);
    WVRBaseViewController * vc = (WVRBaseViewController*)[[WVRMediator sharedInstance] WVRMediator_WVRReactNativeLiveCompleteVC:dict];
    WVRNavigationController * nv = [[WVRNavigationController alloc] initWithRootViewController:vc];
    WVRBaseViewController * curVC = (WVRBaseViewController*)[UIViewController getCurrentVC];
    vc.backDelegate = curVC;
//    [curVC.navigationController popViewControllerAnimated:NO];
    [curVC presentViewController:nv animated:YES completion:^{
        
    }];
//    [curVC pushViewController:(WVRBaseViewController*)vc animated:YES];
}

- (void)updatePlayStatus:(WVRPlayerToolVStatus)status
{
    [super updatePlayStatus:status];
    if (status==WVRPlayerToolVStatusComplete) {
        [self deliveryEventToComponents:@"playerui_Complete" params:@{}];
//        [self addLiveCompleteComponent];
        [self gotoLiveCompleteVC];
    }
}

@end

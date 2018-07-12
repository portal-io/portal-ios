//
//  WVRRNLiveCompleteVC.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/12.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNLiveCompleteVC.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "WVRBlurBackgroundController.h"
#import "WVRProgramBIModel.h"
#import "WVRRNConfig.h"
#import "WVRLiveDetailViewModel.h"
#import "WVRLiveItemModel.h"

@interface WVRRNLiveCompleteVC () {
    BOOL _isNotFirstIn;
}

@property (nonatomic, strong) WVRLiveDetailViewModel * gLiveDetailViewModel;
@property (nonatomic, strong) WVRLiveItemModel *detailModel;

@end


@implementation WVRRNLiveCompleteVC

- (void)loadView
{
    [self loadReactNativeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addBlurBackgroundController];
    
//    [self showProgress];
    
    [self setupRequestRAC];
    [self requestForDetailData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isNotFirstIn) {
        [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
    }
    [self registerObserverEvent];
    
    _isNotFirstIn = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
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

- (void)appWillEnterBackground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowseEnd:[self biModel]];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    
    [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
}

// MARK: - RN

- (void)loadReactNativeView
{
    NSDictionary * dic = self.createArgs;
    NSString *imgUrl = dic[@"imgUrl"];
    NSString * liveCode = dic[@"pragramCode"];
    BOOL hasMemberRank = [dic[@"showMembers"] boolValue];
    BOOL hasContribution = [dic[@"showGifts"] boolValue];
    if (dic[@"showGifts"] && dic[@"tempCode"]) {
        
    } else {
        hasContribution = YES;
    }
    NSNumber * watchCount = dic[@"watchCount"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"routeName"] = @"LiveComplete";
    params[@"liveCode"] = liveCode;
    params[@"hasMemberRank"] = @(hasMemberRank);
    params[@"hasContribution"] = @(hasContribution);
    params[@"watchCount"] = watchCount;
    params[@"bgImageUrl"] = imgUrl;
    params[@"isTest"] = @([WVRUserModel sharedInstance].isTest);
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[WVRRNConfig sharedInstance].gBridge moduleName:@"whaley_react_native" initialProperties:params];
    self.view = rootView;
}

- (void)addBlurBackgroundController {
    NSDictionary * dic = self.createArgs;
    NSString *imgUrl = dic[@"imgUrl"];
    
    if (!imgUrl) { return; }
    
    // 模糊背景图
    WVRBlurBackgroundController *blurC = [[WVRBlurBackgroundController alloc] initWithDelegate:nil];
    
    NSDictionary *dict = @{ @"parentView":[self view], @"imgUrl":imgUrl };
    [blurC addControllerWithParams:dict];
}

- (void)backForResult:(id)info resultCode:(NSInteger)resultCode{
    
    [self.backDelegate backForResult:info resultCode:resultCode];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self presentingViewController]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (BOOL)prefersStatusBarHidden {
    
    return self.hiddenStatusBar;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (void)requestForDetailData {
    
    NSDictionary * dic = self.createArgs;
    NSString * liveCode = dic[@"pragramCode"];
    if (liveCode) {
        
        self.gLiveDetailViewModel.code = liveCode;
        [self.gLiveDetailViewModel.gDetailCmd execute:nil];
    }
}

// MARK: - BI

- (NSString *)currentPageId {
    
    return @"liveEnd";
}
/// 电视猫电影电视剧已经重写此字段
- (NSString *)videoFormat {
    
    return self.detailModel.videoType;
}

/// 电视猫电影电视剧已经重写此字段
- (NSString *)biPageName {
    
    return self.detailModel.title;
}

/// 电视猫电影电视剧已经重写此字段
- (NSString *)biPageId {
    
    return self.detailModel.sid;
}

- (NSString *)biContentType {
    
    return self.detailModel.type;
}

- (int)biIsChargeable {
    
    return self.detailModel.isChargeable;
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

- (WVRLiveDetailViewModel *)gLiveDetailViewModel
{
    if (!_gLiveDetailViewModel) {
        _gLiveDetailViewModel = [[WVRLiveDetailViewModel alloc] init];
    }
    return _gLiveDetailViewModel;
}

- (void)setupRequestRAC {
    
    @weakify(self);
    [[self.gLiveDetailViewModel gSuccessSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self liveDetailSuccessBlock:x];
    }];
}

- (void)liveDetailSuccessBlock:(WVRLiveItemModel *)model
{
    if (!model) {
        // 节目已经失效 不处理
    } else {
        self.detailModel = model;
        [WVRProgramBIModel trackEventForBrowsePage:[self biModel]];
    }
}

@end

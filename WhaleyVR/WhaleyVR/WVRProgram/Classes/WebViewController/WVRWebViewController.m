//
//  WVRWebViewController.m
//  VRManager
//
//  Created by Snailvr on 16/7/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRWebViewController.h"
#import <WebKit/WebKit.h>
#import "WVRUMShareView.h"
#import "YYModel.h"
#import <SDWebImage/HUPhotoBrowser.h>
#import "WVRUserModel.h"
//#import "WVRItemModel.h"
#import "WVRGotoNextTool.h"
#import "NSDictionary+Extension.h"
//#import "WVRRewardController.h"

#import "WVRMediator+AccountActions.h"

#import "WVRMediator+ProgramActions.h"
#import "UIViewController+HUD.h"
#import "WVRAppContextHeader.h"

#import "WVRUploadViewCountHandle.h"
#import "WVRProgramBIModel.h"

@interface WVRWebViewController ()

@end


@implementation WVRWebViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self uploadViewCount];
    [self drawUI];
    [self registerObserverEvent];
    
    if (_isNews) {
        [self addRightBarBtnShare];
    }
}

- (void)createNavBar {
    
    WVRDetailNavigationBar *bar = [[WVRDetailNavigationBar alloc] init];
    bar.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:bar];
    self.navBar = bar;
    
    [self navShareSetting];
}

- (void)navShareSetting {
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIImage *backimage = [[UIImage imageNamed:@"icon_manual_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    item.leftBarButtonItems = @[ backItem ];
    
    UIImage *image = [[UIImage imageNamed:@"icon_video_detail_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *ShareItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarShareItemClick)];
    
    item.rightBarButtonItems = @[ ShareItem ];
    
    [self.navBar pushNavigationItem:item animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.needHideNav animated:YES];
    
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.webView execSend:kExecPageResume withPayload:@{ @"status" : @1 }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.webView execSend:kExecPagePause withPayload:@{ @"status" : @1 }];
    
    if (!self.navigationController) {
        [self hideProgress];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self.webView onBackForDestroy];
    }
}

- (void)drawUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_isNews && [self.URLStr containsString:@"topBarTransparent=1"]) {
        self.topBarTransparent = YES;
        self.needHideNav = YES;
    }
    
    CGRect rect = (self.needHideNav) ? self.view.bounds : CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight);
    
    WVRWebViewUseType type = WVRWebViewUseTypeHybrid;
    if (self.isNews) { type = WVRWebViewUseTypeNews; }
    
    WVRWebView *webView = [[WVRWebView alloc] initWithFrame:rect URL:[self realURLStr] params:nil liveParam:nil useType:type];
    webView.realDelegate = self;
    webView.allowsInlineMediaPlayback = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    
    if (self.needHideNav) {
        [self createNavBar];
    }
    [self showProgress];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)startLoadRequest {
    
    [self.webView reloadWithURL:[self realURLStr]];
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    
    DDLogInfo(@"%@ dealloc", self);
    
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

#pragma mark - Notification

- (void)registerObserverEvent {      // 界面"暂停／激活"事件注册
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWebShareDoneNotification:) name:kWebShareDoneNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    
    [self.webView execSend:kExecPageResume withPayload:@{ @"status" : @1 }];
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    
    [self.webView execSend:kExecPagePause withPayload:@{ @"status" : @1 }];
}

#pragma mark - getter

- (NSString *)realURLStr {
    
    if (_isNews) {
        return self.URLStr;
    }
    
    NSString *realURL = [self.URLStr stringByRemovingPercentEncoding];
    realURL = [realURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return realURL;
}

#pragma mark - request

// 上传播放记录 request

- (void)uploadViewCount {
    
    if (_isNews) {
        
        [WVRUploadViewCountHandle uploadViewInfoWithCode:self.code programType:@"webpage" videoType:@"vr" type:@"view" sec:nil title:self.title];
    }
}

#pragma mark - setter

- (void)setLoadOver:(BOOL)loadOver {
    
    _loadOver = loadOver;
    
    if (loadOver) { [self hideProgress]; }
}

#pragma mark - WVRWebViewDelegate

- (void)webViewDidLoad {

    [self hideProgress];
}

- (void)webViewLoadFail {
    
    [self networkFaild];
}

- (void)actionOnExit {
    
    [self exitPage];
}

- (void)actionSetIsHybridPage:(BOOL)isHybrid {
    
    self.isHybridPage = isHybrid;
    self.webView.scrollView.bounces = NO;
    
    if (self.topBarTransparent) {
        [self addRightBarBtnShare];
    }
}

- (NSString *)actionGetLoginInfo {
    
    NSString *info = @"";
    WVRUserModel *model = [WVRUserModel sharedInstance];
    if (model.isisLogined) {
        
        NSDictionary *dict = [self convertUserInfo:model];
        info = [dict toJsonString];
    }
    return info;
}

- (void)actionToLoginWithCallbackId:(NSString *)callbackId {
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            
            NSDictionary *dict = [self convertUserInfo:[WVRUserModel sharedInstance]];
            [self.webView execSend:callbackId withPayload:dict];
            
            return nil;
        }];
    }];
    
    RACCommand *cancelCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self.webView execSend:callbackId withPayload:@{}];
            
            return nil;
        }];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"completeCmd"] = cmd;
    dict[@"cancelCmd"] = cancelCmd;
    
    [[WVRMediator sharedInstance] WVRMediator_CheckAndToLogin:dict];
}

- (void)actionSetIsLoadOver {
    
    [self setLoadOver:YES];
}

- (void)actionShowImages:(NSDictionary *)imagesDict {
    
    [self showImages:imagesDict];
}

- (void)actionShareWithInfo:(NSDictionary *)shareInfo callbackId:(NSString *)callbackId {
    
    self.shareCallBackId = callbackId;
    [self action_share:shareInfo];
}

- (void)actionJumpPageWithInfo:(NSDictionary *)infoDict {
    
    [[WVRMediator sharedInstance] WVRMediator_gotoNextVC:infoDict];
}

- (void)actionJumpToInsideWebPage:(NSDictionary *)infoDict {
    
    [self jumpToInsideWebPage:infoDict];
}

- (void)actionDoHttpRequest:(WVRWebRequest *)webRequest {
    
    [self executeRequest:webRequest];
}

- (void)actionGoGiftPage {
    
    UIViewController *vc = [[WVRMediator sharedInstance] WVRMediator_RewardViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionJump:(NSDictionary *)itemModelDic {
    
    [[WVRMediator sharedInstance] WVRMediator_gotoNextVC:itemModelDic];
}

#pragma mark - exec

- (void)sendHttpResonse:(WVRWebRequest *)request withData:(NSString *)data code:(int)code isFromCache:(BOOL)fromCache {
    
    NSMutableDictionary *response = [NSMutableDictionary dictionary];
    
    [response setValue:@(code) forKey:@"code"];
    [response setValue:@(fromCache) forKey:@"fromCache"];
    [response setValue:(code == 0) ? @"null" : data forKey:@"msg"];
    [response setValue:(code == 0) ? data : @"null" forKey:@"data"];
    
    [self.webView execSend:request.callbackId withPayload:[response copy]];
}

- (void)executeRequest:(WVRWebRequest *)webReq {
    
    NSString *url = webReq.requestModel.url;
    NSString *func = webReq.requestModel.method;
    
    kWeakSelf(self);
    
    [WVRWebRequest executeRequest:func URL:url withParams:[self getBodyParam:webReq] completionBlock:^(id responseObj, NSError *error) {
        
        if (!error) {
            
            [weakself sendHttpResonse:webReq withData:responseObj code:0 isFromCache:NO];
            
        } else {
            
            [weakself sendHttpResonse:webReq withData:error.description code:1 isFromCache:NO];
        }
    }];
}

- (NSDictionary *)getBodyParam:(WVRWebRequest *)request {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSArray *paramArray = request.requestModel.params;
    
    for (int i = 0; i < [paramArray count]; i ++) {
        NSString *param = [paramArray objectAtIndex:i];
        NSArray *parray = [param componentsSeparatedByString:@"="];
        if ([parray count] < 2) {
            continue;
        }
        [paramDic setValue:parray[1] forKey:parray[0]];
    }
    
    return [paramDic copy];
}

- (void)action_share:(NSDictionary *)params {
    
    NSDictionary *dict = params;
    
//        1表示QQ
//        2表示Weibo
//        3表示微信
//        4表示微信朋友圈
//        5表示QQ空间
    int platform = [dict[@"platform"] intValue];
    NSString *title = dict[@"title"];
    NSString *url = dict[@"url"];
    NSString *imgUrl = dict[@"imgUrl"];
    NSString *desc = dict[@"desc"];
//    int mediaType = [dict[@"mediaType"] intValue];
    
    WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:self.view
                                                                   sID:nil
                                                               iconUrl:imgUrl
                                                                 title:title
                                                                 intro:desc
                                                              shareURL:url
                                                             shareType:WVRShareTypeH5];
    shareView.isH5CallShare = YES;
    shareView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        int idx = [self platformExchage:platform];
        [shareView shareToIndex:idx];
    }];
}

- (void)networkFaild {
    
    [self hideProgress];
    
    // 未有界面
    [self detailLoadFail:nil];
}

- (void)requestInfo {
    
    [self startLoadRequest];
}

#pragma mark - action

- (void)rightBarShareItemClick {
    
    WVRShareType type = _isNews ? WVRShareTypeNews : WVRShareTypeH5;
    
    UIViewController *rootVC = [UIViewController getCurrentVC_RootVC];
    
    self.shareV = [WVRUMShareView shareWithContainerView:rootVC.view
                                       sID:@""
                                   iconUrl:nil
                                     title:self.title
                                     intro:@""
                                  shareURL:self.URLStr
                                 shareType:type];
    
    kWeakSelf(self);
    self.shareV.clickBlock = ^(kSharePlatform platform) {
        
        if (platform != kSharePlatformLink && !weakself.isNews) {
            [WVRProgramBIModel trackEventForShare:[weakself biModel]];
        }
    };
}

- (void)jumpToInsideWebPage:(NSDictionary *)params {
    
    WVRWebViewController *vc = [[WVRWebViewController alloc] init];
    
    NSDictionary *titleBarModel = params[@"titleBarModel"];
    vc.title = titleBarModel[@"title"] ?: @"";
    vc.needHideNav = ([titleBarModel[@"type"] intValue] != 1);
    vc.URLStr = params[@"url"];
    vc.isNews = params[@"isNews"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showImages:(NSDictionary *)params {
    
    NSInteger idx = [params[@"index"] integerValue];
    
    NSArray *urls = params[@"imgs"];
    
    [HUPhotoBrowser showFromImageView:nil withURLStrings:urls placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:idx dismiss:nil];
}

#pragma mark - Notification

- (void)keyboardWillHide:(NSNotification *)noti {
    
    if (![self isCurrentViewControllerVisible]) {   // 保护
        return;
    }
    
    [self.webView execKeyboardHide:YES keyboardHeight:0];
}

- (void)receiveWebShareDoneNotification:(NSNotification *)noti {
    
    if (![self isCurrentViewControllerVisible]) {   // 保护
        return;
    }
    
    NSDictionary *dict = noti.userInfo;
    
    [self.webView execSend:_shareCallBackId withPayload:dict];
    
    _shareCallBackId = @"";
}

#pragma mark - BI

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.currentPageId = [self currentPageId];
    model.biPageId = [self biPageId];
    model.biPageName = [self biPageName];
    
    return model;
}

- (NSString *)currentPageId {
    
    return @"h5_inner";
}

- (NSString *)biPageId {
    
    return self.URLStr;
}

- (NSString *)biPageName {
    
    return self.title;
}

#pragma mark - 私有方法

- (void)addRightBarBtnShare {
    
    UIImage *image = [[UIImage imageNamed:@"icon_MA_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarShareItemClick)];
}

- (int)platformExchage:(int)webPlatform {
    
    if (webPlatform == 1) {
        return kSharePlatformQQ;
    } else if (webPlatform == 2) {
        
        return kSharePlatformSina;
    } else if (webPlatform == 3) {
        
        return kSharePlatformWechat;
    } else if (webPlatform == 4) {
        
        return kSharePlatformFriends;
    } else if (webPlatform == 5) {
        
        return kSharePlatformQzone;
    } else if (webPlatform == 6) {
        
        return kSharePlatformLink;
    }
    
    DDLogError(@"未约定的分享平台");
    return 0;
}

- (void)leftBarButtonClick {
    
    if (self.isLoadOver) {
        [self.webView execCaptureExit];
    } else {
        [self exitPage];
    }
}

// 退出当前界面 返回
- (void)exitPage {
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDictionary *)convertUserInfo:(WVRUserModel *)model {
    
    NSMutableDictionary *tokenDic = [NSMutableDictionary dictionary];
    tokenDic[@"accesstoken"] = model.sessionId;
    tokenDic[@"refreshtoken"] = model.refreshtoken;
    tokenDic[@"expiretime"] = model.expiration_time;
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    infoDic[@"deviceId"] = model.deviceId;
    infoDic[@"account_id"] = model.accountId;
    infoDic[@"nickname"] = model.username;
    infoDic[@"mobile"] = model.mobileNumber;
    infoDic[@"avatar"] = model.loginAvatar;
    infoDic[@"accessTokenBean"] = tokenDic;
    infoDic[@"isLoginUser"] = @(model.isisLogined);
    
    NSDictionary *dict = @{ @"user": infoDic,
                            @"status":@(1),
                            };
    
    return dict;
}

@end

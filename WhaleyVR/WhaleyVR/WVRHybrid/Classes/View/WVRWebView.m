//
//  WVRWebView.m
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/3.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRWebView.h"
#import "Jockey.h"
#import "YYModel.h"

#import "WVRUserModel.h"

#import "WVRReachabilityModel.h"

#import "NSDictionary+Extension.h"
#import "WVRAppContextHeader.h"
#import "WVRWidgetToastHeader.h"
#import "UIView+Extend.h"
#import "NSURL+Extend.h"
#import "NSString+Extend.h"

#import "WVRMediator+AccountActions.h"
#import "WVRGotoNextTool.h"

@interface WVRWebView ()<UIWebViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) NSDictionary *liveParam;

@property (nonatomic, strong) Jockey *jockey;

@property (nonatomic, assign) BOOL isTouchEnabel;       // YES 表示H5不接收此事件

@property (nonatomic, weak  ) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL gestrueValid;

@end


@implementation WVRWebView
@synthesize urlStr = _urlStr;
@synthesize useType = _useType;
@synthesize loadStatus = _loadStatus;

- (instancetype)init NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame URL:(NSString *)urlStr params:(NSDictionary *)param liveParam:(NSDictionary *)liveParam useType:(WVRWebViewUseType)useType {
    self = [super initWithFrame:frame];
    if (self) {
        
        _useType = useType;
        _urlStr = urlStr;
        _param = param;
        _liveParam = liveParam;
        
        _customCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" @#$%^&+=\\|[]{}:;\"?/<>,"] invertedSet];
        
        [self configSelf];
        
        [self registerJSEvent];
        [self startLoadRequest];
    }
    
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.frame = self.frame;
//}

- (void)reloadWithURL:(NSString *)url {
    
    _urlStr = url;
    
    [self configSelf];
    
    [self registerJSEvent];
    [self startLoadRequest];
}

- (void)onBackForDestroy {
    
    self.isDestroyed = YES;
    
    [self.jockey offAllEvent];
    self.jockey = nil;
}

#pragma mark - create UI

- (void)configSelf {
    
//    if (self.useType == WVRWebViewUseTypePlayer) {
//        
//        self.scrollView.delegate = self;
//        self.scrollView.bounces = NO;
//        self.scrollView.scrollEnabled = NO;
//        self.scrollView.showsVerticalScrollIndicator = NO;
//        
//        self.tag = 3001;        // for progress
//    }
    
    self.hidden = YES;
    self.delegate = self;
    self.scalesPageToFit = YES;
    self.backgroundColor = [UIColor clearColor];
    [self setOpaque:NO];
    
    // web播放全景视频
    self.allowsInlineMediaPlayback = true;
    self.mediaPlaybackRequiresUserAction = NO;
    
    // 设置UA标识
    if (_useType != WVRWebViewUseTypeNormal) {
        [WVRUserModel registUAForWebView];
    }
}

- (void)startLoadRequest {
    
    [self webViewLoadRequest:_urlStr];
}

- (void)webViewLoadRequest:(NSString *)URLStr {
    
    NSString *finalStr = URLStr;
    
    if (self.useType == WVRWebViewUseTypeHybrid) {
        
        NSString *params = @"";
        if (_param) {
            params = [[_param toJsonString] stringByAddingPercentEncodingWithAllowedCharacters:_customCharacterSet];
            params = [NSString stringWithFormat:@"vrplayer=%@", params];
        }
        if (_liveParam) {
            NSString *liveParam = [[_liveParam toJsonString] stringByAddingPercentEncodingWithAllowedCharacters:_customCharacterSet];
            NSString *str = params.length > 0 ? @"&" : @"";
            params = [NSString stringWithFormat:@"%@%@vrlive=%@", params, str, liveParam];
        }
        NSString *commenParam = [WVRUserModel hybridWebParams];
        
        // 此处 # 不能进行utf8编码操作
        NSString *str = params.length > 0 ? @"&" : @"";
        finalStr = [NSString stringWithFormat:@"%@#?%@%@%@", URLStr, params, str, commenParam];
    }
    
    NSLog(@"wvr_finalStr: %@", finalStr);
    NSURL *jsURL = [NSURL URLWithString:finalStr];
    
    [self loadRequest:[NSURLRequest requestWithURL:jsURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60]];
}

#pragma mark - 注册事件

- (void)registerJSEvent {
    
    _jockey = [[Jockey alloc] init];
    
    if (self.useType == WVRWebViewUseTypeHybrid) {
        
        [self registkExecExit];
        [self registkExecToast];
        [self registkExecLoadingPage];
        [self registkExecGetLoginUserInfo];
        [self registkExecLogin];
        [self registkRefreshToken];
        [self registkExecShowImages];
        [self registkExecShare];
        [self registkExecCopyToClipboard];
        [self registkExecGoPage];
        [self kExecGoPlatePage];
        [self registkExecGoContentPage];
        [self registkExecOpenVideo];
        [self registkExecGoInsideBrowser];
        [self registkExecGoOutsideBrowser];
        [self registkExecDoHttpRequest];
        [self registkExecGetAppClientInfo];
        [self registkExecGoGiftPage];
        [self registkExecCompleteLoadingPage];
        
//        [self registkExecShowDialog];
//        [self registkExecScanQRCode];
    }
}

- (void)registkExecExit {
    kWeakSelf(self);
    
    [_jockey on:kExecExit perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionOnExit)]) {
            [weakself.realDelegate actionOnExit];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecToast {
    
    [_jockey on:kExecToast perform:^(NSDictionary *payload) {
        
        NSString *text = payload[@"message"];
        SQToastInKeyWindow(text);
    }];
}

- (void)registkExecLoadingPage {
    kWeakSelf(self);
    
    [_jockey on:kExecLoadingPage perform:^(NSDictionary *payload) {
        
        [weakself setHidden:NO];
        [weakself.jockey off:kExecLoadingPage];
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionSetIsHybridPage:)]) {
            [weakself.realDelegate actionSetIsHybridPage:YES];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecCompleteLoadingPage {
    kWeakSelf(self);
    
    [_jockey on:kExecCompleteLoadingPage perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionSetIsLoadOver)]) {
            
            [weakself.realDelegate actionSetIsLoadOver];
            
        } else { DebugLog(@"func haven't implementation"); }
        
        [_jockey off:kExecCompleteLoadingPage];
    }];
}

- (void)registkExecGetLoginUserInfo {
    kWeakSelf(self);
    
    [_jockey on:kExecGetLoginUserInfo performAsync:^(UIWebView *webView, NSDictionary *payload, void (^complete)(NSString *json)) {
        
        WVRUserModel *model = [WVRUserModel sharedInstance];
        if (model.isisLogined) {
            
            NSString *str = @"";
            if ([weakself.realDelegate respondsToSelector:@selector(actionGetLoginInfo)]) {
                str = [weakself.realDelegate actionGetLoginInfo];
            } else { DebugLog(@"func haven't implementation"); }
            
            complete(str);
        } else {
            complete(@"");
        }
    }];
}

- (void)registkExecLogin {
    kWeakSelf(self);
    
    [_jockey on:kExecLogin performAsync:^(UIWebView *webView, NSDictionary *payload, void (^complete)(NSString *json)) {
        
        NSString *callbackId = payload[@"callbackId"];
        if ([weakself.realDelegate respondsToSelector:@selector(actionToLoginWithCallbackId:)]) {
            [weakself.realDelegate actionToLoginWithCallbackId:callbackId];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkRefreshToken {
    
    kWeakSelf(self);
    [_jockey on:kRefreshToken performAsync:^(UIWebView *webView, NSDictionary *payload, void (^complete)(NSString *json)) {
        
        NSString *callbackId = payload[@"callbackId"];
        [weakself refreshTokenForCallbackId:callbackId];
    }];
}

- (void)registkExecShowImages {
    kWeakSelf(self);
    
    [_jockey on:kExecShowImages perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionShowImages:)]) {
            [weakself.realDelegate actionShowImages:payload];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecShare {
    kWeakSelf(self);
    
    [_jockey on:kExecShare perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionShareWithInfo:callbackId:)]) {
            
            NSString *callBackId = payload[@"callbackId"];
            NSDictionary *info = payload[@"data"];
            [weakself.realDelegate actionShareWithInfo:info callbackId:callBackId];
        } else { DebugLog(@"func haven't implementation"); }
//        [weakself action_share:payload[@"data"]];
    }];
}

//- (void)registkExecShowDialog {
//    kWeakSelf(self);
//    
//    [_jockey on:kExecShowDialog perform:^(NSDictionary *payload) {
//        
//        [UIAlertController alertMessage:<#(NSString *)#> viewController:<#(UIViewController *)#>];
//    }];
//}

- (void)registkExecCopyToClipboard {
    
    [_jockey on:kExecCopyToClipboard performAsync:^(UIWebView *webView, NSDictionary *payload, void (^complete)(NSString *json)) {
        
        UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
        
        pastboad.string = payload[@"text"];
        
        complete(@"{status:1}");
    }];
}

- (void)registkExecGoPage {
//    kWeakSelf(self);
    
//    [_jockey on:kExecGoPage perform:^(NSDictionary *payload) {
//
//
//    }];
}

- (void)kExecGoPlatePage {
    kWeakSelf(self);
    
    [_jockey on:kExecGoPlatePage perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionJumpPageWithInfo:)]) {
            [weakself.realDelegate actionJumpPageWithInfo:payload[@"goPlatePageModel"]];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecGoContentPage {
    kWeakSelf(self);
    
    [_jockey on:kExecGoContentPage perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionJumpPageWithInfo:)]) {
            [weakself.realDelegate actionJumpPageWithInfo:payload[@"goContentPageModel"]];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecOpenVideo {
//    kWeakSelf(self);
    
    [_jockey on:kExecOpenVideo perform:^(NSDictionary *payload) {
        
        // beta 暂时未用到
//        NSDictionary *model = payload[@"mediaModel"];
//        
//        UIViewController *vc = weakself.wvr_viewController;
//        WVRPlayerToolModel * tModel = [[WVRPlayerToolModel alloc] init];
//        tModel.title = model[@"title"];
//        tModel.type = WVRVideoStreamTypeWeb;
//        tModel.detailType = [model[@"type"] intValue];
//        tModel.sid = model[@"title"];
//        tModel.playURL = model[@"mediaUrl"];
//        tModel.iconURL = model[@"imgUrl"];
//        tModel.resourceCode = model[@"resourceCode"];
//        
//        tModel.nav = vc.navigationController;
//        [WVRPlayerTool showPlayerControllerWith:tModel];
    }];
}

- (void)registkExecGoInsideBrowser {
    kWeakSelf(self);
    
    [_jockey on:kExecGoInsideBrowser perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionJumpToInsideWebPage:)]) {
            [weakself.realDelegate actionJumpToInsideWebPage:payload[@"webModel"]];
        } else { DebugLog(@"func haven't implementation"); }
        //        [weakself jumpToInsideWebPage:payload[@"webModel"]];
    }];
}

- (void)registkExecGoOutsideBrowser {
    
    [_jockey on:kExecGoOutsideBrowser perform:^(NSDictionary *payload) {
        
        NSDictionary *dict = payload[@"webModel"];
        NSString *url = dict[@"url"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithUTF8String:url]];
    }];
}

- (void)registkExecDoHttpRequest {
    kWeakSelf(self);

    [_jockey on:kExecDoHttpRequest perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionDoHttpRequest:)]) {
            
            WVRWebRequest *webReq = [WVRWebRequest yy_modelWithDictionary:payload[@"data"]];
            webReq.callbackId = payload[@"callbackId"];
            [weakself.realDelegate actionDoHttpRequest:webReq];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecGetAppClientInfo {
    
    [_jockey on:kExecGetAppClientInfo performAsync:^(UIWebView *webView, NSDictionary *payload, void (^complete)(NSString *json)) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        infoDic[@"platform"] = @"ios";
        infoDic[@"versionCode"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        infoDic[@"deviceId"] = [WVRUserModel sharedInstance].deviceId;
        
        NSDictionary *dict = @{ @"callbackPayload" : infoDic };
        NSString *str = [dict toJsonString];
        
        complete(str);
    }];
}

//- (void)registkExecScanQRCode {
//    
//    [_jockey on:kExecScanQRCode perform:^(NSDictionary *payload) {
//        //    eventName: $callbackId
//        //
//        //    responsePayload: {
//        //    status: 1 // 0失败，1成功，2取消
//        //    code: '' // 扫描结果字符串
//        //    }
//    }];
//}

- (void)registkExecGoGiftPage {
    
    kWeakSelf(self);
    [_jockey on:kExecGoGiftPage perform:^(NSDictionary *payload) {
        
        if ([weakself.realDelegate respondsToSelector:@selector(actionGoGiftPage)]) {
            
            [weakself.realDelegate actionGoGiftPage];
        } else { DebugLog(@"func haven't implementation"); }
    }];
}

- (void)registkExecRegisterNetworkStatusChange {
    kWeakSelf(self);
    [_jockey on:kExecRegisterNetworkStatusChange perform:^(NSDictionary *payload) {
        [weakself execNetworkStatusChanged];
    }];
}

#pragma mark - private func

- (void)refreshTokenForCallbackId:(NSString *)callbackId {
    
    @weakify(self);
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"status"] = @([WVRUserModel sharedInstance].isLogined);
            param[@"accessToken"] = [WVRUserModel sharedInstance].sessionId;
            [self execSend:callbackId withPayload:param];
            return nil;
        }];
    }];
    NSDictionary *dict = @{ @"cmd": cmd, @"code": @"152" };
    [[WVRMediator sharedInstance] WVRMediator_RefreshToken:dict];
}

#pragma mark - 发送

- (void)execSend:(NSString *)callbackId withPayload:(NSDictionary *)payload {
    
    if (!callbackId.length) { return; }
    [self.jockey send:callbackId withPayload:payload toWebView:self];
}

//MARK: - Hybrid

- (void)execKeyboardHide:(BOOL)isHide keyboardHeight:(int)height {
    
    if (isHide) {
        [_jockey send:kExecKeyboardHide withPayload:@{} toWebView:self];
    } else {
        [_jockey send:kExecKeyboardShow withPayload:@{ @"height": @(height) } toWebView:self];
    }
}

- (void)execNetworkStatusChanged {
    
    int netStatu = 0;
    WVRReachabilityModel *model = [WVRReachabilityModel sharedInstance];
    if (model.isWifi) {
        netStatu = 1;
    } else if (model.isReachNet) {
        netStatu = 2;
    }
    [self execSend:kExecNetworkStatusChange withPayload:@{ @"networkState": @(netStatu) }];
}

- (void)execCaptureExit {
    
    [_jockey send:kExecCaptureExit withPayload:@{} toWebView:self];
}

#pragma mark - getter

- (NSString *)urlStr {
    
    return _urlStr;
}

#pragma mark - H5 交互（interation） UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString hasPrefix:@"whaleyvr://"]) {
        if ([request.URL.absoluteString hasPrefix:@"whaleyvr://forwardpage/recommend"]) {
            
            if ([self.realDelegate respondsToSelector:@selector(actionJump:)]) {
                NSString *query = request.URL.query;
                NSString *json = @"";
                NSInteger len = @"data=".length;
                if (query.length > len) {
                    json = [[query substringFromIndex:len] stringByRemovingPercentEncoding];
                }
                
                NSMutableDictionary * dic = [[json stringToDic] mutableCopy];
                if (!dic[@"playUrl"]) {
                    dic[@"playUrl"] = dic[@"videoUrl"];
                }
                
                [self.realDelegate actionJump:dic];
            }
        }else if ([request.URL.absoluteString hasPrefix:@"whaleyvr://forwardpage/setting/ui/redemption"]){
            WVRBaseModel * model = [[WVRBaseModel alloc] init];
            model.linkArrangeType = LINKARRANGETYPE_TICKET;
            [WVRGotoNextTool gotoNextVC:model nav:[UIViewController getCurrentVC].navigationController];
        }else if ([request.URL.absoluteString hasPrefix:@"whaleyvr://forwardpage/setting/ui/gift"]){
            WVRBaseModel * model = [[WVRBaseModel alloc] init];
            model.linkArrangeType = LINKARRANGETYPE_REWARD;
            [WVRGotoNextTool gotoNextVC:model nav:[UIViewController getCurrentVC].navigationController];
        }
        return NO;
    }
    
    return [_jockey webView:self withUrl:request.URL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    _loadStatus = WVRWebViewLoadStatusLoaded;
    
    [self hideProgress];
    self.hidden = NO;
    
    if ([self.realDelegate respondsToSelector:@selector(webViewDidLoad)]) {
        [self.realDelegate webViewDidLoad];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];      // 屏蔽webView的放大镜
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    DebugLog(@"%@", error.description);
    
    _loadStatus = WVRWebViewLoadStatusFailed;
    [self hideProgress];
    
    [_jockey offAllEvent];
    _jockey = nil;
    
    // 将webView移除，其他相关界面回归
    [self.realDelegate webViewLoadFail];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
}

@end


@implementation WVRWebPlayModel

@end

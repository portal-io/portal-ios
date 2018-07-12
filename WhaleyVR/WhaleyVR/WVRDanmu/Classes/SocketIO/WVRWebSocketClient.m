//
//  WVRWebSocketClient.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRWebSocketClient.h"

#import "WVRHttpUserAuth.h"
#import "WVRHttpRoomLogin.h"
#import "WVRWebSocketMsg.h"
#import "WVRRoomModel.h"
#import "WVRApiHttpDanmuSend.h"
//#import "WVRLoginTool.h"
#import "WVRAppContextHeader.h"
#import "WVRWidgetToastHeader.h"

#import "WVRHttpGuestUserAuth.h"
#import "WVRLoginModel.h"
#import "WVRWebSocketStatusHandle.h"

#define MAXCACHE_MSG_COUNT (10)
#define MAXSHOW_MSG_COUNT (5)

@import SocketIO;

@interface WVRWebSocketClient () {
    
    SocketIOClient * _socketIOClient;
    NSOperationQueue* _msgReceiveQueue;
}

@property (nonatomic, strong) WVRWebSocketConfig * gConfig;

@property (nonatomic, strong) WVRLoginModel * gLoginModel;
//@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray*> * gMsgDic;

@property (nonatomic, strong) NSMutableArray * gMsgArrays;

@property (nonatomic, assign) NSInteger gMsgIndex;

@property (nonatomic, strong) NSMutableArray * gSendMsgArrays;

@property (nonatomic, assign) NSInteger gSendMsgIndex;

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSNumber*> * gSocketStatusDic;

@property (nonatomic, assign) BOOL gIsAuthAfterLogin;

@property (nonatomic, strong) NSTimer * gShowMsgTimer;

@property (nonatomic, copy) void(^showMsgCallback)(WVRWebSocketMsg *msg);

@property (nonatomic, strong) WVRWebSocketStatusHandle * gStatusHandle;

@end


@implementation WVRWebSocketClient

+ (instancetype)shareInstance {
    
    static WVRWebSocketClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [WVRWebSocketClient new];
        client.gSocketStatusDic = [NSMutableDictionary new];
        client.gMsgArrays = [NSMutableArray new];
        client.gLoginModel = [WVRLoginModel new];
        
    });
    return client;
}

- (void)canConnectSocketBlock {
    
    self.gLoginModel.roomUserID = self.gConfig.authModel.authedUid;
    self.gLoginModel.roomId = self.gConfig.roomModel.roomId;
    self.gLoginModel.roomauth = self.gConfig.roomModel.roomauth;
    [self setUpSocketIO:self.gConfig.programId];
}

- (void)connectWithConfig:(WVRWebSocketConfig *)config showMsgBlock:(void(^)(WVRWebSocketMsg *msg))receiveMsgCallback {
    
    if (self.gSocketStatus == WVRWebSocketClientStatusOpen) {
        return;
    }
    
    _gSocketStatus = WVRWebSocketClientStatusOpen;
    self.gSocketStatusDic[config.programId] = @(0);
    self.showMsgCallback = receiveMsgCallback;
    self.gConfig = config;
    if (!self.gStatusHandle) {
        self.gStatusHandle = [WVRWebSocketStatusHandle new];
    }
    kWeakSelf(self);
    self.gStatusHandle.canConnectSocketBlock = ^{
        [weakself canConnectSocketBlock];
    };
    [self.gStatusHandle prepareForConnect:config];
    [self setupTimer];
}

- (void)closeWithProgramId:(NSString *)programId {
    if (programId.length<=0) {
        return;
    }
    self.gSocketStatusDic[programId] = @(1);
    [self.gMsgArrays removeAllObjects];
    _gSocketStatus = WVRWebSocketClientStatusClose;
//    [WVRUserModel sharedInstance].gShowUserAuthSuccess = NO;
    [self invalidTimer];
    self.gMsgIndex = 0;
    [_socketIOClient disconnect];
    _socketIOClient = nil;
    _showMsgCallback = nil;
    _gStatusHandle = nil;
}

- (void)authAfterLogin {
    
    self.gIsAuthAfterLogin = YES;
    [self.gStatusHandle prepareForConnect:self.gConfig];
}

- (void)loginSocket:(WVRLoginModel*)loginModel {
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"roomid"] = loginModel.roomId;
    params[@"uid"] = loginModel.roomUserID;
    params[@"auth"] = loginModel.roomauth;
    [_socketIOClient emit:@"login" with:@[params]];
}

- (void)setUpSocketIO:(NSString*)programId {
    
    if ([self.gSocketStatusDic[programId] boolValue] && !self.gIsAuthAfterLogin) {
        DDLogInfo(@"have call closeWithProgramId:%@", programId);
        return;
    }
    kWeakSelf(self);
    [_socketIOClient disconnect];
    _socketIOClient = nil;
    NSString * urlStr = [NSString stringWithFormat:@"ws://%@:%@", self.gConfig.roomModel.host, self.gConfig.roomModel.port];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithDictionary:@{ @"log":@(1), @"forcePolling":@(1) }];
    config[@"cookies"] = cookies;
    
    SocketIOClient * socketIO = [[SocketIOClient alloc] initWithSocketURL:[NSURL URLWithString:urlStr] config:config];
    [socketIO on:@"connect" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO connect");
        [weakself loginSocket:weakself.gLoginModel];
    }];
    [socketIO on:@"disconnect" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO disconnect");
    }];
    [socketIO on:@"open" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO open");
    }];
    [socketIO on:@"danmaku" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO danmaku");
        [weakself danma_callback:dataArray];
    }];
    [socketIO on:@"vr_gift_user_give" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"vr_gift_user_give");
        if (self.receiveGiftMsgCallback) {
            self.receiveGiftMsgCallback([dataArray firstObject]);
        }
        
    }];
    [socketIO on:@"connect_error" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO connect_error");
    }];
    [socketIO on:@"message" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO message should login");
        [weakself msg_callback:dataArray];
    }];
    /*[notice, {
     color = "#00ffab";
     dmid = 19789;
     duration = 30;
     message = "\U8d1d\U8d1d";
     nickname = "\U7ba1\U7406\U5458";
     "response_dateline" = 1494988618;
     roomid = 11;
     }]; id: -1; placeholders: -1; nsp: /}*/
    [socketIO on:@"notice" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO notice");
        [weakself top_msg_callback:dataArray];
    }];
    [socketIO on:@"disnotice" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO disnotice");
        [weakself topDismiss_msg_callback:dataArray];
    }];
    [socketIO on:@"userbanned" callback:^(NSArray * _Nonnull dataArray, SocketAckEmitter * _Nonnull ack) {
        DDLogInfo(@"socketIO userbanned");
        [weakself userbanned_msg_callback:dataArray];
    }];
    
    [socketIO connect];
    _socketIOClient = socketIO;
}

- (void)userbanned_msg_callback:(NSArray*)dataArray
{
    if (dataArray.count>0) {
        NSDictionary * dic = dataArray[0];
        NSString * uid = dic[@"uid"];
        NSString * nickname = dic[@"nickname"];
        NSString * type = dic[@"type"];
//        NSString * roomid = dic[@"roomid"];
        NSString * duration = dic[@"duration"];
        NSString * messge = dic[@"messge"];
        WVRWebSocketMsg * webSocketMsg = [WVRWebSocketMsg new];
//        webSocketMsg.msgTime = [NSString stringWithFormat:@"%@",time? time:@""];
//        webSocketMsg.msgId = [NSString stringWithFormat:@"%@",msgId? msgId:@""];
        webSocketMsg.content = [NSString stringWithFormat:@"%@",messge? messge:@""];;
        webSocketMsg.msgType = [self parserMsgType:[[NSString stringWithFormat:@"%@",type? type:@""] integerValue]];
        webSocketMsg.userBannedMsg = [WVRWebSocketUserbannedMsg new];
        webSocketMsg.userBannedMsg.userId = [NSString stringWithFormat:@"%@",uid? uid:@""];
        webSocketMsg.userBannedMsg.nickname = [NSString stringWithFormat:@"%@",nickname? nickname:@""];
        webSocketMsg.userBannedMsg.duration = [NSString stringWithFormat:@"%@",duration? duration:@""];
        if (self.gMsgArrays.count>MAXCACHE_MSG_COUNT) {
            [self.gMsgArrays removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MAXSHOW_MSG_COUNT)]];
            if (self.gMsgIndex>=MAXSHOW_MSG_COUNT) {
                self.gMsgIndex -= MAXSHOW_MSG_COUNT;
            }
        }
        [self.gMsgArrays addObject:webSocketMsg];
    }
}

- (WVRwebSocketMsgType)parserMsgType:(NSInteger)httpMsgType
{
    WVRwebSocketMsgType msgType = WVRwebSocketMsgTypeNormal;
    //(1:禁言 2:取消禁言 3:黑名单 4:取消黑名单)
    switch (httpMsgType) {
        case 1:
            msgType = WVRwebSocketMsgTypeUserBannedProhibitedWords;
            break;
        case 2:
            msgType = WVRwebSocketMsgTypeUserBannedUNProhibitedWords;
            break;
        case 3:
            msgType = WVRwebSocketMsgTypeUserBannedBlacklist;
            break;
        case 4:
            msgType = WVRwebSocketMsgTypeUserBannedUNBlacklist;
            break;
        default:
            break;
    }
    return msgType;
}

- (void)danma_callback:(NSArray*)dataArray {
    
    if (dataArray.count>0) {
        NSDictionary * dic = dataArray[0];
        NSDictionary * danMDic = dic[@"danmakudata"];
        NSString * time = danMDic[@"dateline"];
        NSString * msgId = danMDic[@"dmid"];
        NSString * msg = danMDic[@"message"];
        NSString * senderName = danMDic[@"nickname"];
        NSString * senderUid = danMDic[@"uid"];
        NSInteger msgType = [danMDic[@"type"] integerValue];
        NSString * color = danMDic[@"color"];
        WVRwebSocketMsgType type = WVRwebSocketMsgTypeNormal;
        if (msgType==2) {
            type = WVRwebSocketMsgTypeManager;
        }
        WVRWebSocketMsg * webSocketMsg = [WVRWebSocketMsg new];
        webSocketMsg.msgTime = [NSString stringWithFormat:@"%@",time? time:@""];
        webSocketMsg.msgId = [NSString stringWithFormat:@"%@",msgId? msgId:@""];
        webSocketMsg.content = [NSString stringWithFormat:@"%@",msg? msg:@""];;
        webSocketMsg.senderNickName = [NSString stringWithFormat:@"%@",senderName? senderName:@""];
        webSocketMsg.senderUid = [NSString stringWithFormat:@"%@",senderUid? senderUid:@""];
        webSocketMsg.msgType = type;
        webSocketMsg.colorStr = color;
        if (self.gMsgArrays.count > MAXCACHE_MSG_COUNT) {
            [self.gMsgArrays removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MAXSHOW_MSG_COUNT)]];
            if (self.gMsgIndex >= MAXSHOW_MSG_COUNT) {
                self.gMsgIndex -= MAXSHOW_MSG_COUNT;
            }
        }
        [self.gMsgArrays addObject:webSocketMsg];
    } else {
        DDLogInfo(@"socketIO 弹幕消息未识别");
    }
}

- (void)msg_callback:(NSArray *)dataArray {
    
    if (dataArray.count > 0) {
        NSDictionary * dic = dataArray[0];
        NSString * time = dic[@"response_dateline"];
        NSString * status = dic[@"status"];
        NSString * msg = dic[@"message"];
        WVRWebSocketMsg * webSocketMsg = [WVRWebSocketMsg new];
        webSocketMsg.msgTime = time;
        webSocketMsg.status = status;
        webSocketMsg.content = msg;
        if ([status integerValue] == 1) {
            DDLogInfo(@"socketIO 登录成功");
            [WVRUserModel sharedInstance].showRoomUserID = self.gLoginModel.roomUserID;
            if ([WVRUserModel sharedInstance].isLogined) {
//                [WVRUserModel sharedInstance].gShowUserAuthSuccess = YES;
                if (self.gIsAuthAfterLogin) {
//                    SQToastInKeyWindow(@"已登录，快来发弹幕吧...");
                    self.gIsAuthAfterLogin = NO;
                }
            }
            [self.gMsgArrays addObject:self.gConfig.roomModel.noticeMsg];
        } else {
            DDLogError(@"socketIO 登录失败");
        }
    } else {
        DDLogError(@"socketIO 消息未识别");
    }
}

- (void)top_msg_callback:(NSArray*)dataArray {
    
    if (dataArray.count > 0) {
        NSDictionary * dic = dataArray[0];
        NSString * color = dic[@"color"];
        NSString * duration = dic[@"duration"];
        NSString * msg = dic[@"message"];
        WVRwebSocketMsgType msgType = WVRwebSocketMsgTypeTop;
        WVRWebSocketMsg * webSocketMsg = [WVRWebSocketMsg new];
        webSocketMsg.msgStayDuration = [NSString stringWithFormat:@"%@", duration? duration: @""];
        webSocketMsg.content = [NSString stringWithFormat:@"%@", msg? msg: @""];;
        webSocketMsg.msgType = msgType;
        webSocketMsg.colorStr = color;
        if (self.gMsgArrays.count>MAXCACHE_MSG_COUNT) {
            [self.gMsgArrays removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MAXSHOW_MSG_COUNT)]];
            if (self.gMsgIndex>=MAXSHOW_MSG_COUNT) {
                self.gMsgIndex -= MAXSHOW_MSG_COUNT;
            }
        }
        [self.gMsgArrays addObject:webSocketMsg];
    } else {
        DDLogInfo(@"socketIO 弹幕消息未识别");
    }
}

- (void)topDismiss_msg_callback:(NSArray*)dataArray {
    
    if (dataArray.count>0) {
        WVRwebSocketMsgType msgType = WVRwebSocketMsgTypeTopDismiss;
        WVRWebSocketMsg * webSocketMsg = [WVRWebSocketMsg new];
        webSocketMsg.msgType = msgType;
        [self.gMsgArrays addObject:webSocketMsg];
    }else{
        DDLogInfo(@"socketIO 弹幕消息未识别");
    }
}

- (void)sendTextMsg:(NSString*)msg successBlock:(void(^)(void))successBlock {
    
    if (self.gSocketStatus != WVRWebSocketClientStatusOpen) {
        DDLogInfo(@"socketIO authAfterLogin发送弹幕");
        [self authAfterLogin];
        return;
    }
    BOOL canSendMsg = [self.gStatusHandle canSendMsg];
    if (canSendMsg) {
        [self http_danmSend:msg successBlock:successBlock];
    } else {
        DDLogInfo(@"socketIO 正在登录和进入房间...");
        
        [self.gStatusHandle prepareForConnect:self.gConfig];
    }
}

//websocket 链接登录成功后再允许发送弹幕
- (void)http_danmSend:(NSString*)msg successBlock:(void(^)(void))successBlock {
    
    WVRApiHttpDanmuSend *api = [[WVRApiHttpDanmuSend alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kWVRAPIParamsDanmuSend_roomid] = self.gConfig.roomModel.roomId;
    params[kWVRAPIParamsDanmuSend_message] = msg;
    api.bodyParams = params;
    api.successedBlock = ^(NSString *statusCode) {
        if ([statusCode isEqualToString:@"1"]) {
            successBlock();
        }
        else if ([statusCode isEqualToString:@"-2002"]) {
            SQToastInKeyWindow(@"没有登陆");
        }else if ([statusCode isEqualToString:@"-2005"]) {
            SQToastInKeyWindow(@"您已经被禁言");
        }else if ([statusCode isEqualToString:@"-2006"]) {
            SQToastInKeyWindow(@"您发送的弹幕字数超过了200字");
        }else if ([statusCode isEqualToString:@"-2008"]) {
            SQToastInKeyWindow(@"房间不存在");
        }else if ([statusCode isEqualToString:@"-2009"]) {
            SQToastInKeyWindow(@"房间因为违规已被关闭");
        }else if ([statusCode isEqualToString:@"-2044"]){
            SQToastInKeyWindow(@"弹幕包含敏感词");
        }else if([statusCode isEqualToString:@"-2043"]){
            SQToastInKeyWindow(@"你已被加入黑名单");
        }
        else{
            SQToastInKeyWindow(@"弹幕发到火星去了");
        }
    };
    api.failedBlock = ^(WVRNetworkingResponse *error) {
        SQToastInKeyWindow(kNoNetAlert);
    };
    [api loadData];
}

//- (void)showMsgOper
//{
////    while (1) {
//        if (self.gMsgIndex<self.gMsgArrays.count) {
//            if (self.showMsgCallback) {
//                self.showMsgCallback(self.gMsgArrays[self.gMsgIndex]);
//            }
//            self.gMsgIndex++;
//        }
//        if ([self.gSocketStatusDic[self.gConfig.programId] boolValue]) {
//            return;
//        }
////    }
//}

- (void)showMsg {
    
    if (self.gMsgIndex < self.gMsgArrays.count) {
        if (self.showMsgCallback) {
            self.showMsgCallback(self.gMsgArrays[self.gMsgIndex]);
        }
        self.gMsgIndex++;
    }
    if ([self.gSocketStatusDic[self.gConfig.programId] boolValue]) {
        return;
    }
//    kWeakSelf(self);
//    NSBlockOperation * blockOper = [NSBlockOperation blockOperationWithBlock:^{
//        [weakself showMsgOper];
//    }];
//    [blockOper start];

//    dispatch_queue_t serialQueue = dispatch_queue_create("serial_queue",
//                                                         DISPATCH_QUEUE_SERIAL);
////    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
//        dispatch_async(serialQueue, ^{
//            [self showMsgOper];
//        });

//    if (!_msgReceiveQueue) {
//        _msgReceiveQueue = [NSOperationQueue new];
//    }
//    
//    NSBlockOperation * blockOper = [NSBlockOperation blockOperationWithBlock:^{
    ////        dispatch_async(dispatch_get_main_queue(), ^{
    //            [weakself danma_callback:dataArray];
    ////        });

//    }];
//    [_msgReceiveQueue addOperation:blockOper];
}

#pragma mark - Notification

- (void)registerObserverEvent {      // 界面"暂停／激活"事件注册
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)appWillEnterBackground:(NSNotification *)notification {
    
    [self invalidTimer];
}

- (void)appWillResignActive:(NSNotification *)notification {
    [self invalidTimer];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    if (![self.gSocketStatusDic[self.gConfig.programId] boolValue]) {//未关闭时启动timer
        [self setupTimer];
    }
}
- (void)setupTimer {
    [self invalidTimer];
    if (!self.gShowMsgTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(showMsg) userInfo:nil repeats:YES];
        
        //将定时器加到循环池中
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        self.gShowMsgTimer = timer;
    }
}

- (void)invalidTimer {
    
    [self.gShowMsgTimer invalidate];
    self.gShowMsgTimer = nil;
}

@end

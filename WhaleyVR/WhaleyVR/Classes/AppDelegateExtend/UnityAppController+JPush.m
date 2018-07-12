//
//  UnityAppController+JPush.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "UnityAppController+JPush.h"
#import "WVRItemModel.h"

@interface UnityAppController()<JPUSHRegisterDelegate>

@end


@implementation UnityAppController(JPush)

- (void)initJPushSDKWithOptions:(NSDictionary *)launchOptions {

    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    BOOL isProduction = YES;
    
#if DEBUG
    isProduction = NO;
#endif
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)    // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = (UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else {
        
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }

    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:pAppKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    [JPUSHService setLogOFF];    // setLogOFF    // setDebugMode
    
    [self setTagsAlias];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToVCForJPush) name:NAME_NOTF_HANDLE_JPUSH_NOT object:nil];
 }

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"Device Token: %@", deviceToken);
    
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"registrationID = %@", [JPUSHService registrationID]);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - JPUSHRegisterDelegate  ios 10.x

// the app is in Foreground,
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    DDLogWarn(@"willPresentNotification: \n%@", userInfo);
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    } else {
        // 判断为本地通知
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// user touches the notification
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    DDLogWarn(@"didReceiveNotificationResponse: \n%@", userInfo);
    
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [JPUSHService resetBadge];
        self.gJPushModel = [self parserJPushInfo:userInfo];
        if ([WVRAppContext sharedInstance].gHomeDidAppear) {
            [self jumpToVCForJPush];
        } else {
            [self displayMainController];
        }
    } else {
        // 判断为本地通知
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - IOS 9.x

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    DDLogInfo(@"didReceiveRemoteNotification");
    
    [JPUSHService handleRemoteNotification:userInfo];
    [JPUSHService resetBadge];
    completionHandler(UIBackgroundFetchResultNewData);

    if (application.applicationState == UIApplicationStateActive) {
        
    } else if (application.applicationState == UIApplicationStateInactive) {
        
        self.gJPushModel = [self parserJPushInfo:userInfo];
        [self jumpToVCForJPush];
    }
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)setTagsAlias {
    
    NSString * userId = nil;
    if ([WVRUserModel sharedInstance].isLogined) {
        userId = [[WVRUserModel sharedInstance] accountId];
    }
    NSMutableSet *tags = [NSMutableSet set];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [tags addObject:[appCurVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"]];
    if (userId) {
        [tags addObject:userId];
    }
    // 延迟调用设置tag函数解决走不到回调函数的bug
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:tags alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            DDLogInfo(@"iResCode:%d----iAlias:%@---", iResCode, iAlias);
            DDLogInfo(@"ValidTags = %@", [JPUSHService filterValidTags:tags]);
        }];
    });
}

- (void)jumpToVCForJPush {
    
    if (self.gJPushModel) {
        [self displayMainController:self.gJPushModel];
        self.gJPushModel = nil;
    }
}

- (WVRItemModel *)parserJPushInfo:(NSDictionary *)dict
{
    // 判断类型 主页、详情页、H5、直播、专题
    WVRJPushMsgModel * msgModel = [WVRJPushMsgModel yy_modelWithDictionary:dict[@"extra"]];
    WVRItemModel *model = [[WVRItemModel alloc] init];
    switch (msgModel.msg_type) {
        case WVRJPushMsgTypeHome:
            model = nil;
            break;
        case WVRJPushMsgTypeLive:
            model.linkArrangeType = LINKARRANGETYPE_LIVE;
            model.linkArrangeValue = msgModel.msg_param;
            break;
        case WVRJPushMsgTypeDetail:
            [self parserDetail:model msgModel:msgModel];
            break;
        case WVRJPushMsgTypeH5:
            model.linkArrangeType = LINKARRANGETYPE_INFORMATION;
            model.linkArrangeValue = msgModel.msg_param;
            model.name = msgModel.title;
            break;
        case WVRJPushMsgTypeTopic:
            model.linkArrangeType = LINKARRANGETYPE_MANUAL_ARRANGE;
            model.linkArrangeValue = msgModel.msg_param;
            break;
        default:
            break;
    }
    return model;
}

- (void)parserDetail:(WVRItemModel*)model msgModel:(WVRJPushMsgModel *)msgModel
{
    switch (msgModel.msg_detail_type) {
        case WVRJPushMsgDetailTypeVR:
        case WVRJPushMsgDetailType2D:
        case WVRJPushMsgDetailType3D:
            model.linkArrangeType = LINKARRANGETYPE_PROGRAM;
            break;
        case WVRJPushMsgDetailTypeMoreTV:
            model.linkArrangeType = LINKARRANGETYPE_MORETVPROGRAM;
            break;
        case WVRJPushMsgDetailTypeMoreTVMOVIE:
            model.linkArrangeType = LINKARRANGETYPE_MOREMOVIEPROGRAM;
            break;
        case WVRJPushMsgDetailTypeDrama:
            model.linkArrangeType = LINKARRANGETYPE_DRAMA_PROGRAM;
            break;
        default:
            break;
    }
    
    model.linkArrangeValue = msgModel.msg_param;
}

@end


@implementation WVRJPushMsgModel

- (NSString *)msg_param
{
    if (_msg_type == WVRJPushMsgTypeH5) {
        NSArray* strs = [_msg_param componentsSeparatedByString:@"{"];
        return [strs firstObject];
    } else {
        NSArray* strs = [_msg_param componentsSeparatedByString:@"}"];
        return [strs lastObject];
    }
}

- (WVRJPushMsgDetailType)msg_detail_type
{
    if ([[self.msg_param substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"mm"]) {
        return WVRJPushMsgDetailTypeMoreTVMOVIE;
    } if ([[self.msg_param substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"mt"]) {
        return WVRJPushMsgDetailTypeMoreTV;
    } else {
        NSString * type = [_msg_param substringWithRange:NSMakeRange(0, 1)];
        return [type integerValue];
    }
}

- (NSString *)title
{
    if (_msg_type == WVRJPushMsgTypeH5) {
        NSArray* strs = [_msg_param componentsSeparatedByString:@"}"];
        return [strs lastObject];
    }else{
        NSArray* strs = [_msg_param componentsSeparatedByString:@"{"];
        return [strs firstObject];
    }
}

@end

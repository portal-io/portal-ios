//
//  UnityAppController+Extend.m
//  Unity-iPhone
//
//  Created by Bruce on 2017/1/23.
//
//

#import "UnityAppController+Extend.h"
#import "WVRSQLiteManager.h"
#import "AFNetworkActivityIndicatorManager.h"
//#import "WasuSafeKey.h"
#import <SecurityFramework/Security.h>
#import "WVREnterReportTool.h"
#import "WVRFilteredWebCache.h"
#import "UIView+Toast.h"
#import "WVRLaunchFlowManager.h"
#import "WVRSpring2018Manager.h"

#if (kAppEnvironmentLauncher == 1)
#import <IFlyMSC/IFlyMSC.h>
#endif

//NSString * const kJSPatchAppkey    = @"945b1581bff21023";
//NSString * const kJSPatchRSAPublicKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD80K20nSApomlQOTHllk+uvMfs\n3yH+16poeUBMIQrhO1VxLEVY3ZaJGAPCNF/q73XJve5nWn7GU3Qz9rlkdGMJsV4V\nZt+DovQbDRtF2Zw8HrS0EIVkYQCFYcCTdfnq1FQmtIyKxzsFU8jBbw/SE291vx/1\nIVko3++EsQthCF+1uQIDAQAB\n-----END PUBLIC KEY-----";


#define IFLY_APPID_VALUE           @"58341d6a"

@implementation UnityAppController (Extend)

- (void)configureThirdFrameworks {
    
    NSLog(@"\nNSHomeDirectory():   %@\n", NSHomeDirectory());
    
    [self configDLog];
    [self configReachability];
    
//    [WVRFilteredWebCache setDefauleCache];      // 播放器H5缓存更新逻辑
    
    wvr_configSDWebImage();             // SDWebImage 初始化配置
    
    [self configWasu];
    
    [self configIFly];
    
    [self playerParserInit];        // 解析库
//    [self initJSPatch];             // JSPatch
    
    [self configToast];
    
    [[SQCocoaHttpServerTool shareInstance] openHttpServer];         // 本地视频播放代理
    [WVRSQLiteManager sharedManager];                               // sqlite
    [self reportEnterApp];                                          // 上报接口
    
    [[WVRLaunchFlowManager shareInstance] buildData];
    
    [WVRSpring2018Manager checkForSpring2018Status];
    [WVRSpring2018Manager checkForSpringLeftCount];
}

// 讯飞语音输入初始化
- (void)configIFly {

#if (kAppEnvironmentLauncher == 1)
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", IFLY_APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
#endif
}

// open url
// [[IFlySpeechUtility getUtility] handleOpenURL:url];

- (void)configDLog {
    
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelAll];
//    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelWarning];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 30 * 24 * 60 * 60;
    fileLogger.maximumFileSize = 5 * 1024 * 1024;
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    
    [DDLog addLogger:fileLogger];
}

- (void)configReachability {
    
    // 初始化网络监测单例
    [WVRReachabilityModel sharedInstance];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 做第一次网络状态检测
    [WVRReachabilityModel setupReachability];
}

- (void)configWasu {
    
//    @try {
//        [WasuSafeKey saveSafeKey];          // 华数Movie
//
//    } @catch (NSException *exception) {
//
//        DDLogInfo(@"%@", exception.reason);
//    }
}

- (void)configToast {
    
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [CSToastManager setDefaultDuration:0.5];
    CSToastStyle *style = [CSToastManager sharedStyle];
    style.cornerRadius = 20;
    [CSToastManager setSharedStyle:style];
    
    [CSToastManager setQueueEnabled:YES];
}

//- (void)initJSPatch {
//    
////    [JSPatch testScriptInBundle];
////#ifdef DEBUG
////    [JSPatch setupDevelopment];
////#endif
//    [JSPatch startWithAppKey:kJSPatchAppkey];
//    [JSPatch setupRSAPublicKey:kJSPatchRSAPublicKey];
//}

- (void)playerParserInit {
    
    [[HttpAgent sharedInstance] start];
    //init security
    Security *sc = [Security getInstance];
    [sc Security_Init];
    [sc Security_SetUserID:@""];
}

- (void)reportEnterApp {
    
    BOOL isReport = [[WVRUserModel sharedInstance] isReport];
    if (!isReport) {
        [WVREnterReportTool startReport];
    }
}

@end

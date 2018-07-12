//
//  UnityAppController+UMeng.m
//  VRManager
//
//  Created by Wang Tiger on 16/6/22.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "UnityAppController+UMeng.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import <UMMobClick/MobClick.h>
#import "WVRUMShareView.h"

NSString * const kUmengAppkey    = @"57693bf9e0f55a09e20024d9";
NSString * const kWXAPP_ID       = @"wx451cc87ab867c81c";
NSString * const kWXAPP_SECRET   = @"a4fd98ac68407ef273695f6b5ef74969";
NSString * const kSinaAPP_ID     = @"3689115682";
NSString * const kSinaAPP_SECRET = @"f7a77155f368b015cd7e75ebd6201ab4";
NSString * const kQQ_ID          = @"1104445514";
NSString * const kQQ_SECRET      = @"fx5XKcruyuMewqxt";

//NSString * const kShareUrl = @"https://itunes.apple.com/us/app/vr-guan-jia/id963637613?l=zh&ls=1&mt=8";
//NSString * const kOpenAppStoreUrl = @"itms-apps://itunes.apple.com/us/app/vr-guan-jia/id963637613?l=zh&ls=1&mt=8";

@interface UnityAppController ()

@end


@implementation UnityAppController (UMeng)

- (void)initUMengSDK {
    //设置友盟社会化组件appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppkey];
    
    // U盟统计
    UMConfigInstance.appKey    = kUmengAppkey;
    UMConfigInstance.ePolicy   = SEND_INTERVAL;
    UMConfigInstance.channelId = @"App Store";
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setEncryptEnabled:YES];
    
    [MobClick startWithConfigure:UMConfigInstance];     // Umeng统计
    
    //打开调试log的开关
    [[UMSocialManager defaultManager] openLog:NO];
    
//#if (kAppEnvironmentTest == 1)
//    [MobClick setLogEnabled:YES];
//#endif

//#ifdef kAppEnvironmentTest
    // beta 未来这里要改掉
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
//#endif
    
    // 设置支持没有客户端情况下使用SSO授权
    [[UMSocialQQHandler defaultManager] setSupportWebView:YES];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAPP_ID appSecret:kWXAPP_SECRET redirectURL:kShareUrl];
    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQ_ID  appSecret:kQQ_SECRET redirectURL:kShareUrl];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSinaAPP_ID  appSecret:kSinaAPP_SECRET redirectURL:kSinaRedirectUrl];
}


@end

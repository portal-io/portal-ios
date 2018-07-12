//
//  WVRTrackEventMapping.m
//  WhaleyVR
//
//  Created by qbshen on 2016/10/29.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRTrackEventMapping.h"
#import <UMMobClick/MobClick.h>

NSString * const kEvent_recommendation = @"recommendation";
NSString * const kEvent_me = @"me";
NSString * const kEvent_register = @"register";
NSString * const kEvent_login = @"login";
NSString * const kEvent_smsLogin = @"smsLogin";
NSString * const kEvent_social = @"social";
NSString * const kEvent_information = @"information";

/*
 
 burial point*/
NSString * const kEvent_burialPoint_code = @"code";
NSString * const kEvent_burialPoint_next = @"next";

NSString * const kEvent_burialPoint_mobile = @"mobile";

NSString * const kEvent_register_burialPoint_qq = @"qq";
NSString * const kEvent_register_burialPoint_wechat = @"wechat";
NSString * const kEvent_register_burialPoint_weibo = @"weibo";
NSString * const kEvent_register_burialPoint_name = @"wechat";
NSString * const kEvent_register_burialPoint_password = @"password";

NSString * const kEvent_register_burialPoint_smsCode = @"smsCode";
NSString * const kEvent_register_burialPoint_picCode = @"picCode";
NSString * const kEvent_register_burialPoint_login = @"login";
NSString * const kEvent_register_burialPoint_register = @"register";

NSString * const kEvent_login_burialPoint_smsLogin = @"smsLogin";
NSString * const kEvent_login_burialPoint_forget = @"forget";
NSString * const kEvent_login_burialPoint_qq = @"qq";
NSString * const kEvent_login_burialPoint_wechat = @"wechat";
NSString * const kEvent_login_burialPoint_weibo = @"weibo";

NSString * const kEvent_smsLogin_burialPoint_qq = @"qq";
NSString * const kEvent_smsLogin_burialPoint_wechat = @"wechat";
NSString * const kEvent_smsLogin_burialPoint_weibo = @"weibo";

NSString * const kEvent_information_burialPoint_avatar = @"avatar";
NSString * const kEvent_information_burialPoint_name = @"name";
NSString * const kEvent_information_burialPoint_password = @"password";
NSString * const kEvent_information_burialPoint_mobile = @"mobile";
NSString * const kEvent_information_burialPoint_qq = @"qq";
NSString * const kEvent_information_burialPoint_wechat = @"wechat";
NSString * const kEvent_information_burialPoint_weibo = @"weibo";
NSString * const kEvent_information_burialPoint_qqCancel = @"qqCancel";
NSString * const kEvent_information_burialPoint_wechatCancel = @"wechatCancel";
NSString * const kEvent_information_burialPoint_weiboCancel = @"weiboCancel";
NSString * const kEvent_information_burialPoint_takePics = @"takePics";
NSString * const kEvent_information_burialPoint_gallery = @"gallery";


@implementation WVRTrackEventMapping

+ (void)recommendToPlayVideo:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:videoId];
}

+ (void)recommendCellTitleToVideoDetail:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:videoId];
}

+ (void)recommendCellShareWechat:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"wechat"];
}

+ (void)recommendCellShareMoments:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"moments"];
}

+ (void)recommendCellShareQQ:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"QQ"];
}

+ (void)recommendCellExtendShareWechat:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"extendWechat"];
}

+ (void)recommendCellExtendShareQQ:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"extendQQ"];
}


+ (void)recommendCellExtendShareMoments:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"extendMoments"];
}


+ (void)recommendCellExtendShareWeibo:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"extendWeibo"];
}


+ (void)recommendCellExtendShareChain:(NSString *)videoId {
    
    [self trackEvent:kEvent_recommendation flag:@"extendChain"];
}

+ (void)trackEvent:(NSString *)event flag:(NSString *)flag {
    
    if (!flag.length && event.length) {
        NSLog(@"Error: Umeng 记录了一条空日志，请排查原因---- event: %@", event);
        return;
    }
    NSDictionary *dict = @{ @"version_1" : flag };
    [MobClick event:event attributes:dict];
}

// welcome

+ (void)trackingWelcome:(NSString *)event {
    
    [self trackEvent:@"welcome" flag:event];
}

// research

+ (void)trackingResearch:(NSString *)event {
    
    [self trackEvent:@"research" flag:event];
}

// videoPlay

+ (void)trackingVideoPlay:(NSString *)event {
    
    [self trackEvent:@"videoPlay" flag:event];
}

// me
+ (void)meShare {
    
    [self trackEvent:kEvent_me flag:@"share"];
}

+ (void)meSetting {
    
    [self trackEvent:kEvent_me flag:@"setting"];
}

+ (void)meLogin {
    
    [self trackEvent:kEvent_me flag:@"login"];
}

+ (void)meRegister {
    
    [self trackEvent:kEvent_me flag:@"register"];
}

+ (void)meInformation {
    
    [self trackEvent:kEvent_me flag:@"information"];
}

+ (void)phoneNumcurEvent:(NSString *)eventId {
    
    [self trackEvent:eventId flag:@"mobile"];
}

+ (void)curEvent:(NSString *)eventId flag:(NSString *)flag {
    
    [self trackEvent:eventId flag:flag];
}

+ (void)nextBtnOnClickcurEvent:(NSString *)eventId {
    
    [self trackEvent:eventId flag:@"next"];
}

@end

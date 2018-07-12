//
//  WVRTrackEventMapping.h
//  WhaleyVR
//
//  Created by qbshen on 2016/10/29.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kEvent_recommendation;
UIKIT_EXTERN NSString * const kEvent_register;
UIKIT_EXTERN NSString * const kEvent_login ;
UIKIT_EXTERN NSString * const kEvent_smsLogin;
UIKIT_EXTERN NSString * const kEvent_social;
UIKIT_EXTERN NSString * const kEvent_information ;

UIKIT_EXTERN NSString * const kEvent_burialPoint_code ;
UIKIT_EXTERN NSString * const kEvent_burialPoint_next ;

UIKIT_EXTERN NSString * const kEvent_burialPoint_mobile;


UIKIT_EXTERN NSString * const kEvent_register_burialPoint_qq ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_wechat ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_weibo ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_name ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_password ;

UIKIT_EXTERN NSString * const kEvent_register_burialPoint_smsCode ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_picCode ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_login ;
UIKIT_EXTERN NSString * const kEvent_register_burialPoint_register ;

UIKIT_EXTERN NSString * const kEvent_login_burialPoint_smsLogin ;
UIKIT_EXTERN NSString * const kEvent_login_burialPoint_forget ;
UIKIT_EXTERN NSString * const kEvent_login_burialPoint_qq ;
UIKIT_EXTERN NSString * const kEvent_login_burialPoint_wechat ;
UIKIT_EXTERN NSString * const kEvent_login_burialPoint_weibo ;

UIKIT_EXTERN NSString * const kEvent_smsLogin_burialPoint_qq ;
UIKIT_EXTERN NSString * const kEvent_smsLogin_burialPoint_wechat ;
UIKIT_EXTERN NSString * const kEvent_smsLogin_burialPoint_weibo ;

UIKIT_EXTERN NSString * const kEvent_information_burialPoint_avatar ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_name ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_password ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_mobile ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_qq ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_wechat ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_weibo ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_qqCancel ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_wechatCancel ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_weiboCancel ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_takePics ;
UIKIT_EXTERN NSString * const kEvent_information_burialPoint_gallery ;

@interface WVRTrackEventMapping : NSObject


+ (void)recommendToPlayVideo:(NSString *)videoId;
+ (void)recommendCellTitleToVideoDetail:(NSString *)videoId;

+ (void)recommendCellShareWechat:(NSString *)videoId;

+ (void)recommendCellShareMoments:(NSString *)videoId;

+ (void)recommendCellShareQQ:(NSString *)videoId;

+ (void)recommendCellExtendShareWechat:(NSString *)videoId;

+ (void)recommendCellExtendShareQQ:(NSString *)videoId;


+ (void)recommendCellExtendShareMoments:(NSString *)videoId;

+ (void)recommendCellExtendShareWeibo:(NSString *)videoId;

+ (void)recommendCellExtendShareChain:(NSString *)videoId;


/// track the custom event（Umeng）
+ (void)trackEvent:(NSString *)event flag:(NSString *)flag;


/**
 Welcome
 */
+ (void)trackingWelcome:(NSString *)event;


/**
 research
 */
+ (void)trackingResearch:(NSString *)event;


/**
 videoPlay
 */
+ (void)trackingVideoPlay:(NSString *)event;


/**
 event me
 */
+ (void)meShare;

+ (void)meSetting;
+ (void)meLogin;

+ (void)meRegister;
+ (void)meInformation;


+ (void)curEvent:(NSString *)eventId flag:(NSString *)flag;
+ (void)phoneNumcurEvent:(NSString *)eventId;

@end

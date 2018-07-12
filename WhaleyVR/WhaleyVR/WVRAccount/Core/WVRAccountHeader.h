//
//  WVRAccountHeader.h
//  WVRAccount
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#ifndef WVRAccountHeader_h
#define WVRAccountHeader_h

#define login_btn_tag 100

#define security_btn_tag 200
#define VerifyCode_btn_tag 300


#define ACCOUNT_PWLOGIN_tag 0
#define FORGOTPW_tag 1
#define SMS_SHORT_LOGIN_tag 2
#define WB_btn_tag 600


#define QQ_btn_tag 400
#define WX_btn_tag 500
#define WB_btn_tag 600


#define DEFAULT_HEAD_IMAGE_STR (@"avatar_login")
#define HOLDER_HEAD_IMAGE ([UIImage imageNamed:DEFAULT_HEAD_IMAGE_STR])


#import <WVRAppContextHeader.h>
#import <WVRWidgetHeader.h>
#import <UIView+Extend.h>
#import <UIView+EasyLayout.h>
#import <NSURL+Extend.h>
#import <UIViewController+HUD.h>
#import <UIColor+Extend.h>
#import <UIButton+Extends.h>
#import <SDWebImage/UIImageView+WVRWebCache.h>
#import <WVRUtil/WVRGlobalUtil.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "WVRTrackEventMapping.h"
#import "WVRFilePathTool.h"

#endif /* WVRAccountHeader_h */

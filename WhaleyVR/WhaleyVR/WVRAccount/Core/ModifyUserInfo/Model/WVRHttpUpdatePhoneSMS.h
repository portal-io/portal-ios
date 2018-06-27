//
//  WVRHttpUpdatePhoneSMS.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRNet/WVRAPIBaseManager.h>

UIKIT_EXTERN NSString * const kHttpParams_sms_changePhoneNum_device_id ;
UIKIT_EXTERN NSString * const kHttpParams_sms_changePhoneNum_sms_token ;
UIKIT_EXTERN NSString * const kHttpParams_sms_changePhoneNum_mobile ;
UIKIT_EXTERN NSString * const kHttpParams_sms_changePhoneNum_ncode ;
UIKIT_EXTERN NSString * const kHttpParams_sms_changePhoneNum_captcha ;


@interface WVRHttpUpdatePhoneSMS : WVRAPIBaseManager<WVRAPIManager>

@end

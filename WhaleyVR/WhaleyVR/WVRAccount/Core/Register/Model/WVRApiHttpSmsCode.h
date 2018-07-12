//
//  WVRApiHttpSmsCode.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const sms_login_device_id ;
extern NSString * const sms_login_sms_token ;
extern NSString * const sms_login_mobile ;
extern NSString * const sms_login_ncode ;
extern NSString * const sms_login_captcha ;

@interface WVRApiHttpSmsCode : WVRAPIBaseManager <WVRAPIManager>

@end

//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const sms_register_mobile ;
extern NSString * const sms_register_device_id ;
extern NSString * const sms_register_code ;
extern NSString * const sms_register_from ;
extern NSString * const sms_register_ncode ;
extern NSString * const sms_register_lthird_id ;

@interface WVRApiHttpRegister : WVRAPIBaseManager <WVRAPIManager>

@end

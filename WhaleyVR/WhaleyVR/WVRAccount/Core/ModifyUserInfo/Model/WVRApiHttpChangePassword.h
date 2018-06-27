//
//  WVRApiHttpChangePassword.h
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const Params_changePW_device_id ;
extern NSString * const Params_changePW_accesstoken ;
extern NSString * const Params_changePW_old_pwd ;
extern NSString * const Params_changePW_password ;

@interface WVRApiHttpChangePassword : WVRAPIBaseManager <WVRAPIManager>

@end

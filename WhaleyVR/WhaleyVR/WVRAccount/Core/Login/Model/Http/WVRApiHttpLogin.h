//
//  WVRApiHttpLogin.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager+ReactiveExtension.h"

extern NSString * const kWVRAPIParamsProgram_account_login_username ;
extern NSString * const kWVRAPIParamsProgram_account_password ;
extern NSString * const kWVRAPIParamsProgram_account_from ;
extern NSString * const kWVRAPIParamsProgram_account_device_id ;
extern NSString * const kWVRAPIParamsProgram_account_third_id ;

@interface WVRApiHttpLogin : WVRAPIBaseManager <WVRAPIManager>

@end

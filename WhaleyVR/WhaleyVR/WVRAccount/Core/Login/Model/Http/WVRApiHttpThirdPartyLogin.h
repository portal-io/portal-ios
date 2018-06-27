//
//  WVRApiHttpThirdPartyLogin.h
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const Params_thirdPartyLogin_origin ;
extern NSString * const Params_thirdPartyLogin_device_id ;
extern NSString * const Params_thirdPartyLogin_open_id ;
extern NSString * const Params_thirdPartyLogin_unionid ;
extern NSString * const Params_thirdPartyLogin_nickname ;
extern NSString * const Params_thirdPartyLogin_avatar ;
extern NSString * const Params_thirdPartyLogin_location ;
extern NSString * const Params_thirdPartyLogin_from ;
extern NSString * const Params_thirdPartyLogin_gender ;

@interface WVRApiHttpThirdPartyLogin : WVRAPIBaseManager <WVRAPIManager>

@end

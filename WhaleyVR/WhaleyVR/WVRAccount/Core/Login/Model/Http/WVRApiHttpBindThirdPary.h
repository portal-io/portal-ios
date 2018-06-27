//
//  WVRApiHttpBindThirdPary.h
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const Params_thirdPartyBind_origin ;
extern NSString * const Params_thirdPartyBind_device_id ;
extern NSString * const Params_thirdPartyBind_open_id ;
extern NSString * const Params_thirdPartyBind_unionid ;
extern NSString * const Params_thirdPartyBind_nickname ;
extern NSString * const Params_thirdPartyBind_avatar ;
extern NSString * const Params_thirdPartyBind_location ;
extern NSString * const Params_thirdPartyBind_accesstoken ;
extern NSString * const Params_thirdPartyBind_gender ;

@interface WVRApiHttpBindThirdPary : WVRAPIBaseManager <WVRAPIManager>

@end

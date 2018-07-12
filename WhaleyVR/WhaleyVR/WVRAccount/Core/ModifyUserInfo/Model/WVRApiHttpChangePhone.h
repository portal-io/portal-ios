//
//  WVRApiHttpChangePhone.h
//  WhaleyVR
//
//  Created by XIN on 21/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const Params_changePhoneNum_device_id ;
extern NSString * const Params_changePhoneNum_accesstoken ;
extern NSString * const Params_changePhoneNum_phone ;
extern NSString * const Params_changePhoneNum_code ;
extern NSString * const Params_changePhoneNum_ncode ;

@interface WVRApiHttpChangePhone : WVRAPIBaseManager <WVRAPIManager>

@end

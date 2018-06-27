//
//  WVRApiHttpChangeNickname.h
//  WhaleyVR
//
//  Created by XIN on 22/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const Params_changeNickName_device_id ;
extern NSString * const Params_changeNickName_accesstoken ;
extern NSString * const Params_changeNickName_nickname;

@interface WVRApiHttpChangeNickname : WVRAPIBaseManager <WVRAPIManager>

@end

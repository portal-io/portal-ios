//
//  WVRApiHttpRefreshToken.h
//  WhaleyVR
//
//  Created by XIN on 21/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const refreshToken_refreshtoken ;
extern NSString * const refreshToken_device_id ;
extern NSString * const refreshToken_accesstoken ;

@interface WVRApiHttpRefreshToken : WVRAPIBaseManager <WVRAPIManager>

@end

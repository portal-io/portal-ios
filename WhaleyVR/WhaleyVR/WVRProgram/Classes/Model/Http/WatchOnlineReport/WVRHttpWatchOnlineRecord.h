//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

UIKIT_EXTERN NSString * const kWVRHttp_watchOnline_record_contentType ;
UIKIT_EXTERN NSString * const kWVRHttp_watchOnline_record_code ;
UIKIT_EXTERN NSString * const kWVRHttp_watchOnline_record_type ;
UIKIT_EXTERN NSString * const kWVRHttp_watchOnline_record_deviceNo ;

@interface WVRHttpWatchOnlineRecord : WVRAPIBaseManager <WVRAPIManager>

@end

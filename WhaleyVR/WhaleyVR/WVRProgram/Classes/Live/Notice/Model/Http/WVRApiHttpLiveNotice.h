//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kHttpParams_liveOrder_uid ;
UIKIT_EXTERN NSString * const kHttpParams_liveOrder_token ;
UIKIT_EXTERN NSString * const kHttpParams_liveOrder_device_id ;
UIKIT_EXTERN NSString * const kHttpParams_liveOrder_code ;

UIKIT_EXTERN NSString * const kHttpParams_liveOrder_action ;

@interface WVRApiHttpLiveNotice : WVRAPIBaseManager <WVRAPIManager>

@end

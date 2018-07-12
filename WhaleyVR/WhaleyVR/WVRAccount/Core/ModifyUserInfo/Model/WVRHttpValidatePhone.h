//
//  WVRHttpValidatePhone.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRAPIBaseManager.h>

UIKIT_EXTERN NSString * const Params_validatePhoneNum_device_id ;
UIKIT_EXTERN NSString * const Params_validatePhoneNum_accesstoken ;
UIKIT_EXTERN NSString * const Params_validatePhoneNum_phone ;
UIKIT_EXTERN NSString * const Params_validatePhoneNum_ncode ;

@interface WVRHttpValidatePhone : WVRAPIBaseManager<WVRAPIManager>

@end

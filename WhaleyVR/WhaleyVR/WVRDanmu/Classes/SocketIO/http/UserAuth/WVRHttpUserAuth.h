//
//  WVRApiHttpDanmu.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WVRAPIBaseManager.h"
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kWVRHttpUserAuth_accesstoken ;
UIKIT_EXTERN NSString * const kWVRHttpUserAuth_device_id ;

UIKIT_EXTERN NSString * const kWVRHttpUserAuth_model ;
UIKIT_EXTERN NSString * const kWVRHttpUserAuth_timestamp ;

@interface WVRHttpUserAuth : WVRAPIBaseManager <WVRAPIManager>


@end

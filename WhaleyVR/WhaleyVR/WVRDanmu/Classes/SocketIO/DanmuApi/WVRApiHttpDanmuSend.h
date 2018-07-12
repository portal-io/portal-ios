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

UIKIT_EXTERN NSString * const kWVRAPIParamsDanmuSend_roomid ;
UIKIT_EXTERN NSString * const kWVRAPIParamsDanmuSend_message ;

@interface WVRApiHttpDanmuSend : WVRAPIBaseManager <WVRAPIManager>

@end

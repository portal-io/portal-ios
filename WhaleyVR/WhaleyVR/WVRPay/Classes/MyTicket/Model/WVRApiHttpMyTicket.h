//
//  WVRApiHttpMyTicket.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

UIKIT_EXTERN NSString * const kHttpParam_myTicket_uid ;

UIKIT_EXTERN NSString * const kHttpParam_myTicket_page ;

UIKIT_EXTERN NSString * const kHttpParam_myTicket_size ;

UIKIT_EXTERN NSString * const kHttpParam_myTicket_sign ;

@interface WVRApiHttpMyTicket : WVRAPIBaseManager<WVRAPIManager>

@end

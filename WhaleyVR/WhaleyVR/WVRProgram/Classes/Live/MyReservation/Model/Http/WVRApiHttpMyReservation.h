//
//  WVRApiHttpHome.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const kHttpParams_myReserveList_uid ;
extern NSString * const kHttpParams_myReserveList_token ;
extern NSString * const kHttpParams_myReserveList_device_id ;


@interface WVRApiHttpMyReservation : WVRAPIBaseManager <WVRAPIManager>

@end

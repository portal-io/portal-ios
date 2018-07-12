//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const history_record_uid ;
extern NSString * const history_record_device_id ;
extern NSString * const history_record_playTime ;
extern NSString * const history_record_playStatus ;
extern NSString * const history_record_programCode ;
extern NSString * const history_record_programType ;
extern NSString * const history_record_dataSource ;
extern NSString * const history_record_totalPlayTime ;

@interface WVRApiHttpHistoryRecord : WVRAPIBaseManager <WVRAPIManager>

@end

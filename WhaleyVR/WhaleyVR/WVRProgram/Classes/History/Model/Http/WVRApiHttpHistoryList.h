//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const history_list_uid ;
extern NSString * const history_list_device_id ;
extern NSString * const history_list_page ;
extern NSString * const history_list_size ;
extern NSString * const history_list_dataSource ;

@interface WVRApiHttpHistoryList : WVRAPIBaseManager <WVRAPIManager>

@end

//
//  WVRWatchOnlineReocrd.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRWatchOnlineRecordModel.h"

@interface WVRWatchOnlineRecord : NSObject

- (void)http_watch_online_record:(WVRWatchOnlineRecordModel *)recordModel;

- (void)http_watch_online_unrecord:(WVRWatchOnlineRecordModel *)recordModel;

@end

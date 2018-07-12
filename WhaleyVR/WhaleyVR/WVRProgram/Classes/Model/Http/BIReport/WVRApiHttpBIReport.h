//
//  WVRApiHttpBIReport.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const kWVRAPIParamsBI_logs;
extern NSString * const kWVRAPIParamsBI_ts;
extern NSString * const kWVRAPIParamsBI_md5;
extern NSString * const kWVRAPIParamsBI_checkVersion;

@interface WVRApiHttpBIReport : WVRAPIBaseManager <WVRAPIManager>

@end

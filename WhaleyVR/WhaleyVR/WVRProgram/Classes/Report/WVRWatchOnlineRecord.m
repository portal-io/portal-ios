//
//  WVRWatchOnlineReocrd.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRWatchOnlineRecord.h"
#import "WVRHttpWatchOnlineRecord.h"

@interface WVRWatchOnlineRecord ()

@property (nonatomic, strong) NSMutableSet * gRecordCodeSet;

@end


@implementation WVRWatchOnlineRecord

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.gRecordCodeSet = [NSMutableSet new];
    }
    return self;
}

- (void)http_watch_online_record:(WVRWatchOnlineRecordModel *)recordModel {
    
    for (NSString * curCode in self.gRecordCodeSet) {
        if ([curCode isEqualToString:recordModel.code]) {
            return;
        }
    }
    kWeakSelf(self);
    WVRHttpWatchOnlineRecord *api = [[WVRHttpWatchOnlineRecord alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    params[kWVRHttp_watchOnline_record_contentType] = recordModel.contentType;
    params[kWVRHttp_watchOnline_record_code] = recordModel.code;
    params[kWVRHttp_watchOnline_record_type] = recordModel.type;
    params[kWVRHttp_watchOnline_record_deviceNo] = recordModel.deviceNo;
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        [weakself recordSuccessBlock:recordModel.code];
    };
    api.failedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"Request Failed");
    };
    [api loadData];
}

- (void)recordSuccessBlock:(NSString *)code {
    
    [self.gRecordCodeSet addObject:code];
}

- (void)http_watch_online_unrecord:(WVRWatchOnlineRecordModel *)recordModel {
    
    BOOL haveRecord = NO;
    for (NSString * curCode in self.gRecordCodeSet) {
        if ([curCode isEqualToString:recordModel.code]) {
            haveRecord = YES;
        }
    }
    if (!haveRecord) {
        return;
    }
    kWeakSelf(self);
    WVRHttpWatchOnlineRecord *api = [[WVRHttpWatchOnlineRecord alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    params[kWVRHttp_watchOnline_record_contentType] = recordModel.contentType;
    params[kWVRHttp_watchOnline_record_code] = recordModel.code;
    params[kWVRHttp_watchOnline_record_type] = recordModel.type;
    params[kWVRHttp_watchOnline_record_deviceNo] = recordModel.deviceNo;
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        [weakself unrecordSuccessBlock:recordModel.code];
    };
    api.failedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"Request Failed");
    };
    [api loadData];
}

- (void)unrecordSuccessBlock:(NSString *)code {
    
    [self.gRecordCodeSet removeObject:code];
}

@end

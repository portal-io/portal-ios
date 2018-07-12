//
//  WVRVideoEntityTopic.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 专题、节目包VideoEntity

#import "WVRVideoEntityTopic.h"

@implementation WVRVideoEntityTopic

- (instancetype)init {
    self = [super init];
    if (self) {
        // mark: - 待定
//        self.streamType = STREAM_VR_VOD;
        
        _isVideoEntityTopic = YES;
    }
    return self;
}

- (BOOL)canPlayNext {
    
    if (self.detailItemModels.count > 1) {
        
        int i = 0;
        WVRItemModel *item = self.detailItemModels.lastObject;
        for (WVRItemModel *tmpModel in self.detailItemModels) {
            if (i == 1) {
                item = tmpModel;
                break;
            }
            if ([tmpModel.sid isEqualToString:self.sid]) {
                i = 1;
            }
        }
        return ![self.sid isEqualToString:item.sid];
    }
    
    return NO;
}

- (NSString *)nextPlayVideoTitle {
    
    if (self.detailItemModels.count > 1) {
        
        int i = 0;
        WVRItemModel *item = self.detailItemModels.lastObject;
        for (WVRItemModel *tmpModel in self.detailItemModels) {
            if (i == 1) {
                item = tmpModel;
                break;
            }
            if ([tmpModel.sid isEqualToString:self.sid]) {
                i = 1;
            }
        }
        return item.name;
    }
    
    return nil;
}

- (WVRItemModel *)currentItemModel {
    
    WVRItemModel *item = self.detailItemModels.firstObject;
    for (WVRItemModel *tmpModel in self.detailItemModels) {
        if ([tmpModel.sid isEqualToString:self.sid]) {
            item = tmpModel;
            break;
        }
    }
    return item;
}

- (instancetype)nextVideoEntity {
    
    [WVRTrackEventMapping trackingVideoPlay:@"next"];
    
    BOOL findCurrent = NO;
    WVRItemModel *item = self.detailItemModels.lastObject;
    for (WVRItemModel *tmpModel in self.detailItemModels) {
        if (findCurrent) {
            item = tmpModel;
            break;
        }
        if ([tmpModel.code isEqualToString:self.code]) {
            findCurrent = YES;
        }
    }
    self.code = item.code;
    self.sid = item.sid;
    self.videoTitle = item.title;
    
    return self;
}


@end

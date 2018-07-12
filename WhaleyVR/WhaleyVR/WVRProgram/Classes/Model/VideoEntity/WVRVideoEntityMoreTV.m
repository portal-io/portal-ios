//
//  WVRVideoEntityMoreTV.m
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 电视猫电视剧VideoEntity

#import "WVRVideoEntityMoreTV.h"

@implementation WVRVideoEntityMoreTV
@synthesize isMoreMovie = _isMoreMovie;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.streamType = STREAM_2D_TV;
    }
    return self;
}

#pragma mark - overwrite func

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
    [self setCurUrlModel:nil];
    
    return self;
}

#pragma mark - external func

// 为电视剧找出最佳清晰度链接
- (NSURL *)bestDefinitionUrl {
    
    NSArray *defiArr = @[ kDefinition_HD, kDefinition_XD, kDefinition_SD, kDefinition_ST, kDefinition_AUTO ];
    
    // 电视剧默认不支持切换机位
    NSDictionary *linkDict = [self.parserdUrlModelDict.allValues firstObject];
    
    for (NSString *defiKey in defiArr) {
        
        WVRPlayUrlModel *model = [linkDict objectForKey:defiKey];
        if (nil != model) {
            
            [self setCurUrlModel:model];
            return model.url;
        }
    }
    
    // protect
    WVRPlayUrlModel *model = [linkDict.allValues firstObject];
    [self setCurUrlModel:model];
    
    return model.url;
}

#pragma mark - setter

- (void)setDetailItemModels:(NSArray<WVRItemModel *> *)detailItemModels {
    _detailItemModels = detailItemModels;
    
    _isMoreMovie = (detailItemModels.count < 1);
}

#pragma mark - YYModel

+ (NSArray *)modelPropertyBlacklist {
    
    return @[ @"detailItemModels", ];
}

@end

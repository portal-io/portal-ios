//
//  WVRTVItemModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVItemModel.h"

@implementation WVRTVItemModel

#pragma mark - getter

- (NSString *)sid {
    
    return self.code;
}

- (NSInteger)itemId {
    
    return self.curEpisode.integerValue;
}

- (NSArray *)playUrlArray {
    
    // 迅雷源的链接置后, 分享链接屏蔽
    NSMutableArray *arr = [NSMutableArray array];
    
    WVRTVPlayUrlModel *tmpModel = nil;
    for (WVRTVPlayUrlModel *model in self.playUrlModels) {
        if ([model.source isEqualToString:@"vr_share"]) {
            continue;
        }
        if ([model.source isEqualToString:@"xunlei"]) {
            tmpModel = model;
        } else {
            if (model.playUrl) {
                [arr addObject:model.playUrl];
            }
        }
    }
    if (tmpModel.playUrl) {
        [arr addObject:tmpModel.playUrl];
    }
    
    return [arr copy];
}

@end


@implementation WVRTVPlayUrlModel

@end

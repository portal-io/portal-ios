//
//  WVRBusLiveModel.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/9.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBusLiveModel.h"
#import "YYModel.h"

@implementation WVRBusLiveModel

+ (NSArray *)modelPropertyBlackList {
    return @[ @"createTime" ];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"content" : @"comments", @"uid": @"mwid" };
}

+ (void)getDanmuListFromCache:(void (^)(NSArray *))complation {
    
    // 此方法已弃用
//    WVRUserModel *uModel = [WVRUserModel sharedInstance];
//    NSArray *array = uModel.danmuArray;
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        __block long i = 0;
//        
//        NSDate *now = [NSDate date];
//        
//        [uModel.cacheDanmuList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            WVRBusLiveModel *tmpModel = obj;
//            int time = abs((int)[tmpModel.createTime timeIntervalSinceDate:now]);
//            if (time > 30) { i = idx; }
//        }];
//        
//        [uModel.cacheDanmuList removeObjectsInRange:NSMakeRange(0, i)];
//        
//        i = 0;
//        NSMutableArray *msgArray = [NSMutableArray array];
//        for (WVRBusLiveModel *tmpModel in array) {
//            if (i > 50) { break; }
//            
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"content"] = tmpModel.content;
//            dict[@"time"] = @(tmpModel.time);
//            dict[@"nickname"] = tmpModel.nickname;
//            dict[@"uid"] = @(tmpModel.uid);
//            dict[@"playTime"] = tmpModel.playTime;
//            
//            [msgArray addObject:dict];
//            [uModel.cacheDanmuList addObject:tmpModel];
//            i ++;
//        }
//        
//        [uModel.danmuArray removeObjectsInRange:NSMakeRange(0, msgArray.count)];
//        
//        complation(msgArray);
//    });
}

@end

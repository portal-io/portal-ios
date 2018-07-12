//
//  WVRVideoEntity.m
//  WhaleyVR
//
//  Created by 曹江龙 on 16/9/18.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRVideoEntity.h"
#import "WVRWhaleyHTTPManager.h"

@implementation WVRVideoEntity

#pragma mark - request

- (void)requestForPlayerBottomImage:(void (^)(WVRBottomImageModel *model))complation {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = self.sid;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAPI_SERVICE, @"program/getProgramOps"];
    if (self.streamType == STREAM_VR_LIVE) {
        
        urlStr = [NSString stringWithFormat:@"%@%@", kAPI_SERVICE, @"liveProgram/getLiveOps"];
    }
    [WVRWhaleyHTTPManager GETService:urlStr withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        NSDictionary *resDict = responseObj;
        NSString *picUrl = [resDict[@"data"] objectForKey:@"centerPic"];
        
        WVRBottomImageModel *model = nil;
        
        if (picUrl.length > 0) {
            model = [[WVRBottomImageModel alloc] init];
            
            model.picUrl = picUrl;
            model.scale = [[resDict[@"data"] objectForKey:@"radius"] floatValue];
        }
        
        if (complation && model) {
            complation(model);
        } else {
            DDLogError(@"requestForPlayerBottomImage error");
        }
    }];
}

@end


@implementation WVRBottomImageModel

@end

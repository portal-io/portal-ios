//
//  WVRPublisherListModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 发布者更新节目列表

#import "WVRPublisherListModel.h"
#import "WVRWhaleyHTTPManager.h"
#import "WVRRequestClient.h"

@implementation WVRPublisherListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"programs" : [WVRPublisherListItemModel class], };
}

+ (void)requestForPublisherListForCp:(NSString *)cpCode sortType:(PublisherSortType)sortType atPage:(int)page block:(void (^)(WVRPublisherListModel * model, NSError *error))block {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@", [WVRUserModel kNewVRBaseURL], kAPI_SERVICE, @"program/findByCpCode"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"cpCode"] = cpCode;
    params[@"size"] = @20;
    params[@"page"] = @(page);
    
    switch (sortType) {
        case PublisherSortTypePlayCount:
            params[@"sortCol"] = @"playCount";
            break;
        case PublisherSortTypePublishTime:
            params[@"sortCol"] = @"publishTime";
            break;
            
        default:
            params[@"sortCol"] = @"playCount";
            break;
    }
    
    [WVRRequestClient GETService:urlStr withParams:params completionBlock:^(id responseObj, NSError *error) {
        NSDictionary *dic = responseObj;
        int code = [dic[@"code"] intValue];
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        NSDictionary *resDict = dic[@"data"];
        
        if (!error && code == 200) {
            WVRPublisherListModel *model = [WVRPublisherListModel yy_modelWithDictionary:resDict];
            
            block(model, nil);
        } else {
            if (error) {
                block(nil, error);
            } else {
                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
                block(nil, err);
            }
        }
    }];
}

@end


@implementation WVRPublisherListItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end


@implementation WVRPublisherListStat

@end


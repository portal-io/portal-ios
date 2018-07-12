//
//  WVRPublisherDetailModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 发布者详情

#import "WVRPublisherDetailModel.h"
#import "WVRWhaleyHTTPManager.h"
#import "WVRRequestClient.h"

@implementation WVRPublisherDetailModel

+ (void)requestForPublisherDetailWithCode:(NSString *)code block:(void (^)(WVRPublisherDetailModel * model, NSError *error))block {
    
    NSString *uid = [WVRUserModel sharedInstance].accountId;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@", [WVRUserModel kNewVRBaseURL], kAPI_SERVICE, @"cp/findByCode"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (uid.length > 0) { params[@"userId"] = uid; }
    params[@"code"] = code;
    
    [WVRRequestClient GETService:urlStr withParams:params completionBlock:^(id responseObj, NSError *error) {
        NSDictionary *dic = responseObj;
        int code = [dic[@"code"] intValue];
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        NSDictionary *resDict = dic[@"data"];
        
        if (!error && code == 200) {
            WVRPublisherDetailModel *model = [WVRPublisherDetailModel yy_modelWithDictionary:resDict];
            
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


@implementation WVRPublisherModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end

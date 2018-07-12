//
//  WVRSpringLotteryModel.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 拉取接口抽卡片

#import "WVRSpringCardModel.h"
#import "WVRWhaleyHTTPManager.h"
#import "SQMD5Tool.h"
#import "WVRSpring2018Manager.h"

@implementation WVRSpringCardModel

+ (void)requestForGetCard:(CardBlock)block {
    
    // ?uid=abc&token=aaa&eventCode=springFestival2018&mobile=13011112222
    
    NSString *url = @"newVR-report-service/h5event/drawCard";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [WVRUserModel sharedInstance].accountId;
    params[@"token"] = [WVRUserModel sharedInstance].sessionId;
    params[@"eventCode"] = @"springFestival2018";
    params[@"mobile"] = [WVRUserModel sharedInstance].mobileNumber;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    params[@"ts"] = [NSString stringWithFormat:@"%ld", (long)time];
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@", params[@"eventCode"], params[@"ts"], params[@"uid"]];
    params[@"sign"] = [SQMD5Tool encryptByMD5:signStr md5Suffix:@""];
    
    [WVRWhaleyHTTPManager POSTService:url withParams:params completionBlock:^(NSDictionary *responseObj, NSError *error) {
        
        if (error) {
            SQToastInKeyWindow(kNetError);
            NSLog(@"%d", (int)error.code);
            if (block) {
                block(nil, error);
            }
        } else {
            int code = [responseObj[@"code"] intValue];
            if (code == 200) {
                
                NSDictionary *data = responseObj[@"data"];
                
                WVRSpringCardModel *model = [WVRSpringCardModel yy_modelWithDictionary:data];
                
                if (block) {
                    block(model, nil);
                }
            }else if(code == 510){
                NSError *err = [NSError errorWithDomain:@"活动已结束" code:code userInfo:nil];
                if (block) {
                    block(nil, err);
                }
            }
            else {
                NSString *msg = [NSString stringWithFormat:@"%@", responseObj[@"msg"]];
                SQToastInKeyWindow(msg);
                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
                if (block) {
                    block(nil, err);
                }
            }
        }
    }];
}

- (NSString *)relCardsCntString {
    
    switch (self.relCardsCnt) {
        case 4:
            return @"四";
            
        case 3:
            return @"三";
            
        case 5:
            return @"五";
            
        case 2:
            return @"两";
            
        case 6:
            return @"六";
            
        case 7:
            return @"七";
            
        case 8:
            return @"八";
            
        case 9:
            return @"九";
            
        case 1:
            return @"一";
            
        default:
            return @"十";
    }
    return @"十";
}

- (NSString *)relCardGrpTypeString {
    
    switch (self.relCardGrpType) {
        case 1:
            return @"开启现金红包";
        case 2:
            return @"获得实物奖品";
        case 3:
            return @"获得节目兑换码";
            
        default:
            return @"";
    }
    return @"";
}

@end

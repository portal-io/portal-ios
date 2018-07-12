//
//  WVRUnExchangeCodeModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 用户未兑换的兑换码列表

#import "WVRUnExchangeCodeModel.h"
#import "YYModel.h"
#import "SQMD5Tool.h"

@implementation WVRUnExchangeCodeModel

#pragma mark - YYModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"redeemCodeList" : [WVRRedeemCodeListItemModel class], };
}

#pragma mark - request

//code	subCode	msg	remark
//200	000	success	目前系统正常返回都是200
//400	001	用户id为空	用户id为空
//400	014	签名参数为空	签名参数为空
//400	024	手机号为空	手机号为空
//401	000	auth error	鉴权失败
//500	000	server error	系统异常


/// 用户未兑换的兑换码列表接口
+ (void)requestUnExchangeRedeemCode:(void (^)(WVRUnExchangeCodeModel *model, NSError *error))block {
    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"uid"] = [WVRUserModel sharedInstance].accountId;
//    param[@"phoneNum"] = [WVRUserModel sharedInstance].mobileNumber;
//    
//    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
//    NSString *str = [NSString stringWithFormat:@"%@%@", param[@"uid"], param[@"phoneNum"]];
//    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
//    
//    param[@"sign"] = sign;
//    
//    [WVRWhaleyHTTPManager GETService:@"newVR-report-service/redeemCode/listUserUnRedeemed" withParams:param completionBlock:^(id responseObj, NSError *error) {
//        
//        if (error) {
//            
//            block(nil, error);
//            
//        } else {
//            NSDictionary *dict = responseObj;
//            int code = [dict[@"code"] intValue];
//            NSString *msg = [NSString stringWithFormat:@"%@", dict[@"msg"]];
//            
//            if (code == 200) {
//                
//                NSDictionary *data = dict[@"data"];
//                WVRUnExchangeCodeModel *model = [WVRUnExchangeCodeModel yy_modelWithDictionary:data];
//                
//                block(model, nil);
//                
//            } else {
//                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
//                block(nil, err);
//            }
//        }
//    }];
}

@end


@implementation WVRRedeemCodeListItemModel
@synthesize showType = _showType;

#pragma mark - YYModel

+ (NSArray *)modelPropertyBlacklist {
    
    return @[ @"showType" ];
}

#pragma mark - getter

- (WVRRedeemCodeShowType)showType {
    
    if (_showType <= 0) {
        if ([self.redeemCodeShowType isEqualToString:@"reservationNumber"]) {
            _showType = WVRRedeemCodeShowTypePhone;
        } else if ([self.redeemCodeShowType isEqualToString:@"activity"]) {
            _showType = WVRRedeemCodeShowTypeActivity;
        } else {
            DDLogError(@"error，未约定的showtype");
        }
        
    }
    return _showType;
}

@end

//
//  WVRCoinCertificateModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 兑换码/观看券Model

#import "WVRExchangeTicketModel.h"
#import "YYModel.h"
#import "SQMD5Tool.h"
//#import "WVRWhaleyHTTPManager.h"
//#import "WVRRequestClient.h"
#import "WVRMyTicketListModel.h"
#import "WVRUserTicketListModel.h"
#import "WVRUnExchangeCodeModel.h"

@implementation WVRExchangeTicketModel

// 券详情接口
+ (void)requestTicketWithCode:(NSString *)code block:(void (^)(WVRExchangeTicketDetailModel *model, NSError *error))block {
    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"code"] = code;
//    
//    [WVRWhaleyHTTPManager GETService:@"newVR-service/appservice/coupon/findByCode" withParams:param completionBlock:^(id responseObj, NSError *error) {
//        
//        if (error) {
//            
//            block(nil, error);
//            
//        } else {
//            NSDictionary *dict = responseObj;
//            int code = [dict[@"code"] intValue];
//            NSString *msg = [NSString stringWithFormat:@"%@", dict[@"msg"]];
//            NSDictionary *data = dict[@"data"];
//            
//            if (code == 200 && data) {
//                
//                WVRExchangeTicketDetailModel *model = [WVRExchangeTicketDetailModel yy_modelWithDictionary:data];
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

// 通过商品code拉取相关券接口
+ (void)requestRelatedTicketWithMerchandiseCode:(NSString *)code relatedType:(NSString *)relatedType block:(void (^)(WVRRelatedTicketsModel *model, NSError *error))block {
    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"relatedCode"] = code;
//    param[@"relatedType"] = relatedType;
//    
//    [WVRWhaleyHTTPManager GETService:@"newVR-service/appservice/coupon/findByRelatedCode" withParams:param completionBlock:^(id responseObj, NSError *error) {
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
//                WVRRelatedTicketsModel *model = [WVRRelatedTicketsModel yy_modelWithDictionary:data];
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

// 用户券订单列表接口
+ (void)requestUserTicketsWithPage:(int)page block:(void (^)(WVRUserTicketListModel *model, NSError *error))block {
    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"uid"] = [WVRUserModel sharedInstance].accountId;
//    param[@"page"] = [NSString stringWithFormat:@"%d", page];
//    param[@"size"] = [NSString stringWithFormat:@"%d", (int)kHTTPPageSize];
//    
//    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
//    NSString *str = [NSString stringWithFormat:@"%@%@%@", param[@"uid"], param[@"page"], param[@"size"]];
//    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
//    
//    param[@"sign"] = sign;
//    NSString *url = [[WVRUserModel kNewVRBaseURL] stringByAppendingString:@"newVR-report-service/order/userCouponOrderList"];
//    
//    [WVRRequestClient POSTService:url withParams:param completionBlock:^(id responseObj, NSError *error) {
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
//                WVRUserTicketListModel *model = [WVRUserTicketListModel yy_modelWithDictionary:data];
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



//code	subCode	msg	remark
//200	000	success	目前系统正常返回都是200
//400	000	参数缺失
//400	028	目标活动不存在
//400	029	目标活动已失效
//400	030	目标活动已过期
//400	031	目标活动类型不支持兑换码获取
//500	000	server error	系统异常

/// 兑换码前端随机创建接口
+ (void)requestForGenRedeemCode:(NSString *)bindingCode block:(void (^)(NSString *redeemCode, NSError *error))block {
    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"bindingCode"] = bindingCode;
//    
//    [WVRWhaleyHTTPManager GETService:@"newVR-report-service/redeemCode/genRedeem" withParams:param completionBlock:^(id responseObj, NSError *error) {
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
//                NSString *result = data[@"redeemCode"];
//                
//                block(result, nil);
//                
//            } else {
//                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
//                block(nil, err);
//            }
//        }
//    }];
}


//code	subCode	msg	remark
//200	000	success	目前系统正常返回都是200
//400	038	兑换码绑定用户信息为空，至少需要提供用户id、电话号码，微信公众号之一
//400	039	兑换码为空
//400	040	兑换码已被绑定
//400	041	兑换码未找到
//401	000	auth error	鉴权失败
//500	000	server error	系统异常

/// 兑换码绑定用户信息接口
+ (void)requestForBindingRedeem:(NSString *)redeemCode userWeixinOpenid:(NSString *)openId block:(void (^)(BOOL success, NSError *error))block {
    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"uid"] = [WVRUserModel sharedInstance].accountId;
//    param[@"phoneNum"] = [WVRUserModel sharedInstance].mobileNumber;
//    param[@"redeemCode"] = redeemCode;
//    param[@"userWeixinOpenid"] = openId;
//    
//    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
//    NSString *str = [NSString stringWithFormat:@"%@%@%@", param[@"uid"], param[@"phoneNum"], param[@"userWeixinOpenid"]];
//    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
//    
//    param[@"sign"] = sign;
//    
//    [WVRWhaleyHTTPManager POSTService:@"newVR-report-service/redeemCode/bindingRedeem" withParams:param completionBlock:^(id responseObj, NSError *error) {
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
//                BOOL result = [data[@"result"] boolValue];
//                
//                block(result, nil);
//                
//            } else {
//                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
//                block(nil, err);
//            }
//        }
//    }];
}

@end


@implementation WVRExchangeTicketDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"descriptionStr" : @"description", };
}

@end


@implementation WVRRelatedTicketsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"packsCoupons" : [WVRExchangeTicketDetailModel class], };
}

@end


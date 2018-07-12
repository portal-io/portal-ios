//
//  WVRMyOrderItemModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyOrderItemModel.h"
#import "WVRRequestClient.h"
#import "SQMD5Tool.h"
#import "YYModel.h"
#import <WVRAppContextHeader.h>

NSString * const GOODS_TYPE_LIVE = @"live";
NSString * const GOODS_TYPE_RECORD = @"recorded";
NSString * const GOODS_TYPE_CONTENT_PACKGE = @"content_packge";
NSString * const GOODS_TYPE_COUPON = @"coupon";
NSString * const GOODS_TYPE_WHALEYCURRENCY = @"whaleyCurrency";

@implementation WVRMyOrderItemModel

#pragma mark - getter

- (PurchaseProgramType)purchaseType {
    
    return [WVRMyOrderItemModel purchaseTypeForGoodType:_merchandiseType];
}

+ (PurchaseProgramType)purchaseTypeForGoodType:(NSString *)goodsType {
    
    if ([goodsType isEqualToString:GOODS_TYPE_RECORD]) {
        return PurchaseProgramTypeVR;
    } else if ([goodsType isEqualToString:GOODS_TYPE_LIVE]) {
        return PurchaseProgramTypeLive;
    } else if ([goodsType isEqualToString:GOODS_TYPE_CONTENT_PACKGE]) {
        return PurchaseProgramTypeCollection;
    } else if ([goodsType isEqualToString:GOODS_TYPE_COUPON]) {
        return PurchaseProgramTypeTicket;
    }
    
    DDLogError(@"merchandiseType：%@ 未约定", goodsType);
    
    return PurchaseProgramTypeVR;
}

+ (NSString *)goodsTypeForPurchaseType:(PurchaseProgramType)purchaseType {
    
    switch (purchaseType) {
        case PurchaseProgramTypeVR:
            return GOODS_TYPE_RECORD;
            
        case PurchaseProgramTypeLive:
            return GOODS_TYPE_LIVE;
            
        case PurchaseProgramTypeCollection:
            return GOODS_TYPE_CONTENT_PACKGE;
            
        case PurchaseProgramTypeTicket:
            return GOODS_TYPE_COUPON;
    }
    
    DDLogError(@"purchaseType：%ld 未约定", purchaseType);
    
    return GOODS_TYPE_COUPON;
}

#pragma mark - request

+ (void)requestForMyOrderListWithPage:(int)page pageSize:(int)pageSize block:(void (^)(WVRMyOrderListModel *model, NSError *error))block {
    
    NSString *urlStr = @"newVR-report-service/order/orderList";
    urlStr = [[WVRUserModel kNewVRBaseURL] stringByAppendingString:urlStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [WVRUserModel sharedInstance].accountId;
    dict[@"page"] = [NSString stringWithFormat:@"%d", page];
    dict[@"size"] = [NSString stringWithFormat:@"%d", pageSize];
    
    NSDictionary *param = [[self class] signForParams:dict];
    
    [WVRRequestClient POSTService:urlStr withParams:param completionBlock:^(id responseObj, NSError *error) {
        
        NSDictionary *dic = responseObj;
        int code = [dic[@"code"] intValue];
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        NSDictionary *resDict = dic[@"data"];
        
        if (!error && code == 200) {
            
            WVRMyOrderListModel *model = [WVRMyOrderListModel yy_modelWithDictionary:resDict];
            
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

+ (void)requestForDeviceCheck:(void (^)(BOOL signSuccess))block {
    
    NSString *urlStr = @"newVR-report-service/userPlayDevice/query";
    urlStr = [[WVRUserModel kNewVRBaseURL] stringByAppendingString:urlStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [WVRUserModel sharedInstance].accountId;
    dict[@"deviceId"] = [WVRUserModel sharedInstance].deviceId;
    
    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
    NSString *str = [NSString stringWithFormat:@"%@%@", dict[@"uid"], dict[@"deviceId"]];
    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
    
    dict[@"sign"] = sign;
    
    [WVRRequestClient POSTService:urlStr withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        NSDictionary *dic = responseObj;
        NSString *msg = dic[@"msg"];
        int code = [dic[@"code"] intValue];
        
        BOOL isSign = [dic[@"data"] boolValue];
        
        if (!error && code == 200) {
            
            if (!isSign) {
                
                block(isSign);
            }
        } else {
            DDLogError(@"%d -- %@", code, msg);
        }
    }];
}

+ (void)requestForReportPlayDevice:(void (^)(BOOL success))block {
    
    NSString *urlStr = @"newVR-report-service/userPlayDevice/report";
    urlStr = [[WVRUserModel kNewVRBaseURL] stringByAppendingString:urlStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [WVRUserModel sharedInstance].accountId;
    dict[@"deviceId"] = [WVRUserModel sharedInstance].deviceId;
    
    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
    NSString *str = [NSString stringWithFormat:@"%@%@", dict[@"uid"], dict[@"deviceId"]];
    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
    
    dict[@"sign"] = sign;
    
    [WVRRequestClient POSTService:urlStr withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        if (block) {
            NSDictionary *dict = responseObj;
            int code = [dict[@"code"] intValue];
            BOOL success = (code == 200);
            
            block(success);
        }
    }];
}

+ (void)requestForQueryProgramCharged:(NSString *)goodsNo goodsType:(PurchaseProgramType)goodsType block:(void (^)(BOOL isCharged, NSError *error))block {
    
    NSString *urlStr = @"newVR-report-service/order/goodsPayed";
    urlStr = [[WVRUserModel kNewVRBaseURL] stringByAppendingString:urlStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [WVRUserModel sharedInstance].accountId;
    dict[@"goodsNo"] = goodsNo;
    dict[@"goodsType"] = [WVRMyOrderItemModel goodsTypeForPurchaseType:goodsType];
    
    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
    NSString *str = [NSString stringWithFormat:@"%@%@%@", dict[@"uid"], dict[@"goodsNo"], dict[@"goodsType"]];
    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
    
    dict[@"sign"] = sign;
    
    [WVRRequestClient POSTService:urlStr withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        NSDictionary *dic = responseObj;
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        int code = [dic[@"code"] intValue];
        
        BOOL isSign = [dic[@"data"][@"result"] boolValue];
        
        if (!error && code == 200) {
            
            block(isSign, nil);
        } else {
            if (error) {
                block(NO, error);
            } else {
                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
                block(NO, err);
            }
        }
    }];
}

+ (NSDictionary *)signForParams:(NSMutableDictionary *)dict {
    
    NSString *key = [WVRUserModel CMCPURCHASE_sign_secret];
    NSString *str = [NSString stringWithFormat:@"%@%@%@", dict[@"uid"], dict[@"page"], dict[@"size"]];
    NSString *sign = [SQMD5Tool encryptByMD5:str md5Suffix:key];
    
    dict[@"sign"] = sign;
    
    return dict;
}


@end


@implementation WVRMyOrderListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"content" : [WVRMyOrderItemModel class], };
}

@end


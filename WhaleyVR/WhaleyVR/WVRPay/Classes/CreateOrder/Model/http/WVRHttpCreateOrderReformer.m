//
//  WVRHttpCreateOrderReformer.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpCreateOrderReformer.h"
#import "WVRHttpModelCreateOrder.h"
#import "WVROrderModel.h"

@implementation WVRHttpCreateOrderReformer

- (WVROrderModel *)reformData:(NSDictionary *)data {
    
    NSString * statusCode = data[@"code"];
    NSString * subStatusCode = data[@"subCode"];
    NSDictionary *resultDictionary = [super reformData:data];
    WVRHttpModelCreateOrder *httpOrderModel = [WVRHttpModelCreateOrder yy_modelWithDictionary:resultDictionary];
    if (!httpOrderModel) {
        httpOrderModel = [WVRHttpModelCreateOrder new];
    }
    httpOrderModel.subStatusCode = subStatusCode;
    httpOrderModel.statusCode = statusCode;

    WVROrderModel *orderModel = [WVROrderModel new];
    
    orderModel.signDataStr = httpOrderModel.orderToPayStr;
    orderModel.statusCode = httpOrderModel.statusCode;
    orderModel.subStatusCode = httpOrderModel.subStatusCode;
    orderModel.msg = httpOrderModel.msg;
    
    orderModel.orderNo = httpOrderModel.orderNo;
    orderModel.iosProductCode = httpOrderModel.iosProductCode;
    
    return orderModel;
}

@end

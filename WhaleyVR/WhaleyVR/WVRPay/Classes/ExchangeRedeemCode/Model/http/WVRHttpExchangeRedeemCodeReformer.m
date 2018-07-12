//
//  WVRHttpExchangeRedeemCodeReformer.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpExchangeRedeemCodeReformer.h"
#import "WVRMyTicketListModel.h"

@implementation WVRHttpExchangeRedeemCodeReformer

- (WVRMyTicketItemModel *)reformData:(NSDictionary *)data {
    
    NSDictionary *resultDictionary = [super reformData:data];
    
    WVRMyTicketItemModel *orderModel = [WVRMyTicketItemModel yy_modelWithDictionary:resultDictionary];
    
    return orderModel;
}
@end

//
//  WVRMyTicketReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyTicketReformer.h"
#import "WVRMyTicketListModel.h"

@implementation WVRMyTicketReformer

#pragma mark - WVRAPIManagerDataReformer protocol

- (WVRMyTicketListModel *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRMyTicketListModel *model = [WVRMyTicketListModel yy_modelWithDictionary:businessDictionary];
    
    return model;
}

@end

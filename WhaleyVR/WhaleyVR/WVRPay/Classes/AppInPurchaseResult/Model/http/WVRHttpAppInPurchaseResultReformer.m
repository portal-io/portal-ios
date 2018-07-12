//
//  WVRHttpAppInPurchaseResultReformer.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpAppInPurchaseResultReformer.h"

@implementation WVRHttpAppInPurchaseResultReformer

- (id)reformData:(NSDictionary *)data {
    
    WVRAppInPurchaseResultModel *model = [WVRAppInPurchaseResultModel yy_modelWithDictionary:data];
    
    return model;
}

@end

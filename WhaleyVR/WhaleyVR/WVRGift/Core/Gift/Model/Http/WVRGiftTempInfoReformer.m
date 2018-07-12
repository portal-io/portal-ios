//
//  WVRGiftTempInfoReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftTempInfoReformer.h"
#import "WVRHttpGiftTempModel.h"

@implementation WVRGiftTempInfoReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRGiftModel*>*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpGiftTempModel * model = [WVRHttpGiftTempModel yy_modelWithDictionary:businessDictionary];
    
    return model.giftList;
}
@end

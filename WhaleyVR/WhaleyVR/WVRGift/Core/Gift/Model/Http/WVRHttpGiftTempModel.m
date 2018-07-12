//
//  WVRHttpGiftModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpGiftTempModel.h"

@implementation WVRHttpGiftTempModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"giftList": WVRGiftModel.class };
}
@end

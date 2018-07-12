//
//  WVRHttpTVElementModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpTVElementModel.h"

@implementation WVRHttpTVElementModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"picUrl" : @"newPicUrl", @"Id" : @"id" };
}

@end

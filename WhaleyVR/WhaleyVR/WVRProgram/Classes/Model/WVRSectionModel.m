//
//  WVRSectionModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSectionModel.h"

@implementation WVRSectionModel

- (BOOL)programPackageHaveCharged {
    if (self.discountPrice==nil) {
        return _packModel.price == 0 ? YES : NO;
    } else {
        return [self.discountPrice integerValue] == 0 ? YES : NO;
    }
}

- (long)price
{
    if (self.discountPrice == nil) {
        return _packModel.price;
    } else {
        return [self.discountPrice integerValue];
    }
}

@end

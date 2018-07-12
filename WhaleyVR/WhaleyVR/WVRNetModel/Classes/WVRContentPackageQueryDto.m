//
//  WVRContentPackageQueryDto.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRContentPackageQueryDto.h"

@implementation WVRContentPackageQueryDto

- (instancetype)init {
    self = [super init];
    if (self) {
        _couponDto = [[WVRCouponDto alloc] init];
    }
    return self;
}

#pragma mark - getter

/// 现在的需求是只购买券，所以商品自身的价格没有意义，只返回券价格 (券可能会有折扣价格)
- (long)price {
    
    return [_couponDto price];
}

- (WVRPackageType)packageType {
    
    return self.type.integerValue;
}

@end


@implementation WVRCouponDto

#pragma mark - getter

- (long)price {
    
    if (self.discountPrice != nil) {
        return [self.discountPrice integerValue];
    }
    
    return _price;
}

@end

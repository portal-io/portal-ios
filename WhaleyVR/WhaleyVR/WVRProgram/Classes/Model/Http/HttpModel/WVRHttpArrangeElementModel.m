//
//  WVRHttpArrangeElementModel.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpArrangeElementModel.h"

@implementation WVRHttpArrangeElementModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{ @"Id" : @"id", };
}

/// 3D电影自动编排sid值存储在linkId字段中
- (NSString *)linkArrangeValue {
    
    if (_linkArrangeValue) {
        return _linkArrangeValue;
    }
    
    return _linkId;
}

@end


@implementation StatQueryDto

@end


@implementation WVRHttpArrangeEleFByCModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"arrangeTreeElements": WVRHttpArrangeElementModel.class};
}

@end

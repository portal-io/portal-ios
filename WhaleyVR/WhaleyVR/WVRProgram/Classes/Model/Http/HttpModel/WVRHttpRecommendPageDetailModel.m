//
//  WVRHttpRecommendPageDetailModel.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpRecommendPageDetailModel.h"

@implementation WVRHttpRecommendElement

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id",
              @"picUrlNew": @"newPicUrl",
              @"picUrlNew":@"picUrl",
              @"itemName":@"name",
              };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"arrangeElements":WVRHttpArrangeElement.class };
}

@end


@implementation WVRHttpRecommendArea

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id"};
}

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"recommendElements": WVRHttpRecommendElement.class};
}

@end


@implementation WVRHttpRecommendPageDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id"};
}

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"recommendAreas":WVRHttpRecommendArea.class};
}


@end

@implementation WVRHttpArrangeElement

@end

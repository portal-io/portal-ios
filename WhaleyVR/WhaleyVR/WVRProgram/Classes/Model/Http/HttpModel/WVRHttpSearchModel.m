//
//  WVRHttpSearchModel.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpSearchModel.h"

@implementation WVRHttpSearchModel
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"program": WVRHttpSimpleProgramModel.class,@"arrange": WVRHttpSimpleArrangeModel.class};
}

@end
@implementation WVRHttpSimpleProgramModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"desc" : @"description"};
}

@end
@implementation WVRHttpSimpleArrangeModel

@end

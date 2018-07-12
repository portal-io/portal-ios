//
//  WVRHttpRecommendPaginationContentModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpRecommendPaginationContentModel.h"

@implementation WVRHttpRecommendPaginationContentModel
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"content": WVRHttpRecommendElement.class};
}
@end

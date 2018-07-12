//
//  WVRHttpTVRecommendElementModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpTVRecommendElementsModel.h"

@implementation WVRHttpTVRecommendElementsModel
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"content": WVRHttpTVElementModel.class};
}
@end

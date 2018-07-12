//
//  WVRHttpSearchRecommendModel.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpSearchRecommendModel.h"

@implementation WVRHttpSearchRecommendModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"descriptionStr" : @"description", @"Id" : @"id" };
}

@end


@implementation WVRHttpMediaDtosModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end


@implementation WVRHttpDownloadDtosModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end


@implementation WVRHttpStatModel

@end

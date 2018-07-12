//
//  WVRHttpLiveDetailModel.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpLiveDetailModel.h"

@implementation WVRHttpLiveDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"descriptionStr" : @"description", @"Id": @"id" };
}

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{ @"guests" : WVRHttpGuestModel.class,
              @"liveMediaDtos" : WVRMediaDto.class,
              @"contentPackageQueryDtos" : [WVRContentPackageQueryDto class],
             };
}

- (NSString *)tags {
    
    return nil;
}

@end


@implementation WVRHttpGuestModel

@end


@implementation WVRHttpLiveStatModel

@end

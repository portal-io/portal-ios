//
//  WVRHttpProgramModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpProgramModel.h"

@implementation WVRHttpProgramModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"desc" : @"description", @"Id": @"id" };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"medias": WVRHttpProgramMediasModel.class,
              @"downloadDtos" : WVRHttpProgramDownloadDtoModel.class,
              @"series" : WVRHttpProgramModel.class,
             };
}

@end


@implementation WVRHttpProgramMediasModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end


@implementation WVRHttpProgramDownloadDtoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end


@implementation WVRHttpProgramStatModel

@end

//
//  WVRShowFieldRoomModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRShowFieldRoomModel.h"

@implementation WVRShowFieldRoomModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"roomdata" : [WVRShowFieldRoomData class] };
}

@end


@implementation WVRShowFieldRoomData

@end

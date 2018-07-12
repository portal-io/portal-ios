//
//  WVRHttpFootballListModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpFootballListModel.h"

@implementation WVRHttpFootballListModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"Replay": WVRHttpFootballModel.class,
             @"Trailer":WVRHttpFootballModel.class,
             @"Live":WVRHttpFootballModel.class,
             @"Ad":WVRHttpFootballADModel.class};
}

//+ (Class)modelCustomClassForDictionary:(NSDictionary*)dictionary {
//    if (dictionary[@"Trailer"] != nil) {
//        return [WVRHttpFootballModel class];
//    } else if (dictionary[@"Live"] != nil) {
//        return [WVRHttpFootballModel class];
//    } else if (dictionary[@"Ad"] != nil) {
//        return [WVRHttpFootballADModel class];
//    } else if (dictionary[@"Replay"] != nil) {
//        return [WVRHttpFootballModel class];
//    }
//    else {
//        return [self class];
//    }
//}
@end

@implementation WVRHttpFootballTeamModel

@end


@implementation WVRHttpFootballADModel


+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"Ad": WVRHttpFootballADModel.class};
}

@end


@implementation WVRHttpFootballModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"Teams": WVRHttpFootballTeamModel.class };
}

@end

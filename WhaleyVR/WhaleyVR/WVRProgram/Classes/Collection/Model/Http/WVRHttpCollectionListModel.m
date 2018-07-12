//
//  WVRHttpCollectionListModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpCollectionListModel.h"

@implementation WVRHttpCollectionListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"content": WVRHttpCollectionModel.class };
}
@end


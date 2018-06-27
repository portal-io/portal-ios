//
//  WVRHttpUserInfoReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpUserInfoReformer.h"
#import "WVRHttpUserModel.h"

@implementation WVRHttpUserInfoReformer

- (id)reformData:(NSDictionary *)data {
    WVRHttpUserModel *resSuccess = [WVRHttpUserModel yy_modelWithDictionary:[data valueForKey:@"data"]];
//    [self updateUserDefaultInfo:resSuccess];
    return resSuccess;
}
@end

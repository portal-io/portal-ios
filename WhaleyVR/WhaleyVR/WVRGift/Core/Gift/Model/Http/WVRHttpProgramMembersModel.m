//
//  WVRHttpGiftModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpProgramMembersModel.h"

@implementation WVRHttpProgramMembersModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"memberTemplateRelDtos": WVRProgramMemberModel.class };
}
@end

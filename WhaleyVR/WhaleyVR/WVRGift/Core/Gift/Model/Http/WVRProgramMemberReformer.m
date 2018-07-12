//
//  WVRGiftTempInfoReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRProgramMemberReformer.h"
#import "WVRHttpProgramMembersModel.h"

@implementation WVRProgramMemberReformer
#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRProgramMemberModel*>*)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpProgramMembersModel * model = [WVRHttpProgramMembersModel yy_modelWithDictionary:businessDictionary];
    
    return model.memberTemplateRelDtos;
}
@end

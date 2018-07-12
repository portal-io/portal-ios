//
//  WVRRewardModel.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"
#import "WVRAddressModel.h"
#import "SQDateTool.h"
#import "WVRRewardModel.h"

@interface WVRRewardSectionModel : WVRBaseModel

@property (nonatomic) NSString * formatDateKey;
@property (nonatomic) NSArray<WVRRewardModel*>* rewards;

@end


@interface WVRRewardVCModel : WVRBaseModel

@property (nonatomic) WVRAddressModel * addressModel;
@property (nonatomic) NSArray<WVRRewardSectionModel*>* sectionRewards;

@end

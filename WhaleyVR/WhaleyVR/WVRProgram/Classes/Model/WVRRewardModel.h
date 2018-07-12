//
//  WVRRewardModel.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"

typedef NS_ENUM(NSInteger, WVRRewardModelType) {
    WVRRewardModelTypeDefault,
    WVRRewardModelTypeCodeEXCode,
    WVRRewardModelTypeVirtualCard,
    WVRRewardModelTypeVirtualCardNoCopy,
};

@interface WVRRewardModel : WVRBaseModel

@property (nonatomic) NSString * title;
@property (nonatomic) NSString * thubImageStr;

@property (nonatomic) WVRRewardModelType rewardType;
@property (nonatomic) NSString * rewardInfo;

@property (nonatomic) NSString * formatDateStr;
@property (nonatomic) NSString * formatDateKey;
@end

//
//  WVRRewardReformer.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRNetDataReformerCMS.h>
#import "WVRHttpRewardModel.h"
#import "WVRHttpAddressModel.h"

@interface WVRHttpRewardListModel : NSObject

@property (nonatomic) NSArray<WVRHttpRewardModel *> * prizesdata;
@property (nonatomic) WVRHttpAddressModel * addressdata;

@end
@interface WVRRewardReformer : WVRNetDataReformerCMS

@end

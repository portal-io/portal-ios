//
//  WVRNetDataReformerAccount+updateUser.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetDataReformerAccount.h"

@class WVRHttpUserModel;

@interface WVRNetDataReformerAccount (updateUser)

- (void)updateUserDefaultInfo:(WVRHttpUserModel *)resSuccess;

@end

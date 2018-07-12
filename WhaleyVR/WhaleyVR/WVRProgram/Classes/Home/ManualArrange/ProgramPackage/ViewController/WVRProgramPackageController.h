//
//  WVRProgramPackageController.h
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRManualArrangeController.h"

@interface WVRProgramPackageController : WVRManualArrangeController

@property (nonatomic, copy) void(^prePayResultBlock)(void);

@end

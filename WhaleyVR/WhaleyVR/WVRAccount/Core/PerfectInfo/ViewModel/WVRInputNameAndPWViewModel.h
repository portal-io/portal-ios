//
//  WVRInputNameAndPWViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRInputNameAndPWViewModel : WVRViewModel
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * password;

@property (nonatomic, strong, readonly) RACSignal * completeSignal;

-(RACCommand*)finishNamePWCmd;

@end

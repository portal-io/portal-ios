//
//  WVRModifyPWUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAccountUseCase.h"

@interface WVRModifyPWUseCase : WVRAccountUseCase

@property (nonatomic, strong) NSString * oldPW;
@property (nonatomic, strong) NSString * inputPW;

@end

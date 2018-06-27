//
//  WVRModifyPhoneNUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/25.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAccountUseCase.h"

@interface WVRModifyPhoneNUseCase : WVRAccountUseCase

@property (nonatomic, strong) NSString * inputCode;

@property (nonatomic, strong) NSString * inputPhoneNum;

@end

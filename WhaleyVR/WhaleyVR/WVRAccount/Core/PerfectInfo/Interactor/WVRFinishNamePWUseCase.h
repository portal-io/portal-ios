//
//  WVRFinishNamePWUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAccountUseCase.h"

@interface WVRFinishNamePWUseCase : WVRAccountUseCase

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * password;
@end

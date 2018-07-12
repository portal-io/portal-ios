//
//  WVRThirtyPBindUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAccountUseCase.h"

@interface WVRThirtyPBindUseCase : WVRAccountUseCase
@property (nonatomic, assign) NSInteger  origin;
@property (nonatomic, strong) NSString * unionId;
@end

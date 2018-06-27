//
//  WVRThirtyPAuthUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRThirtyPAuthUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, assign) NSInteger  origin;

@property (nonatomic, strong) NSString * openId;
@property (nonatomic, strong) NSString * unionId;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;

@end

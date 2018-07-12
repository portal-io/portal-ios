//
//  LoginUseCase.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/8/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRUseCase.h"
#import "WVRModelUserInfo.h"

@interface WVRLoginUseCase : WVRUseCase<WVRUseCaseProtocol>

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) WVRModelUserInfo *modelUserInfo;

@end

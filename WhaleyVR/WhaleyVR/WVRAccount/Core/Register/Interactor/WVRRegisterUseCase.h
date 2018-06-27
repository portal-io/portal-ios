//
//  WVRRegisterUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"
#import "WVRModelUserInfo.h"
#import "WVRThirtyPLoginModel.h"

@interface WVRRegisterUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *thirdId;


@property(nonatomic, strong) WVRModelUserInfo *userInfo;

@property (nonatomic, strong) WVRThirtyPLoginModel * tpLoginModel;




@end

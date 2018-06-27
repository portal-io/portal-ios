//
//  WVRBindWhaleyAccountUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRInteractor/WVRUseCase.h>

@interface WVRBindWhaleyAccountUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * origin;
@property (nonatomic, strong) NSString * unionId;

@property (nonatomic, strong) NSString * openId;

@property (nonatomic, strong) NSString * thirdId;

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;

@end

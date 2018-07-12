//
//  WVRGiftTempInfoUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRUseCase.h>

@interface WVRGiftTempInfoUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * tempCode;
@property (nonatomic, strong) NSString * pageNum;
@property (nonatomic, strong) NSString * pageSize;

@end

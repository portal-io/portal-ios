//
//  WVRCheckPayUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRCheckPayUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, copy) NSString *goodsNo;
@property (nonatomic, copy) NSString *goodsType;

- (RACCommand *)checkPayCmd;

@end

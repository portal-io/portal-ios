//
//  WVRMyOrderListUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRMyOrderListUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * page;

@property (nonatomic, strong) NSString * size;

@end

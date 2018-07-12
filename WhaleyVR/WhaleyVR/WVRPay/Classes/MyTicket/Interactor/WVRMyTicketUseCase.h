//
//  WVRMyTicketUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRMyTicketUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * page;

@property (nonatomic, strong) NSString * size;

@end

//
//  WVRAllChannelUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRUseCase.h>

@interface WVRAutoArrangeUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString* code;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@end

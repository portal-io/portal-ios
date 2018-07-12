//
//  WVRAllChannelUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRUseCase.h>

@interface WVRCollectionDelUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * delIds;

@end

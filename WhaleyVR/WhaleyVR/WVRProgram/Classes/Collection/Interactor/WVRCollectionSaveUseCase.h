//
//  WVRAllChannelUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRCollectionSaveUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * programType;
@property (nonatomic, strong) NSString * programName;
@property (nonatomic, strong) NSString * videoType;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * picUrl;

@end

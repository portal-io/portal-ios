//
//  WVRVideoDetailInfoUseCase.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/9/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRVideoDetailInfoUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy) NSString *urlString;

@end

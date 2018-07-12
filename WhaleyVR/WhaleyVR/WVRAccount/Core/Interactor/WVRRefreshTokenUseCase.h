//
//  WVRRefreshTokenUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRRefreshTokenUseCase : WVRUseCase<WVRUseCaseProtocol>

- (BOOL)filterTokenValide:(NSString *)code retryCmd:(RACCommand *)cmd;

@end

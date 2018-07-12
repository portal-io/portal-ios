//
//  WVRPayCallbackUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRPayCallbackUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * payMethod;

-(RACCommand *)payCallbackCmd;
@end

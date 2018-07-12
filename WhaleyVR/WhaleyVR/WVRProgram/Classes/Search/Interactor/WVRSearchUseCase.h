//
//  WVRSearchUseCase.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WVRUseCase.h>

@interface WVRSearchUseCase : WVRUseCase<WVRUseCaseProtocol>


@property (nonatomic, strong) NSString * keyWord;
@property (nonatomic, strong) NSString * type;

@end

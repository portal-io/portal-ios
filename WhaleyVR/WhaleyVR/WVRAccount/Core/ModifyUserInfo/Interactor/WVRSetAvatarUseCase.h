//
//  WVRSetAvatarUseCase.h
//  WVRAccount
//
//  Created by qbshen on 2017/9/13.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "WVRAccountUseCase.h"

@interface WVRSetAvatarUseCase : WVRAccountUseCase

@property (nonatomic, strong) NSData * fileData;
@property (nonatomic, strong) NSString * keyName;
@property (nonatomic, strong) NSString * fileName;


@property (nonatomic, strong) NSString * gResponseMsg;

@end

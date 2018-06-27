//
//  WVRAccountUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAccountUseCase.h"

@implementation WVRAccountUseCase

- (void)initRequestApi
{
    
}
- (RACSignal *)buildUseCase
{
    return nil;
}
- (RACSignal *)buildErrorCase
{
 return nil;
}
- (RACCommand *)getRequestCmd {
    return self.requestApi.requestCmd;
}
@end

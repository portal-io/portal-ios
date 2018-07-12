//
//  WVRHalfScreenPlayView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHalfScreenPlayView.h"

@implementation WVRHalfScreenPlayView

+ (instancetype)createWithInfo:(WVRHalfScreenPlayViewInfo*)vInfo
{
    WVRHalfScreenPlayView * pageV = [[WVRHalfScreenPlayView alloc] initWithFrame:vInfo.frame withVInfo:vInfo];
    return pageV;
}

- (instancetype)initWithFrame:(CGRect)frame withVInfo:(WVRHalfScreenPlayViewInfo*)vInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
@end


@implementation WVRHalfScreenPlayViewInfo

@end

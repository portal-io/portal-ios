
//
//  WVRTVVideoDetailViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVVideoDetailViewModel.h"
#import "WVRTVVideoDetailUseCase.h"

@implementation WVRTVVideoDetailViewModel
@synthesize gDetailUC =_gDetailUC;

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (WVRTVVideoDetailUseCase *)gDetailUC {
    
    if (!_gDetailUC) {
        _gDetailUC = [[WVRTVVideoDetailUseCase alloc] init];
    }
    return (WVRTVVideoDetailUseCase*)_gDetailUC;
}

@end

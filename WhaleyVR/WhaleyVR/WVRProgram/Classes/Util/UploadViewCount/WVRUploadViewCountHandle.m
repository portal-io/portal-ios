//
//  WVRUploadViewCountHandle.m
//  WhaleyVR
//
//  Created by Bruce on 2017/9/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUploadViewCountHandle.h"
#import "WVRUploadViewCountUseCase.h"

@implementation WVRUploadViewCountHandle

+ (void)uploadViewInfoWithCode:(NSString *)srcCode programType:(NSString *)programType videoType:(NSString *)videoType type:(NSString *)type sec:(NSString *)sec title:(NSString *)title {
    
    WVRUploadViewCountUseCase *uc = [[WVRUploadViewCountUseCase alloc] init];
    
    uc.srcCode = srcCode;
    uc.programType = programType;
    uc.videoType = videoType;
    uc.type = type;
    uc.sec = sec;
    uc.title = title;
    
    [uc.requestCmd execute:nil];
}

@end

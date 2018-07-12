//
//  WVRBaseToastView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseToastView.h"
#import "SQToastTool.h"
#import "WVRWidgetToastHeader.h"

@implementation WVRBaseToastView

- (void)showToast:(NSString *)content {
    
    SQToastInKeyWindow(content);
}

@end

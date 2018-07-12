//
//  WVRLiveInfoAlertView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveInfoAlertView.h"

@interface WVRLiveInfoAlertView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation WVRLiveInfoAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.bgView addGestureRecognizer:tapG];
}

- (void)dismissView {
    [WVRComputeTool numberToString:1];
    [self removeFromSuperview];
}

- (BOOL)playerUINotAutoHide {
    
    return YES;
}

@end

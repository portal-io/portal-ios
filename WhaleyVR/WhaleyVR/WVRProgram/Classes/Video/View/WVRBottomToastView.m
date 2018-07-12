//
//  WVRBottomToastView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBottomToastView.h"

@interface WVRBottomToastView ()

@property (nonatomic) WVRBottomToastViewInfo * viewInfo;
@property (weak, nonatomic) IBOutlet UILabel * titleL;

- (IBAction)dismisOnClick:(id)sender;

@end


@implementation WVRBottomToastView

- (void)updateWithInfo:(WVRBottomToastViewInfo *)info
{
    self.titleL.text = info.title;
    self.viewInfo = info;
}

- (IBAction)dismisOnClick:(id)sender {
    if (self.viewInfo.dismissBlock) {
        self.viewInfo.dismissBlock();
    }
    [self removeFromSuperview];
}

@end


@implementation WVRBottomToastViewInfo

@end

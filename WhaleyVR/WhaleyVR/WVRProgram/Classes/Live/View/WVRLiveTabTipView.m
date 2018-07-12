//
//  WVRLiveTabTipView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveTabTipView.h"

@implementation WVRLiveTabTipView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self addGestureRecognizer:tapG];
}

-(void)dismissView
{
    [self removeFromSuperview];
}

@end

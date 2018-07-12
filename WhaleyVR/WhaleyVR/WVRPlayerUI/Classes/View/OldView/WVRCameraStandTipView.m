//
//  WVRCameraStandTipView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCameraStandTipView.h"

@implementation WVRCameraStandTipView

- (instancetype)initWithX:(float)centerX y:(float)bottomY {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        [self createTipWithX:centerX y:bottomY];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)createTipWithX:(float)centerX y:(float)bottomY {
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_stand_tip"]];
    
    imgV.centerX = centerX;
    imgV.bottomY = bottomY + 17;
    imgV.userInteractionEnabled = NO;
    
    [self addSubview:imgV];
}

- (void)tapAction {
    
    [self removeFromSuperview];
}

@end

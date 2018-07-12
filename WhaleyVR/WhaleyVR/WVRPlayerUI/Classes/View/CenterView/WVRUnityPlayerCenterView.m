//
//  WVRUnityPlayerCenterView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityPlayerCenterView.h"

@implementation WVRUnityPlayerCenterView

- (instancetype)initWithViewModel:(WVRUnityPlayerViewModel *)viewModel {
    self = [super init];
    if (self) {
        
        [self setViewModel:viewModel];
        
        [self configSelf];
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.centerX = self.superview.width * 0.5f;
    self.centerY = self.superview.height * 0.124f;
}

- (void)configSelf {
    
    self.hidden = YES;
    
    self.backgroundColor = [UIColor clearColor];
    float height = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) * 0.174f;
    self.frame = CGRectMake(0, 0, fitToWidth(150), height);
}

- (void)createSubViews {
    
    [self addImageView];
}

- (void)addImageView {
    
    float width = self.height;
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [view setBackgroundColor:k_Color_hex(0x313131)];
    
    view.layer.cornerRadius = width * 0.5;
    view.layer.masksToBounds = YES;
    
    [self addSubview:view];
    view.centerX = self.width * 0.5;
}

// MARK: - action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.viewModel hotSpotClick:@"0"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (point.x >= 0 && point.x <= self.width && point.y >= 0 && point.y <= self.height) {
    
        [self.viewModel hotSpotClick:@"1"];
    } else {
        
        [self.viewModel hotSpotClick:@"2"];
    }
}

/// 与其他控件隐藏状态相反
- (BOOL)playerUIHideOpposite {
    
    return YES;
}

@end

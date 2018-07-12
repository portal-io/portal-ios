//
//  WVRAlertBaseView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/27/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRAlertBaseView.h"
#import "UIColor+Extend.h"
#import "CAAnimation+Extension.h"

#define __APPEAR_DURATION             0.3
#define __DISAPPEAR_DURATION          0.3
#define __GLASS_BOARD_DEFAULT_ALPHA   0.4

@implementation WVRAlertBaseView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        CGRect tmpRect = CGRectZero;
        
        /* Self config */
        {
            tmpRect.size = [UIScreen mainScreen].bounds.size;
            [self setFrame:tmpRect];
        }
        
        /* Alloc subviews */
        {
            _glassBoard = [[UIView alloc] init];
            _baseBoard = [[UIView alloc] init];
        }
        
        /* Config subviews */
        {
            /* Glass board */
            [_glassBoard setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:__GLASS_BOARD_DEFAULT_ALPHA]];
            
            /* Base board */
            [_baseBoard setBackgroundColor:[UIColor clearColor]];
            [self addSubview:_glassBoard];
            [self addSubview:_baseBoard];
        }
        
        /* Position subviews */
        {
            /* Glass board */
            tmpRect = self.bounds;
            [_glassBoard setFrame:tmpRect];
        }
    }
    
    return self;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (NO == _enableBgTouchDisappear) {
        return;
    }
    
    for (UITouch *touch in touches) {
        
        CGPoint tmpPoint = [touch locationInView:_baseBoard];
        if (NO == [_baseBoard pointInside:tmpPoint withEvent:event]) {
            [self disappearHandle];
        }
    }
}

#pragma mark - MISC
- (void)disappearHandle {
    float animationDuration = __DISAPPEAR_DURATION;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        
        [self disappearCompleteCallback];
        [self removeFromSuperview];
    }];
    
    /* Base board animation */
    CGPoint startCenter = _baseBoard.center;
    CGPoint endCenter = _baseBoard.center;
    endCenter.y += [UIScreen mainScreen].bounds.size.height;
    
    CAAnimation *ani = [CAAnimation mzMoveAnimationWithDuration:animationDuration startPoint:startCenter endPoint:endCenter];
    [_baseBoard.layer addAnimation:ani forKey:nil];
}

- (void)disappearCompleteCallback {
    
}

#pragma mark - User interface
- (void)showOnView:(UIView *)parentView {
    [self removeFromSuperview];
    
    [parentView addSubview:self];
    float animationDuration = __APPEAR_DURATION;
    
    [self setAlpha:1];
    /* Base board animation */
    CGPoint startCenter = _baseBoard.center;
    CGPoint endCenter = _baseBoard.center;
    startCenter.y += [UIScreen mainScreen].bounds.size.height;
    
    CAAnimation *ani = [CAAnimation mzMoveAnimationWithDuration:animationDuration startPoint:startCenter endPoint:endCenter];
    [_baseBoard.layer addAnimation:ani forKey:nil];
    
    /* Glass board animation */
    [_glassBoard.layer addAnimation:[CAAnimation mzFadeTransitionWithDuration:animationDuration] forKey:nil];
}

@end

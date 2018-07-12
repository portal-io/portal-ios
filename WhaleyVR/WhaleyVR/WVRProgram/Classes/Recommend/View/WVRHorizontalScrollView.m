//
//  WVRHorizontalScrollView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHorizontalScrollView.h"

@interface WVRHorizontalScrollView ()<UIGestureRecognizerDelegate>

@end


@implementation WVRHorizontalScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        if (self.contentOffset.x <= 0) {
            
            return YES;
        }
    }
    return NO;
}

@end

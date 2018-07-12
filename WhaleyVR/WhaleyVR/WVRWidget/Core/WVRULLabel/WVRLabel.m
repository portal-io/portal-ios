//
//  WVRLabel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLabel.h"

@implementation WVRLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

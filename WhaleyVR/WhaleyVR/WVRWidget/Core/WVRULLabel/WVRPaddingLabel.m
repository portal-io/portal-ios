//
//  WVRPaddingLabel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPaddingLabel.h"



IB_DESIGNABLE
@implementation WVRPaddingLabel


//-(void)setPaddingRight:(CGFloat)paddingRight
//{
//    
//}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius  = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBcolor:(UIColor *)bcolor{
    _bcolor = bcolor;
    self.layer.borderColor = bcolor.CGColor;
}

- (void)setBwidth:(CGFloat)bwidth {
    _bwidth = bwidth;
    self.layer.borderWidth = bwidth;
}

@end

//
//  WVRTragView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTriangleView.h"

@implementation WVRTriangleView

-
(void)drawRect:(CGRect)rect

{
    
    //设置背景颜色
    
    [[UIColor
      clearColor]set];
    
    UIRectFill([self
                
                bounds]);
    
    //拿到当前视图准备好的画板
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context,
                         self.width/2, 0);//设置起点
    
    CGContextAddLineToPoint(context,
                            0, self.height);
    
    CGContextAddLineToPoint(context,
                            self.width, self.height);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor
      whiteColor] setFill]; //设置填充色
    
    [[UIColor
      whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
}

@end

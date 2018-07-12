//
//  WVRCircleProgressButton.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WVRCircleProgressBlock)(void);

@interface WVRCircleProgressButton : UIButton

/**
 set progress color, Default is grayColor
 */
@property (nonatomic, strong) UIColor    *trackColor;

/**
 set track color, Default is redColor
 */
@property (nonatomic, strong) UIColor    *progressColor;

/**
 set track background color, default is blackColor with 0.3 alpha
 */
@property (nonatomic, strong) UIColor    *fillColor;

/**
 set progress line width, default is 2
 */
@property (nonatomic, assign) CGFloat    lineWidth;

/**
 set complete callback

 @param duration duration
 @param block completionBlock
 */
- (void)startAnimationDuration:(CGFloat)duration completionBlock:(WVRCircleProgressBlock)block;

@end

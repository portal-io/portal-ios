//
//  WVRToastView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/26.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRToastView : UIView

- (void)updateMsg:(NSString*)msg yScale:(CGFloat)yScale;

-(void)updateMsg:(NSString*)msg yBottom:(CGFloat)yBottom;

@end

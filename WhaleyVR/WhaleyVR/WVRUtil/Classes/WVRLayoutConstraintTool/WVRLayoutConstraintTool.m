//
//  WVRLayoutConstraintTool.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLayoutConstraintTool.h"

@implementation WVRLayoutConstraintTool

+ (void)addTBLRViewCont:(UIView *)firstsView inSec:(UIView *)secondView {
    
    //view_1(红色)top 距离self.view的top
    NSLayoutConstraint *view_1TopToSuperViewTop = [NSLayoutConstraint constraintWithItem:firstsView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:secondView
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1
                                                                                constant:0];
    //view_3(蓝色)left 距离 self.view left
    NSLayoutConstraint *view_3LeftToSuperViewLeft = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:secondView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1
                                                                                  constant:0];
    
    //view_3(蓝色)right 距离 self.view right
    NSLayoutConstraint *view_3RightToSuperViewRight = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:secondView
                                                                                   attribute:NSLayoutAttributeRight
                                                                                  multiplier:1
                                                                                    constant:0];
    
    //    NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:firstsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    //    [firstsView addConstraints:@[heightCons]];
    //    [firstsView layoutIfNeeded];
    //    //view_3(蓝色)Bottom 距离 self.view bottom
    NSLayoutConstraint *view_3BottomToSuperViewBottom = [NSLayoutConstraint constraintWithItem:firstsView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:secondView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:0];
    //添加约束，因为view_1、2、3是同层次关系，且他们公有的父视图都是self.view，所以这里把约束都添加到self.view上即可
    [secondView addConstraints:@[view_1TopToSuperViewTop,view_3LeftToSuperViewLeft,view_3RightToSuperViewRight,view_3BottomToSuperViewBottom]];
    
    [secondView layoutIfNeeded];
}
@end

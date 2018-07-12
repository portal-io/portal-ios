//
//  SQBaseView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseView.h"
#import "WVRAppContextHeader.h"

@implementation SQBaseView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //        NSLog(@"%ld",(long)constraint.firstAttribute);
        //据底部0
        constraint.constant = fitToWidth(constraint.constant);
    }
    
    for (UIView * view in self.subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
            //            NSLog(@"%ld",(long)constraint.firstAttribute);
            //据底部0
            constraint.constant = fitToWidth(constraint.constant);
        }
    }
}

@end

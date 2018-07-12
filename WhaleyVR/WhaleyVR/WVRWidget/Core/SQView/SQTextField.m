//
//  SQTextField.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTextField.h"


@implementation SQTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColorFromRGB(0xe3e3e3) CGColor];
        self.layer.cornerRadius = 4;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColorFromRGB(0xe3e3e3) CGColor];
    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor whiteColor];
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.frame.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

//-(void)drawPlaceholderInRect:(CGRect)rect
//{
//    CGRect * curRect = CGRectMake(rect.origin.x+, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
//    [self.placeholder drawInRect:rect withAttributes:nil];
//}

@end

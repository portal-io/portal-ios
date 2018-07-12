//
//  WVRTextView.h
//  VRManager
//
//  Created by Snailvr on 16/6/21.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 自定义textView，增加placeholder

#import <UIKit/UIKit.h>

@interface WVRTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end

//
//  SNKeyboardTool.m
//  soccernotes
//
//  Created by sqb on 15/8/3.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "SQKeyboardTool.h"

@interface SQKeyboardTool ()

@property (nonatomic, weak) id owner;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureR;

@end


@implementation SQKeyboardTool

- (void)addKeyHandleWithOwner:(id)owner {
    self.owner = owner;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    //
    self.tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardWithRapGestureR)];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    
    [self.owner addGestureRecognizer:self.tapGestureR];
    
//    if([self.owner isKindOfClass:[UITableView class]])
//    {
//        UITableView * tabV = self.owner;
//        CGRect frame = tabV.frame;
//        frame.size.height -= 200;
//        tabV.frame = frame;
//        [(UITableView*)tabV scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
}

- (void)hideKeyboardWithRapGestureR
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.owner removeGestureRecognizer:self.tapGestureR];
}

- (void)hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end

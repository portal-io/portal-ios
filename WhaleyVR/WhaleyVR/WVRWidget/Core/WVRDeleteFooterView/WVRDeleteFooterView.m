//
//  WVRDeleteFooterView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRDeleteFooterView.h"

@interface WVRDeleteFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

- (IBAction)deletBtnOnClick:(id)sender;

- (IBAction)selectAllBtnOnClick:(id)sender;

@end
@implementation WVRDeleteFooterView


- (IBAction)deletBtnOnClick:(id)sender {
    
    if (self.delBlock) {
        self.delBlock();
    }
}

- (IBAction)selectAllBtnOnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (self.selectAllBlock) {
        self.selectAllBlock(sender.selected);
    }
}

-(void)resetStatus
{
    self.deleteBtn.selected = NO;
    self.selectAllBtn.selected = NO;
}

-(void)updateDelTitle:(NSString *)title
{
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateSelectStatus:(BOOL)allSelect
{
    self.selectAllBtn.selected = allSelect;
}

@end

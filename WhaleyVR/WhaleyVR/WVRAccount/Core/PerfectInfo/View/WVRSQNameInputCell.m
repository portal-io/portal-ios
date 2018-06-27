//
//  WVRSQNameInputCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQNameInputCell.h"

#define CELL_HEIGHT_NAMETF (44+35)

@interface WVRSQNameInputCell ()

@property WVRSQNameInputCellInfo * cellInfo;

@end
@implementation WVRSQNameInputCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.nameTF.delegate = self;
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRSQNameInputCellInfo*)info;
    self.nameTF.placeholder = self.cellInfo.placeHolder;
    self.nameTF.text = self.cellInfo.content;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.cellInfo.endInputBlock) {
        self.cellInfo.endInputBlock(text);
    }
    return YES;
}


@end
@implementation WVRSQNameInputCellInfo
-(CGFloat)cellHeight
{
    return CELL_HEIGHT_NAMETF;
}
@end

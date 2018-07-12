//
//  WVRSQNameInputCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQPWInputCell.h"
#import "SQTextField.h"

#define CELL_HEIGHT_NAMETF (44+35)

@interface WVRSQPWInputCell ()

@property WVRSQPWInputCellInfo * cellInfo;
@property (weak, nonatomic) IBOutlet SQTextField *pwTF;

@end
@implementation WVRSQPWInputCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.pwTF.delegate = self;
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRSQPWInputCellInfo*)info;
    self.pwTF.placeholder = self.cellInfo.placeHolder;
    self.pwTF.text = self.cellInfo.content;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.cellInfo.endInputBlock) {
        self.cellInfo.endInputBlock(text);
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.cellInfo.endInputBlock) {
        self.cellInfo.endInputBlock(textField.text);
    }
}
@end
@implementation WVRSQPWInputCellInfo
-(CGFloat)cellHeight
{
    return CELL_HEIGHT_NAMETF;
}
@end

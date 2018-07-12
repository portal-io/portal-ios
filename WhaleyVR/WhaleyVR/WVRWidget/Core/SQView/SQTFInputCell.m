//
//  SQTFInputCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTFInputCell.h"



@interface SQTFInputCell ()

@property (nonatomic) SQTFInputCellInfo * cellInfo;
@end
@implementation SQTFInputCell

-(void)awakeFromNib
{
    [super awakeFromNib];

}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (SQTFInputCellInfo*)info;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.cellInfo.content = text;
    return YES;
}


@end
@implementation SQTFInputCellInfo
@synthesize cellHeight = _cellHeight;
-(CGFloat)cellHeight
{
    if (_cellHeight ==CELL_HIEGHT_ZERO) {
        _cellHeight = CELL_HIEGHT_DEFAULT;
    }
    return _cellHeight;
}
@end

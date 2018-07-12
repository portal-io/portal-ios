//
//  WVRAddressInputCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAddressInputCell.h"

@interface WVRAddressInputCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *flagL;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic) WVRAddressInputCellInfo* cellInfo;
@end


@implementation WVRAddressInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTF.delegate = self;
}

- (void)fillData:(SQBaseTableViewInfo *)info{
    self.cellInfo= (WVRAddressInputCellInfo*) info;
    self.titleL.text= self.cellInfo.title;
    self.contentTF.placeholder = self.cellInfo.placeHolder;
    self.contentTF.text = self.cellInfo.content;
    self.contentTF.userInteractionEnabled = !self.cellInfo.tfNotEnable;
    self.flagL.hidden = self.cellInfo.isNotMust;
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
    if (self.cellInfo.changeContentBlock) {
        self.cellInfo.changeContentBlock(text);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.cellInfo.content = textField.text;
    if (self.cellInfo.changeContentBlock) {
        self.cellInfo.changeContentBlock(textField.text);
    }
}

@end


@implementation WVRAddressInputCellInfo

@end

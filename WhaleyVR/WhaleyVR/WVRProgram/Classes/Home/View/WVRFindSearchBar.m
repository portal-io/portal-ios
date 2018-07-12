//
//  WVRFindSearchBar.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFindSearchBar.h"

@interface WVRFindSearchBar ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
- (IBAction)clearBtnOnClick:(id)sender;


@end
@implementation WVRFindSearchBar

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textF.delegate = self;
    self.clearBtn.hidden = YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        self.clearBtn.hidden = YES;
    }else{
        self.clearBtn.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && (1 == range.length) && (0 == range.location)) {
        self.clearBtn.hidden = YES;
        
    }else{
        self.clearBtn.hidden = NO;
    }
    
    return YES;
}


- (IBAction)clearBtnOnClick:(id)sender {
    self.textF.text = @"";
    self.clearBtn.hidden = YES;
}
@end

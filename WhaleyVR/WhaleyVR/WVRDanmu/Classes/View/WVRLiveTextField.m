//
//  WVRLiveTextField.m
//  WVRDanmu
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRLiveTextField.h"
#import "WVRPlayerUIFrameMacro.h"

#define HEIGHT_VR_MODEBTN (MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED - MARGIN_TOP_TEXTFILED)
#define WIDTH_VR_MODEBTN (HEIGHT_VR_MODEBTN)

#define CENTERY_SUBVIEWS ((MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED)/2)

@interface WVRLiveTextField ()<UITextFieldDelegate>

@end


@implementation WVRLiveTextField

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelf];
    }
    return self;
}

- (void)configSelf {
    
    self.returnKeyType = UIReturnKeySend;
    self.enablesReturnKeyAutomatically = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.delegate = self;
    self.placeholder = @"你也来说两句吧~";//@"快来发送弹幕吧~";
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.alpha = 0;
    self.hidden = YES;
}

- (void)changeDanmuSwitchStatus:(BOOL)isOn {
    
//    _danmuSwitch = isOn;
    
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}


#pragma mark - Event

- (void)textFieldDidChange:(UITextField *)sender
{
    if (self.text.length > MAX_LENGTH_SEND_TEXT)  // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        NSLog(@"textFieldTextLength:%ld", (long)self.text.length);
        SQToastInKeyWindow(@"字数已经达到上限！");
        self.text = [self.text substringToIndex: MAX_LENGTH_SEND_TEXT]; // MAXLENGTH为最大字数
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        SQToastInKeyWindow(@"输入内容不能为空");
        return NO;
    }
    
    NSString *content = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"tFcontent: %@, length: %d", content, (int)content.length);
    
    self.text = @"";
    
    if ([self.realDelegate respondsToSelector:@selector(textFieldWillReturn:)]) {
        [self.realDelegate textFieldWillReturn:content];
    }
    
    return NO;
}

@end

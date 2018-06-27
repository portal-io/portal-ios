//
//  WVRPhoneNumInputView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/24/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRPhoneNumInputView.h"

@interface WVRPhoneNumInputView()<UITextFieldDelegate>

@property (nonatomic, assign) BOOL isIconExists;
@property (nonatomic, strong) UILabel *phoneAreaCode;
@property (nonatomic, strong) UIView *seperateLine;
@property (nonatomic) UIButton * clearBtn;
@end

@implementation WVRPhoneNumInputView

- (id)init {
    self = [super init];
    
    if (self) {
        self.lineHeight = 1.0f;
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubvies];
    }
    
    return self;
}

- (void)configSelf {
//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [[UIColor colorWithHex:0xe3e3e3] CGColor];
//    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor colorWithHex:0xfdfdfd];
}

- (void)allocSubviews {
    
    _phoneAreaCode = [[UILabel alloc] init];
    _seperateLine = [[UIView alloc] init];
    _textField = [[UITextField alloc] init];
    self.clearBtn = [[UIButton alloc] init];
}

- (void)configSubviews {
    _phoneAreaCode.text = @"+86";
    [_phoneAreaCode setTextColor:[UIColor colorWithHex:0xc9c9c9]];
    [_phoneAreaCode setFont:kFontFitForSize(15)];
    [_phoneAreaCode setTextAlignment:NSTextAlignmentCenter];
    
    _seperateLine.backgroundColor = [UIColor colorWithHex:0xcccccc];
    
    [_textField setPlaceholder:@"请输入手机号码"];
    [_textField setTextColor:[UIColor blackColor]];
    [_textField setFont:kFontFitForSize(15)];
    [_textField setTextAlignment:NSTextAlignmentLeft];
    _textField.delegate = self;
    [self.clearBtn addTarget:self action:@selector(clearTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.clearBtn setImage:[UIImage imageNamed:@"icon_input_clear"] forState:UIControlStateNormal];
    
//    [self addSubview:_phoneAreaCode];
    [self addSubview:_seperateLine];
    [self addSubview:_textField];
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.textField setRightView:self.clearBtn];
}

- (void)positionSubvies {
    CGRect tmpRect = CGRectZero;
    
//    tmpRect = [self centerRectInSubviewWithWidth:56 height:self.height toRight:self.width-56];
//    _phoneAreaCode.frame = tmpRect;
//    
    
//    if (YES == _isIconExists) {
//        tmpRect = [self centerRectInSubviewWithWidth:self.width-_seperateLine.right - 30 height:self.height toLeft:_seperateLine.right + 15];
//        _textField.frame = tmpRect;
//    } else {
        tmpRect = [self centerRectInSubviewWithWidth:self.width height:self.height toLeft:0];
        _textField.frame = tmpRect;
//    }
    tmpRect = [self centerRectInSubviewWithWidth:_textField.width height:self.lineHeight toBottom:0];
    _seperateLine.frame = tmpRect;
    self.clearBtn.frame = CGRectMake(0, 0, fitToWidth(27), fitToWidth(27));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self positionSubvies];
}

- (void)updateViewStyleWithIcon:(BOOL) isIconExists andPlacehoderText:(NSString *)text {
    _phoneAreaCode.hidden = !isIconExists;
    
    _textField.placeholder = [NSString stringWithFormat:@"%@", text];
    _isIconExists = isIconExists;
    
    [self positionSubvies];
}

-(void)clearTextFiled {
    self.textField.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldChangedText:)]) {
        [self.delegate textFieldChangedText:@""];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputFinishedWithView:)]) {
        [self.delegate inputFinishedWithView:self];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (_isIconExists)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];

        if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldChangedText:)]) {
            [self.delegate textFieldChangedText:text];
        }
    }
//    return ![self stringContainsEmoji:string];
//    [textField.textInputMode primaryLanguage];
    NSString * mPri = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([mPri isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([string isEqualToString:@""] && (1 == range.length) && (0 == range.location)) {
//        _clearBtn.hidden = YES;
//        
//    } else {
//        _clearBtn.hidden = NO;
//    }
//    //不支持系统表情的输入
//    return ![self isContainsEmoji:string];
//    //    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
//    //        return NO;
//    //    }
//    //    return YES;
//}

//是否含有表情
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.eventId.length>0 && self.burialPoint.length > 0) {
        [WVRTrackEventMapping curEvent:self.eventId flag:self.burialPoint];
    }
    _seperateLine.backgroundColor = [UIColor colorWithHex:0x2a2a2a];
    self.lineHeight = 2;
    [self positionSubvies];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _seperateLine.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.lineHeight = 1;
    [self positionSubvies];
    return YES;
}

@end

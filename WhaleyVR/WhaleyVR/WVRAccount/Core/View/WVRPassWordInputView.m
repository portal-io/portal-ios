//
//  WVRPassWordInputView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRPassWordInputView.h"


@interface WVRPassWordInputView()<UITextFieldDelegate>

@property (nonatomic, assign) BOOL isIconExists;
@property (nonatomic) UIButton * clearBtn;

@end

@implementation WVRPassWordInputView

- (id)init
{
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

- (void)dealloc
{
}

- (void)configSelf
{
//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [[UIColor colorWithHex:0xe3e3e3] CGColor];
//    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor colorWithHex:0xfdfdfd];
}

- (void)allocSubviews
{
    _phoneAreaCode = [[UIView alloc] init];
    _passwordIcon = [[UIImageView alloc] init];
    _seperateLine = [[UIView alloc] init];
    _textField = [[UITextField alloc] init];
    self.clearBtn = [[UIButton alloc] init];
}

- (void)configSubviews
{
//    _passwordIcon.image = [UIImage imageNamed:@"password _icon"];
    _seperateLine.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [_textField setPlaceholder:@"请输入手机号码"];
    [_textField setTextColor:[UIColor blackColor]];
    [_textField setFont:kFontFitForSize(15)];
    [_textField setTextAlignment:NSTextAlignmentLeft];
    _textField.delegate = self;
    _textField.secureTextEntry = YES;
    
    [_phoneAreaCode addSubview:_passwordIcon];
    
    [self.clearBtn addTarget:self action:@selector(clearTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.clearBtn setImage:[UIImage imageNamed:@"icon_input_clear"] forState:UIControlStateNormal];
    
//    [self addSubview:_phoneAreaCode];
    [self addSubview:_seperateLine];
    [self addSubview:_textField];
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.textField setRightView:self.clearBtn];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
//    tmpRect = [self centerRectInSubviewWithWidth:56 height:self.height toRight:self.width-56];
//    _phoneAreaCode.frame = tmpRect;
    
//    _passwordIcon.size = CGSizeMake(14, 17);
//    tmpRect = [_phoneAreaCode centerRectInSubviewWithView:_passwordIcon];
//    _passwordIcon.frame = tmpRect;
    
//    tmpRect = [self centerRectInSubviewWithWidth:0.5 height:self.height toLeft:_phoneAreaCode.right];
//    _seperateLine.frame = tmpRect;
    
//    if (YES == _isIconExists) {
//        tmpRect = [self centerRectInSubviewWithWidth:self.width-_seperateLine.right-30 height:self.height toLeft:_seperateLine.right + 15];
//        
//        _textField.frame = tmpRect;
//    } else
    {
        tmpRect = [self centerRectInSubviewWithWidth:self.width height:self.height toLeft:0];
        _textField.frame = tmpRect;
    }
    
    tmpRect = [self centerRectInSubviewWithWidth:_textField.width height:self.lineHeight toBottom:0];
    _seperateLine.frame = tmpRect;
    self.clearBtn.frame = CGRectMake(0, 0, fitToWidth(27), fitToWidth(27));
}

- (void)layoutSubviews
{
    [self positionSubvies];
}

- (void)updateViewStyleWithIcon:(BOOL) isIconExists andPlacehoderText:(NSString*) text
{
    _phoneAreaCode.hidden = !isIconExists;
//    _seperateLine.hidden = !isIconExists;
    _textField.placeholder = text;
    _isIconExists = isIconExists;
    
    [self positionSubvies];
}

-(void)clearTextFiled
{
    self.textField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputFinishedWithView:)]) {
        [self.delegate inputFinishedWithView:self];
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.eventId.length>0&&self.burialPoint.length>0) {
        [WVRTrackEventMapping curEvent:self.eventId flag:self.burialPoint];
    }
    _seperateLine.backgroundColor = [UIColor colorWithHex:0x2a2a2a];
    self.lineHeight = 2.0f;
    [self positionSubvies];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _seperateLine.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.lineHeight = 1.0f;
    [self positionSubvies];
    return YES;
}
@end

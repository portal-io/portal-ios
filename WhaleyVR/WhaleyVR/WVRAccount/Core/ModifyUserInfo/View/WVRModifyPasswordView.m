//
//  WVRModifyPasswordView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRModifyPasswordView.h"
#import "WVRPassWordInputView.h"
#import "WVRLoginStyleHeader.h"

@interface WVRModifyPasswordView()<UITextFieldDelegate>

@end

@implementation WVRModifyPasswordView

- (id)init
{
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)configSelf
{
    [self addObservers];
    self.backgroundColor = [UIColor clearColor];
    
    _style = WVRModifyPasswordViewStyleModifyPW;
}

- (void)allocSubviews
{
    _scrollView = [[UIScrollView alloc] init];
    
    _oldPassword = [[WVRPassWordInputView alloc] init];
    _password = [[WVRPassWordInputView alloc] init];
    _confirmPassword = [[WVRPassWordInputView alloc] init];
    
    _forgetPasswordLabel = [[UILabel alloc] init];
    _tintLabel = [[UILabel alloc] init];
}

- (void)configSubviews
{
    /* Scroll View */
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.scrollEnabled = YES;
    [_scrollView addGestureRecognizer:[self tapGesture]];
    
    [_oldPassword updateViewStyleWithIcon:NO andPlacehoderText:@"请输入原密码"];
    
    [_password updateViewStyleWithIcon:NO andPlacehoderText:@"请输入新密码"];
    [_confirmPassword updateViewStyleWithIcon:NO andPlacehoderText:@"请再次输入新密码"];
    
    _forgetPasswordLabel.text = @"忘记密码";
    _forgetPasswordLabel.textColor = [UIColor colorWithHex:0x2a2a2a];
    _forgetPasswordLabel.font = kFontFitForSize(12);
    _forgetPasswordLabel.userInteractionEnabled = YES;
    [_forgetPasswordLabel addGestureRecognizer:[self tapGesture]];
    
    _tintLabel.text = @"密码长度6-20个位，数字、字母、下划线至少包含两种";
    _tintLabel.textColor = [UIColor colorWithHex:0xc8c8c8];
    _tintLabel.textAlignment = NSTextAlignmentCenter;
    _tintLabel.font = kFontFitForSize(10);
    
    [_scrollView addSubview:_oldPassword];
    [_scrollView addSubview:_password];
    [_scrollView addSubview:_confirmPassword];

    [_scrollView addSubview:_forgetPasswordLabel];
    [_scrollView addSubview:_tintLabel];
    
    [self addSubview:_scrollView];
}

- (void)positionSubviews
{
    CGRect tmpRect = CGRectZero;
    /* Scroll View */
    /* 这边的逻辑为保证与键盘出现逻辑的兼容 */
    if (0 == _scrollView.bounds.size.height) {
        tmpRect = self.bounds;
        [_scrollView setFrame:tmpRect];
    }
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:fitToWidth(TOP_TO_VIEW)];
    _oldPassword.frame = tmpRect;
    
    CGSize labelSize = [self labelTextSize:_forgetPasswordLabel];
    tmpRect = [self rectInSubviewWithWidth:labelSize.width height:labelSize.height toRight:SCREEN_WIDTH - _oldPassword.right toTop:_oldPassword.bottom + fitToWidth(MARGIN_ITEM)];
    _forgetPasswordLabel.frame = tmpRect;
    
    if (WVRModifyPasswordViewStyleModifyPW == _style) {
        tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_oldPassword.bottom + fitToWidth(83.0/2.f)];
    }else if(WVRModifyPasswordViewStyleFindOldPW == _style){
        tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:fitToWidth(50.f)];
    }
    _password.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_password.bottom + fitToWidth(MARGIN_ITEM)];
    _confirmPassword.frame = tmpRect;
    
    CGSize tintlabelSize = [self labelTextSize:_tintLabel];
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:tintlabelSize.height toLeft:_confirmPassword.left toTop:_confirmPassword.bottom + fitToWidth(15.f/2.0)];
    _tintLabel.frame = tmpRect;
}

-(void)showInputBoard
{
    [_oldPassword.textField becomeFirstResponder];
}

- (void)layoutSubviews
{
    [self positionSubviews];
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake(fitToWidth(WIDTH_INPUT_TF), 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (BOOL)isPasswordSame
{
    return [_password.textField.text isEqualToString:_confirmPassword.textField.text];
}

- (NSString*)getNewPassword
{
    return _password.textField.text;
}

-(NSString*)getOldPassword
{
    return _oldPassword.textField.text;
}

- (NSString*)getConfirmNewPassword
{
    return _confirmPassword.textField.text;
}

- (void)updateTextFieldBgSelected:(BOOL) selected
{
    if (selected) {
        [[_confirmPassword layer] setBorderColor:[UIColor colorWithHex:0xff9393].CGColor];
        _confirmPassword.backgroundColor = [UIColor colorWithHex:0xfff5f5];
    }else{
        _confirmPassword.layer.borderColor = [[UIColor colorWithHex:0xe3e3e3] CGColor];
        _confirmPassword.backgroundColor = [UIColor whiteColor];
    }
}

- (void)changeToFindOldPWMode
{
    _style = WVRModifyPasswordViewStyleFindOldPW;
    
    _oldPassword.hidden = YES;
    _forgetPasswordLabel.hidden = YES;
}

#pragma mark - Observer
- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    CGRect tmpRect = self.bounds;
    tmpRect.size.height = self.bounds.size.height - keyboardHeight;
    [_scrollView setFrame:tmpRect];
    _scrollView.contentSize = CGSizeMake(_scrollView.width, self.bounds.size.height);
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    CGRect tmpRect = self.bounds;
    [_scrollView setFrame:tmpRect];
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height);
}

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture
{
    UIView *tmpView = gesture.view;
    
    if(tmpView == _scrollView)
    {
        [self endEditing:YES];
    }else if (tmpView == _forgetPasswordLabel) {
        if (self.forgotLabelOnClickBlock) {
            self.forgotLabelOnClickBlock();
        }
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

@end

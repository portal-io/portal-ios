 //
//  WVRRegisterView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/25/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRRegisterView.h"
#import "WVRPhoneNumInputView.h"
#import "WVRPassWordInputView.h"
#import "WVRSecurityOrVerifyCodeInputView.h"
#import "WVRRegisterViewController.h"
#import "WVRThirdPartyLoginView.h"
#import "WVRLoginStyleHeader.h"

@interface WVRRegisterView()<WVRSecurityOrVerifyCodeInputViewDelegate, WVRPhoneNumInputViewDelegate, WVRPassWordInputViewDelegate, WVRSecurityOrVerifyCodeInputViewDelegate, WVRThirdPartyLoginViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) WVRRegisterViewStyle style;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) WVRPhoneNumInputView *inputPhoneNumView;
@property (nonatomic, strong) WVRSecurityOrVerifyCodeInputView *securityInputView;
@property (nonatomic, strong) WVRSecurityOrVerifyCodeInputView *verifyCodeInputView;

@property (nonatomic, strong) WVRPhoneNumInputView *nicknameInputView;
@property (nonatomic, strong) WVRPassWordInputView *passWDInputView;

@property (nonatomic, strong) UILabel *nickNameTintLabel;
@property (nonatomic, strong) UILabel *passWDTintLabel;

@property (nonatomic, strong) UILabel *forgetPassWDLabel;

@property (nonatomic, strong) WVRThirdPartyLoginView *thirdPartyLoginView;

@end


@implementation WVRRegisterView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

- (void)dealloc {
//    [self removeObservers];
}

- (void)configSelf {
//    [self addObservers];
    _verifyCodeViewIsHidden = YES;
}

- (void)allocSubviews {
    _scrollView = [[UIScrollView alloc] init];
    
    _avatarImageView = [[UIImageView alloc] init];
    
    _inputPhoneNumView = [[WVRPhoneNumInputView alloc] init];
    
    _securityInputView = [[WVRSecurityOrVerifyCodeInputView alloc] init];
    [_securityInputView updateWithViewStyle:WVRSecurityCodeViewStyle];
    _securityInputView.delegate = self;
    
    _verifyCodeInputView = [[WVRSecurityOrVerifyCodeInputView alloc] init];
    [_verifyCodeInputView updateWithViewStyle:WVRVerifyCodeViewStyle];
    _verifyCodeInputView.delegate = self;
    _verifyCodeInputView.hidden = YES;
    
    _nicknameInputView = [[WVRPhoneNumInputView alloc] init];
    _nickNameTintLabel = [[UILabel alloc] init];
    
    _passWDInputView = [[WVRPassWordInputView alloc] init];
    _passWDTintLabel = [[UILabel alloc] init];
    
    _forgetPassWDLabel = [[UILabel alloc] init];
    
    _loginBtn = [[UIButton alloc] init];
    
    _thirdPartyLoginView = [[WVRThirdPartyLoginView alloc] init];
}

- (void)configSubviews {
    /* Scroll View */
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView addGestureRecognizer:[self tapGesture]];
    
    [self.loginBtn setBackgroundImageWithColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImageWithColor:UIColorFromRGB(0xcccccc) forState:UIControlStateDisabled];
    [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.tag = login_btn_tag;
    _loginBtn.enabled = NO;
    
    _inputPhoneNumView.delegate = self;
    _inputPhoneNumView.textField.returnKeyType = UIReturnKeyNext;
    _inputPhoneNumView.textField.keyboardType = UIKeyboardTypePhonePad;
    
    _nicknameInputView = [[WVRPhoneNumInputView alloc] init];
    [_nicknameInputView updateViewStyleWithIcon:NO andPlacehoderText:@"请输入昵称"];
    _nicknameInputView.delegate = self;
    _nicknameInputView.textField.returnKeyType = UIReturnKeyNext;
    
    _passWDInputView = [[WVRPassWordInputView alloc] init];
    [_passWDInputView updateViewStyleWithIcon:NO andPlacehoderText:@"请输入密码"];
    _passWDInputView.textField.returnKeyType = UIReturnKeyDone;
    
    [_securityInputView updateWithViewStyle:WVRSecurityCodeViewStyle];
    _securityInputView.delegate = self;
    _securityInputView.textField.returnKeyType = UIReturnKeyDone;
    _securityInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_verifyCodeInputView updateWithViewStyle:WVRVerifyCodeViewStyle];
    _verifyCodeInputView.delegate = self;
    _verifyCodeInputView.textField.returnKeyType = UIReturnKeyNext;
    _verifyCodeInputView.hidden = YES;
    
    _nickNameTintLabel.text = @"昵称长度3-30个字符，1个中文占3个字符";
    _nickNameTintLabel.textColor = [UIColor colorWithHex:0xc8c8c8];
    _nickNameTintLabel.font = kFontFitForSize(21/2);
    
    _passWDTintLabel.text = @"密码长度6-20个字符，数字，字母，下划线至少包含两种";
    _passWDTintLabel.textColor = [UIColor colorWithHex:0xc8c8c8];
    _passWDTintLabel.font = kFontFitForSize(21/2);
    
    _forgetPassWDLabel.text = @"忘记密码";
    _forgetPassWDLabel.textColor = UIColorFromRGB(0x2a2a2a);
    _forgetPassWDLabel.font = kFontFitForSize(10);
    _forgetPassWDLabel.userInteractionEnabled = YES;
    [_forgetPassWDLabel addGestureRecognizer:[self tapGesture]];
    _forgetPassWDLabel.tag = 3;
    
    _thirdPartyLoginView.delegate = self;
    
    [self addSubview:_scrollView];
    
//    [_scrollView addSubview:_avatarImageView];
    
    [_scrollView addSubview:_inputPhoneNumView];
    [_scrollView addSubview:_securityInputView];
    [_scrollView addSubview:_verifyCodeInputView];
    
    [_scrollView addSubview:_nicknameInputView];
    [_scrollView addSubview:_passWDInputView];
    
    [_scrollView addSubview:_nickNameTintLabel];
    [_scrollView addSubview:_passWDTintLabel];
    [_scrollView addSubview:_forgetPassWDLabel];
    
    [_scrollView addSubview:_loginBtn];
    
    [_scrollView addSubview:_thirdPartyLoginView];
}

- (void)positionSubviews {
    
    CGRect tmpRect = CGRectZero;
    /* Scroll View */
    /* 这边的逻辑为保证与键盘出现逻辑的兼容 */
    if (0 == _scrollView.bounds.size.height) {
        tmpRect = self.bounds;
        [_scrollView setFrame:tmpRect];
    }
    
//    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(80) height:fitToWidth(80) toTop:fitToWidth(47)];
//    _avatarImageView.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:fitToWidth(TOP_TO_VIEW)];
    _inputPhoneNumView.frame = tmpRect;
    _nicknameInputView.frame = tmpRect;
    
    CGSize labelSize = [self labelTextSize:_nickNameTintLabel];
    tmpRect = [self rectInSubviewWithWidth:labelSize.width height:labelSize.height toLeft:_inputPhoneNumView.x toTop:_inputPhoneNumView.bottom+fitToWidth(15/2)];
    _nickNameTintLabel.frame = tmpRect;
    
    if (WVRRegisterViewStyleInputPhoneNum == _style || WVRRegisterViewStyleInputPhoneNumForSecurityLogin == _style || WVRRegisterViewStyleFindOldPassword == _style || WVRRegisterViewStyleInputPhoneNumAndPDForThirdPartyBind == _style) {
        tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_inputPhoneNumView.bottom + fitToWidth(15)];
    }else if(_style == WVRRegisterViewStyleInputNameAndPD){
        tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_nickNameTintLabel.bottom + fitToWidth(35/2)];
    }
    _securityInputView.frame = tmpRect;
    _verifyCodeInputView.frame = tmpRect;
    _passWDInputView.frame = tmpRect;
    
    labelSize = [self labelTextSize:_passWDTintLabel];
    tmpRect = [self rectInSubviewWithWidth:labelSize.width height:labelSize.height toLeft:_securityInputView.x toTop:_securityInputView.bottom+fitToWidth(15/2)];
    _passWDTintLabel.frame = tmpRect;
    
    labelSize = [self labelTextSize:_forgetPassWDLabel];
    tmpRect = [self rectInSubviewWithWidth:labelSize.width height:labelSize.height toLeft:_passWDInputView.right-labelSize.width toTop:_passWDInputView.bottom+fitToWidth(2)];
    _forgetPassWDLabel.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_LOGIN_BTN) toTop:_forgetPassWDLabel.bottom+fitToWidth(MARGIN_LOGIN_FORGOT)];
    _loginBtn.frame = tmpRect;

    tmpRect = [self centerRectInSubviewWithView:_thirdPartyLoginView toTop:SCREEN_HEIGHT-kNavBarHeight-_thirdPartyLoginView.height];
    _thirdPartyLoginView.frame = tmpRect;
    
    [self fitFrameForScrollView];
}

- (void)fitFrameForScrollView {
    
//    CGFloat scHeight = 667;
    [_scrollView setContentSize:CGSizeMake(self.width, _thirdPartyLoginView.bottom)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self positionSubviews];
}

- (NSString *)getPhoneNum {
    
    return _inputPhoneNumView.textField.text;
}

- (NSString *)getCaptcha {
    
    return _verifyCodeInputView.textField.text;
}

- (NSString *)getSecurityCode {
    
    return _securityInputView.textField.text;
}

- (NSString *)getNickname {
    
    return _nicknameInputView.textField.text;
}

- (NSString *)getPassword {
    
    return _passWDInputView.textField.text;
}

- (void)setCaptcha:(NSString *)captcha {
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithUTF8String:captcha]];
    [_verifyCodeInputView.verifyCodeBtn setImage:[UIImage imageWithData:data]];
}

- (void)setAvatar:(NSString *)avatar {
    
    if (avatar.length < 1) { return; }
    
    [_avatarImageView wvr_setImageWithURL:[NSURL URLWithUTF8String:avatar] placeholderImage:[UIImage imageNamed:@"avatar_login"] options:SDWebImageRetryFailed];
}

- (void)setPhoneNum:(NSString *)phoneNum {
    
    if (phoneNum.length < 1) { return; }
    if (phoneNum.length > 11) { phoneNum = [phoneNum substringToIndex:11]; }
    
    _inputPhoneNumView.textField.text = phoneNum;
    
    if (phoneNum.length == 11) {
        _securityInputView.securityCodeBtn.enabled = YES;
        _loginBtn.enabled = YES;
    }
}

- (void)displayVeryfyCodeInputView {
    _verifyCodeViewIsHidden = NO;
    _verifyCodeInputView.hidden = NO;
    
    CGRect tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_verifyCodeInputView.bottom + fitToWidth(MARGIN_ITEM)];
    _securityInputView.frame = tmpRect;
}

- (CGSize)labelTextSize:(UILabel*) label {
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (void)buttonClicked:(UIButton *)button {
    [self endEditing:YES];
    
    if ([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
        [_delegate bindView:self buttonClickedAtIndex:button.tag];
    }
}

- (void)updateWithViewStyle:(WVRRegisterViewStyle)style {
    _style = style;
    
    switch (style) {
        case WVRRegisterViewStyleInputPhoneNum:
        case WVRRegisterViewStyleInputPhoneNumForSecurityLogin:
        {
            _inputPhoneNumView.hidden = NO;
            [_inputPhoneNumView updateViewStyleWithIcon:YES andPlacehoderText:@"请输入手机号码"];
            [_inputPhoneNumView.textField becomeFirstResponder];
            
            _securityInputView.hidden = NO;
            
            _nicknameInputView.hidden = YES;
            _passWDInputView.hidden = YES;
            _nickNameTintLabel.hidden = YES;
            _passWDTintLabel.hidden = YES;
            _forgetPassWDLabel.hidden = YES;
        }
         break;
        case WVRRegisterViewStyleFindOldPassword:
        {
            _inputPhoneNumView.hidden = NO;
            [_inputPhoneNumView updateViewStyleWithIcon:YES andPlacehoderText:@"请输入手机号码"];
            [_inputPhoneNumView.textField becomeFirstResponder];
            
            _securityInputView.hidden = NO;
            
            _nicknameInputView.hidden = YES;
            _passWDInputView.hidden = YES;
            _nickNameTintLabel.hidden = YES;
            _passWDTintLabel.hidden = YES;
            _forgetPassWDLabel.hidden = YES;
            _thirdPartyLoginView.hidden = YES;
        }
            break;
        case WVRRegisterViewStyleInputNameAndPD:
        {
            _nicknameInputView.hidden = NO;
            _nicknameInputView.textField.placeholder = @"填写昵称";
            [_nicknameInputView.textField becomeFirstResponder];
            _passWDInputView.hidden = NO;
            _passWDInputView.textField.placeholder = @"设置密码";
            _nickNameTintLabel.hidden = NO;
            _passWDTintLabel.hidden = NO;
            
            _inputPhoneNumView.hidden = YES;
            _securityInputView.hidden = YES;
            _forgetPassWDLabel.hidden = YES;
        }
            break;
        case WVRRegisterViewStyleInputPhoneNumAndPDForThirdPartyBind:
        {
            _inputPhoneNumView.hidden = NO;
            [_inputPhoneNumView updateViewStyleWithIcon:YES andPlacehoderText:@"请输入手机号码"];
            [_inputPhoneNumView.textField becomeFirstResponder];
            
            _securityInputView.hidden = NO;
            
            _nicknameInputView.hidden = YES;
            _passWDInputView.hidden = YES;
            _nickNameTintLabel.hidden = YES;
            _passWDTintLabel.hidden = YES;
            _forgetPassWDLabel.hidden = YES;
            _thirdPartyLoginView.hidden = YES;
            
            [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)startTimer {
    [_securityInputView startTimer];
}

- (void)stopTimer {
    [_securityInputView stopTimer];
}

#pragma mark - inputViewDelegate
- (void)inputFinishedWithView:(UIView*) view {
    if (view == _inputPhoneNumView) {
        if (!_verifyCodeInputView.hidden) {
            [_verifyCodeInputView.textField becomeFirstResponder];
        } else if (!_securityInputView.hidden) {
            [_securityInputView.textField becomeFirstResponder];
        }
    } else if(view == _nicknameInputView) {
        if (!_passWDInputView.hidden) {
            [_passWDInputView.textField becomeFirstResponder];
        }
    } else if(view == _verifyCodeInputView) {
        if (!_securityInputView.hidden) {
            [_securityInputView.textField becomeFirstResponder];
        }
    }
}

- (void)textFieldChangedText:(NSString *)text {
    if (text.length < 1) {
        _loginBtn.enabled = NO;
        [_securityInputView setBtnEnable:NO];
    } else {
        if (_style == WVRRegisterViewStyleInputNameAndPD) {
            
            _loginBtn.enabled = YES;
            
        } else if ([WVRGlobalUtil validateMobileNumber:text]) {
            
            _loginBtn.enabled = YES;
            [_securityInputView setBtnEnable:_securityInputView.timerStoped];
        } else {
            _loginBtn.enabled = NO;
            [_securityInputView setBtnEnable:NO];
        }
    }
}

- (BOOL)phoneNumIsValid {
    [self endEditing:YES];
    
    if (![WVRGlobalUtil validateMobileNumber:_inputPhoneNumView.textField.text]){
        SQToastIn(@"请输入正确手机号", self);
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Observer
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    CGRect tmpRect = self.bounds;
    tmpRect.size.height = self.bounds.size.height - keyboardHeight;
    [_scrollView setFrame:tmpRect];
    
//    _scrollView.centerY =- keyboardHeight;
    
}

- (void)keyboardWillHide:(NSNotification *)noti {
    CGRect tmpRect = self.bounds;
    [_scrollView setFrame:tmpRect];
}

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture {
    UIView *tmpView = gesture.view;
    
    if(tmpView == _scrollView)
    {
        [self endEditing:YES];
    }
}

#pragma mark - WVRSecurityOrVerifyCodeInputViewDelegate

- (void)buttonClickedWithIndex:(NSInteger) index {
    [self endEditing:YES];
    
    if([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
        [_delegate bindView:self buttonClickedAtIndex:index];
    }
}

#pragma mark - WVRThirdPartyLoginViewDelegate

- (void)bindView:(WVRThirdPartyLoginView *)view buttonClickedAtIndex:(NSInteger)index {
    
    if([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
        [_delegate bindView:self buttonClickedAtIndex:index];
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

-(void)setEventId:(NSString *)eventId {
    self.inputPhoneNumView.eventId = eventId;
    self.inputPhoneNumView.burialPoint = kEvent_burialPoint_mobile;
    self.nicknameInputView.eventId = eventId;
    self.nicknameInputView.burialPoint = kEvent_register_burialPoint_name;
    self.passWDInputView.eventId = eventId;
    self.passWDInputView.burialPoint = kEvent_register_burialPoint_password;
    self.securityInputView.eventId = eventId;
    self.securityInputView.burialPoint = kEvent_register_burialPoint_smsCode;
    self.verifyCodeInputView.eventId = eventId;
    self.verifyCodeInputView.burialPoint = kEvent_register_burialPoint_picCode;
}

@end


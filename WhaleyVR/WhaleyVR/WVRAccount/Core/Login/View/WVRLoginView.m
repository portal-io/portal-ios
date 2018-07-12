//
//  WVRLoginView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 8/24/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRLoginView.h"
#import "WVRPhoneNumInputView.h"
#import "WVRPassWordInputView.h"
#import "WVRSecurityOrVerifyCodeInputView.h"
#import "WVRThirdPartyLoginView.h"
#import "WVRLoginStyleHeader.h"

@interface WVRLoginView()<WVRThirdPartyLoginViewDelegate, WVRPhoneNumInputViewDelegate, WVRPassWordInputViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *forgetPassWDBtn;
@property (nonatomic, strong) UILabel *securityCodeLoginBtn;

@property (nonatomic, strong) WVRSecurityOrVerifyCodeInputView *securityCodeInputView;
@property (nonatomic, strong) WVRThirdPartyLoginView *thirdPartyLoginView;

@end


@implementation WVRLoginView

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
    [self removeObservers];
}

- (void)configSelf {
    [self addObservers];
}

- (void)allocSubviews {
    _scrollView = [[UIScrollView alloc] init];
    
    _avatarImageView = [[UIImageView alloc] init];
    
    _inputPhoneNumView = [[WVRPhoneNumInputView alloc] init];
    _inputPhoneNumView.eventId = kEvent_login;
    _inputPassWDView = [[WVRPassWordInputView alloc] init];
    _securityCodeInputView = [[WVRSecurityOrVerifyCodeInputView alloc] init];
    
    _forgetPassWDBtn = [[UILabel alloc] init];
    _securityCodeLoginBtn = [[UILabel alloc] init];
    _loginBtn = [[UIButton alloc] init];
    
    _thirdPartyLoginView = [[WVRThirdPartyLoginView alloc] init];
}

- (void)configSubviews {
    /* Scroll View */
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView addGestureRecognizer:[self tapGesture]];

    _avatarImageView.image = [UIImage imageNamed:@"avatar_login"];

    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_disable"] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundImageWithColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImageWithColor:UIColorFromRGB(0xcccccc) forState:UIControlStateDisabled];
    [_loginBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.tag = 0;
    _loginBtn.enabled = NO;
    
    [_inputPhoneNumView updateViewStyleWithIcon:YES andPlacehoderText:@"请输入手机号码"];
    _inputPhoneNumView.delegate = self;
    _inputPhoneNumView.textField.returnKeyType = UIReturnKeyNext;
    _inputPhoneNumView.textField.keyboardType = UIKeyboardTypePhonePad;
    
    [_inputPassWDView updateViewStyleWithIcon:YES andPlacehoderText:@"请输入密码"];
    _inputPassWDView.delegate = self;
    _inputPassWDView.textField.returnKeyType = UIReturnKeyDone;
    
    _forgetPassWDBtn.font = kFontFitForSize(25/2);
    _forgetPassWDBtn.textAlignment = NSTextAlignmentLeft;
    _forgetPassWDBtn.tag = 1;
    _forgetPassWDBtn.textColor = [UIColor colorWithHex:0x2a2a2a];
    _forgetPassWDBtn.userInteractionEnabled = YES;
    [_forgetPassWDBtn addGestureRecognizer:[self tapGesture]];
    
    NSMutableAttributedString *content0 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"忘记密码"]];
    NSRange contentRange = {0,[content0 length]};
    [content0 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _forgetPassWDBtn.attributedText = content0;
    
    _securityCodeLoginBtn.font = kFontFitForSize(25/2);
    _securityCodeLoginBtn.textAlignment = NSTextAlignmentRight;
    _securityCodeLoginBtn.tag = 2;
    _securityCodeLoginBtn.textColor = [UIColor colorWithHex:0x2a2a2a];
    _securityCodeLoginBtn.userInteractionEnabled = YES;
    [_securityCodeLoginBtn addGestureRecognizer:[self tapGesture]];
    
    NSMutableAttributedString *content1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短信快捷登录"]];
    NSRange contentRange1 = { 0, [content1 length] };
    [content1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange1];
    _securityCodeLoginBtn.attributedText = content1;
    
    _thirdPartyLoginView.delegate = self;
    [_thirdPartyLoginView setBottomTintLabelHidden];
    
    [self addSubview:_scrollView];
    
//    [_scrollView addSubview:_avatarImageView];
    
    [_scrollView addSubview:_inputPhoneNumView];
    [_scrollView addSubview:_inputPassWDView];
    [_scrollView addSubview:_securityCodeInputView];
    
    [_scrollView addSubview:_forgetPassWDBtn];
    [_scrollView addSubview:_securityCodeLoginBtn];
    
    [_scrollView addSubview:_loginBtn];
    
    [_scrollView addSubview:_thirdPartyLoginView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_inputPhoneNumView.textField becomeFirstResponder];
    });
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
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_inputPhoneNumView.bottom + fitToWidth(MARGIN_ITEM)];
    _inputPassWDView.frame = tmpRect;
    _securityCodeInputView.frame = tmpRect;
    
    CGSize labelTextSize = [self labelTextSize:_securityCodeLoginBtn];
    tmpRect = [self rectInSubviewWithWidth:labelTextSize.width height:labelTextSize.height toLeft:_inputPassWDView.left toTop:_inputPassWDView.bottom + fitToWidth(MARGIN_ITEM)];
    _securityCodeLoginBtn.frame = tmpRect;
    
    labelTextSize = [self labelTextSize:_forgetPassWDBtn];
    tmpRect = [self rectInSubviewWithWidth:labelTextSize.width height:labelTextSize.height toLeft:_inputPassWDView.right- labelTextSize.width toTop:_inputPassWDView.bottom + fitToWidth(MARGIN_ITEM)];
    _forgetPassWDBtn.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(100/2) toTop:_forgetPassWDBtn.bottom+fitToWidth(MARGIN_LOGIN_FORGOT)];
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
    [self positionSubviews];
}

- (void)updateWithViewStyle:(WVRLoginViewViewStyle)style {
    switch (style) {
        case WVRLoginViewViewStyleNormalLogin:
        {
            _inputPassWDView.hidden = NO;
            _forgetPassWDBtn.hidden = NO;
            _securityCodeLoginBtn.hidden = NO;
            
            _securityCodeInputView.hidden = YES;
        }
            break;
//        case WVRLoginViewViewStyleQuickLogin:
//        {
//            _inputPassWDView.hidden = YES;
//            _forgetPassWDBtn.hidden = YES;
//            _securityCodeLoginBtn.hidden = YES;
//            
//            _securityCodeInputView.hidden = NO;
//        }
            break;
        default:
            break;
    }
}

- (void)buttonClicked:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
        [_delegate bindView:self buttonClickedAtIndex:button.tag];
    }
}

- (CGSize)labelTextSize:(UILabel *)label {
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (NSString *)getPhoneNum {
    
    return _inputPhoneNumView.textField.text;
}

- (NSString *)getPassword {
    
    return _inputPassWDView.textField.text;
}

#pragma mark - inputViewDelegate
- (void)inputFinishedWithView:(UIView *)view {
    if (view == _inputPhoneNumView) {
        if (!_inputPassWDView.hidden) {
            [_inputPassWDView.textField becomeFirstResponder];
        }
    } else if (view == _inputPassWDView) {
        if (!_securityCodeInputView.hidden) {
            [_securityCodeInputView.textField becomeFirstResponder];
        }
    }
}

- (void)textFieldChangedText:(NSString *)text {
    if (text.length == 0) {
        _loginBtn.enabled = NO;
    } else {
        if ([WVRGlobalUtil validateMobileNumber:text]) {
            _loginBtn.enabled = YES;
        } else {
            _loginBtn.enabled = NO;
        }
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
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    CGRect tmpRect = self.bounds;
    [_scrollView setFrame:tmpRect];
}

#pragma mark - Target-Action Pair
- (void)cellClicked:(UIGestureRecognizer *)gesture {
    UIView *tmpView = gesture.view;
    
    if (tmpView == _forgetPassWDBtn) {
        if ([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
                [_delegate bindView:self buttonClickedAtIndex:_forgetPassWDBtn.tag];
            }
        } else if (tmpView == _securityCodeLoginBtn)
        {
            if ([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
                [_delegate bindView:self buttonClickedAtIndex:_securityCodeLoginBtn.tag];
            }
        } else if (tmpView == _scrollView)
        {
            [self endEditing:YES];
        }
}

#pragma mark - WVRThirdPartyLoginViewDelegate
- (void)bindView:(WVRThirdPartyLoginView *)view buttonClickedAtIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(bindView:buttonClickedAtIndex:)]) {
        [_delegate bindView:self buttonClickedAtIndex:index];
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    
    return tapGesture;
}


- (void)showKeyboard {
    
    [self.inputPhoneNumView.textField becomeFirstResponder];
}
@end

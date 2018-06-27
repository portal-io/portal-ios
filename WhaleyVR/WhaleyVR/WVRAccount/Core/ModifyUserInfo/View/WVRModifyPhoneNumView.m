//
//  WVRModifyPhoneNumView.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/1/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRModifyPhoneNumView.h"
#import "WVRPhoneNumInputView.h"
#import "WVRSecurityOrVerifyCodeInputView.h"
#import "WVRUserModel.h"
#import "WVRLoginStyleHeader.h"

@interface WVRModifyPhoneNumView ()<WVRSecurityOrVerifyCodeInputViewDelegate,WVRPhoneNumInputViewDelegate>
@property (nonatomic, strong) WVRSecurityOrVerifyCodeInputView *verifyCodeInputView;
@property BOOL showCaptach;
@end
@implementation WVRModifyPhoneNumView

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
}

- (void)allocSubviews
{
    _scrollView = [[UIScrollView alloc] init];
    
    _phoneNumInputView = [[WVRPhoneNumInputView alloc] init];
    _securityCodeInputView = [[WVRSecurityOrVerifyCodeInputView alloc] init];
    _verifyCodeInputView = [[WVRSecurityOrVerifyCodeInputView alloc] init];
    _oldPhoneNumLabel = [[UILabel alloc] init];
    _oldPhoneNum = [[UILabel alloc] init];
}

- (void)configSubviews
{
    /* Scroll View */
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.scrollEnabled = YES;
    [_scrollView addGestureRecognizer:[self tapGesture]];
    
    [_phoneNumInputView updateViewStyleWithIcon:NO andPlacehoderText:@"请输入新手机号码"];
    [_phoneNumInputView.textField becomeFirstResponder];
    _phoneNumInputView.delegate = self;
    _oldPhoneNumLabel.text = @"原号码";
    _oldPhoneNumLabel.textColor = [UIColor blackColor];
    _oldPhoneNumLabel.font = kFontFitForSize(15);
    
    NSString * phoneNum = [WVRUserModel sharedInstance].mobileNumber;
    NSString * preStr = [phoneNum substringWithRange:NSMakeRange(0, 3)];
    NSString * lastStr = [phoneNum substringWithRange:NSMakeRange(phoneNum.length-4, 4)];
    _oldPhoneNum.text = [NSString stringWithFormat:@"%@****%@",preStr.length>0? preStr:@"",lastStr.length>0? lastStr:@""];
    _oldPhoneNum.textColor = [UIColor grayColor];
    _oldPhoneNum.font = kFontFitForSize(15);
    _securityCodeInputView.delegate = self;
    [_securityCodeInputView updateWithViewStyle:WVRSecurityCodeViewStyle];

    [_verifyCodeInputView updateWithViewStyle:WVRVerifyCodeViewStyle];
    _verifyCodeInputView.delegate = self;
    _verifyCodeInputView.textField.returnKeyType = UIReturnKeyNext;
    _verifyCodeInputView.hidden = YES;
    
    [_scrollView addSubview:_verifyCodeInputView];
    
    [_scrollView addSubview:_phoneNumInputView];
    [_scrollView addSubview:_securityCodeInputView];
    
    [_scrollView addSubview:_oldPhoneNumLabel];
    [_scrollView addSubview:_oldPhoneNum];
    
    [self addSubview:_scrollView];
}

-(void)buttonClickedWithIndex:(NSInteger)index
{
    if (index == VerifyCode_btn_tag) {
        if (self.getCaptchaBlock) {
            self.getCaptchaBlock();
        }
    }else if(index == security_btn_tag){
        if(self.getCodeBlock){
        self.getCodeBlock();
        }
    }
}

#pragma mark - inputViewDelegate
- (void)inputFinishedWithView:(UIView*) view
{
    if (view == _phoneNumInputView) {
        if (!_phoneNumInputView.hidden) {
            [_phoneNumInputView.textField becomeFirstResponder];
        }
    }else if(view == _securityCodeInputView){
        if (!_securityCodeInputView.hidden) {
            [_securityCodeInputView.textField becomeFirstResponder];
        }
    }
}

- (void)textFieldChangedText:(NSString*) text
{
    if (!text || [text isEqualToString:@""])
    {
        [_securityCodeInputView setBtnEnable:NO];
    }else{
        [_securityCodeInputView setBtnEnable:_securityCodeInputView.timerStoped];
    }
}

- (BOOL)phoneNumIsValid
{
    [self endEditing:YES];
    
    if (![WVRGlobalUtil validateMobileNumber:_phoneNumInputView.textField.text]){
        SQToastIn(@"请输入正确手机号", self);
        return NO;
    } else {
        return YES;
    }
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
    
    CGSize oldPhoneNumLabelSize = [self labelTextSize:_oldPhoneNumLabel];
    CGSize oldPhoneNumSize = [self labelTextSize:_oldPhoneNum];
    CGFloat  spacingWidth = (SCREEN_WIDTH - (oldPhoneNumLabelSize.width + oldPhoneNumSize.width + 5))/2;
    
    tmpRect = [self rectInSubviewWithWidth:oldPhoneNumLabelSize.width height:oldPhoneNumLabelSize.height toLeft:spacingWidth toTop:fitToWidth(TOP_TO_VIEW)];
    _oldPhoneNumLabel.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:oldPhoneNumSize.width height:oldPhoneNumSize.height toRight:spacingWidth toTop:fitToWidth(TOP_TO_VIEW)];
    _oldPhoneNum.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_oldPhoneNumLabel.bottom + fitToWidth(TOP_TO_VIEW)];
    _phoneNumInputView.frame = tmpRect;
    
    
    tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_phoneNumInputView.bottom + fitToWidth(MARGIN_ITEM)];
    _securityCodeInputView.frame = tmpRect;
    _verifyCodeInputView.frame = tmpRect;
    if (!_verifyCodeInputView.hidden) {
        CGRect tmpRect = [self centerRectInSubviewWithWidth:fitToWidth(WIDTH_INPUT_TF) height:fitToWidth(HEIGHT_INPUT_TF) toTop:_verifyCodeInputView.bottom + fitToWidth(MARGIN_ITEM)];
        _securityCodeInputView.frame = tmpRect;
    }
    
}

- (void)layoutSubviews
{
    [self positionSubviews];
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
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
    }
}

#pragma mark - MISC
- (UIGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
}

- (NSString *)getNewPhoneNum {
    
    return _phoneNumInputView.textField.text;
}

- (NSString *)getPhoneCode {
    
    return _securityCodeInputView.textField.text;
}

- (NSString *)getCaptchaCode {
    
    return _verifyCodeInputView.textField.text;
}

- (void)startTimer {
    [_securityCodeInputView startTimer];
}

- (void)stopTimer {
    
    [_securityCodeInputView stopTimer];
}

- (void)setCaptcha:(NSString *)captcha {
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithUTF8String:captcha]];
    [_verifyCodeInputView.verifyCodeBtn setImage:[UIImage imageWithData:data]];
}

- (void)displayVeryfyCodeInputView
{
    _verifyCodeViewIsHidden = NO;
    _verifyCodeInputView.hidden = NO;
    CGRect tmpRect = [self centerRectInSubviewWithWidth:583/2 height:47 toTop:_verifyCodeInputView.bottom + 10];
    _securityCodeInputView.frame = tmpRect;
}
@end

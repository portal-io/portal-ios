//
//  WVRSearchBar.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSearchBar.h"
#import "WVRTrackEventMapping.h"

@interface WVRSearchBar()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UILabel *cancelBtn;
@property (nonatomic, strong) UIView *seperateLine;

@end


@implementation WVRSearchBar

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configSelf];
        [self allocSubviews];
        [self configSubviews];
        [self positionSubvies];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self positionSubvies];
}

- (void)dealloc {
    
    [self removeObservers];
}

#pragma mark - config

- (void)configSelf {
    
    [self addObservers];
    self.backgroundColor = [UIColor clearColor];
}

- (void)allocSubviews {
    
    _searchImageView = [[UIImageView alloc] init];
    _searchTextField = [[UITextField alloc] init];
    _clearBtn = [[UIButton alloc] init];
    
    _searchView = [[UIView alloc] init];
    _seperateLine = [[UIView alloc] init];
    _cancelBtn = [[UILabel alloc] init];
}

- (void)configSubviews
{
    _searchImageView.image = [UIImage imageNamed:@"search"];
    
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索全部视频" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xc9c9c9]}];
    [_searchTextField setTextColor:[UIColor blackColor]];
    [_searchTextField setFont:kFontFitForSize(15)];
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    
    [_clearBtn setImage:[UIImage imageNamed:@"search_close"] forState:UIControlStateNormal];
    _clearBtn.userInteractionEnabled = YES;
    _clearBtn.hidden = YES;
    [_clearBtn addTarget:self action:@selector(clearBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_clearBtn addGestureRecognizer:[self tapGesture]];
    
    _searchView.backgroundColor = [UIColor colorWithHex:0xf1f2f3];
    _searchView.layer.cornerRadius = 17.5;
    _searchView.clipsToBounds = YES;
    
    _cancelBtn.text = @"取消";
    [_cancelBtn setTextColor:[UIColor blackColor]];
    [_cancelBtn setFont:kFontFitForSize(15)];
    _cancelBtn.userInteractionEnabled = YES;
    [_cancelBtn addGestureRecognizer:[self tapGesture]];
    
    _seperateLine.backgroundColor = [UIColor colorWithHex:0xe3e3e3];
    
    [_searchView addSubview:_searchImageView];
    [_searchView addSubview:_searchTextField];
    [_searchView addSubview:_clearBtn];
    
    [self addSubview:_searchView];
    [self addSubview:_seperateLine];
    [self addSubview:_cancelBtn];
}

- (void)positionSubvies
{
    CGRect tmpRect = CGRectZero;
    
    CGSize size = [self labelTextSize:_cancelBtn];
    tmpRect = [self centerRectInSubviewWithWidth:size.width height:size.height toRight:15];
    _cancelBtn.frame = tmpRect;
    
    tmpRect.size.width = self.width - _cancelBtn.width - 32.5;
    tmpRect = [self centerRectInSubviewWithWidth:tmpRect.size.width height:35 toLeft:15/2];
    _searchView.frame = tmpRect;
    
    tmpRect = [self centerRectInSubviewWithWidth:self.width height:1 toBottom:0];
    _seperateLine.frame = tmpRect;
    
    tmpRect = [_searchView centerRectInSubviewWithWidth:19 height:19 toLeft:25/2];
    _searchImageView.frame = tmpRect;
    
    tmpRect = [_searchView centerRectInSubviewWithWidth:fitToWidth(_clearBtn.imageView.image.size.width) height:fitToWidth(_clearBtn.imageView.image.size.height) toRight:25/2];
    _clearBtn.frame = tmpRect;
    
    tmpRect.size.width = _searchView.width - _searchImageView.width - _clearBtn.width - 50;
    tmpRect = [_searchView centerRectInSubviewWithWidth:tmpRect.size.width height:35 toLeft:_searchImageView.right + 25/2];
    _searchTextField.frame = tmpRect;
}

- (void)setPlaceholder:(NSString *)holderStr {
    
    _searchTextField.placeholder = holderStr;
}

- (CGSize)labelTextSize:(UILabel*) label
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (UIResponder *)getCurrentVCWithResponder:(UIResponder *)responder
{
    UIResponder *res = responder.nextResponder;
    if ([res isKindOfClass:[UIViewController class]]) {
        return res;
    }
    else
    {
        return [self getCurrentVCWithResponder:res];
    }
}

- (void)setSearchText:(NSString*)keyword
{
    _searchTextField.text = keyword;
}

#pragma mark - Target-Action Pair

-(void)clearBtnOnClick
{
    [_searchTextField setText:@""];
    _clearBtn.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory)]) {
        [self.delegate showSearchHistory];
    }
}

- (void)cellClicked:(UIGestureRecognizer *)gesture
{
    UIView *tmpView = gesture.view;
    
    if (tmpView == _clearBtn) {
        
        [_searchTextField setText:@""];
        _clearBtn.hidden = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory)]) {
            [self.delegate showSearchHistory];
        }
    } else if(tmpView == _cancelBtn) {
        
        [WVRTrackEventMapping trackingResearch:@"cancel"];
        
        UIViewController *currentVC = (UIViewController *)[self getCurrentVCWithResponder:self];
        [currentVC.navigationController popViewControllerAnimated:YES];
    }
//    if (tmpView == _scrollView)
//    {
//        [self endEditing:YES];
//    }
}

#pragma mark - MISC

- (UIGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
    return tapGesture;
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
//    NSDictionary *userInfo = [noti userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int keyboardHeight = keyboardRect.size.height;
//    
//    CGRect tmpRect = self.frame;
//    tmpRect.size.height = self.bounds.size.height - keyboardHeight;
//    [self setFrame:tmpRect];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
//    CGRect tmpRect = self.frame;
//    [self setFrame:tmpRect];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        _clearBtn.hidden = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory)]) {
            [self.delegate showSearchHistory];
        }
    }else{
        _clearBtn.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && (1 == range.length) && (0 == range.location)) {
        _clearBtn.hidden = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory)]) {
            [self.delegate showSearchHistory];
        }
    }else{
        _clearBtn.hidden = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _clearBtn.hidden = YES;
    [_searchTextField resignFirstResponder];
    
    if (textField.text && ![textField.text isEqualToString:@""] && self.delegate && [self.delegate respondsToSelector:@selector(searchButtonClickedWithKeyWord:)]) {
        [self.delegate searchButtonClickedWithKeyWord:textField.text];
    }
    
    return YES;
}

#pragma mark - external func

- (void)showKeyboard {
    
    [self.searchTextField becomeFirstResponder];
}

-(NSString *)getCurText
{
    return self.searchTextField.text;
}
@end

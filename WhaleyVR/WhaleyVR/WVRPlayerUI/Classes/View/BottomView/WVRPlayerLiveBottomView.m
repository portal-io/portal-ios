//
//  WVRPlayerLiveBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLiveBottomView.h"
#import "WVRPlayerUIFrameMacro.h"
#import "UIImage+Extend.h"
#import "WVRPlayerViewDelegate.h"
#import "WVRCameraChangeButton.h"

//#define MARGIN_RIGHT (fitToWidth(10))
//#define MARGIN_BETWEEN_VRMODE_DEFINE (fitToWidth(20))
//#define MAX_LENGTH_SEND_TEXT (fitToWidth(40) + MARGIN_BOTTOM_TEXTFILED + MARGIN_TOP_TEXTFILED)
//
//#define HEIGHT_VR_MODEBTN (MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED - MARGIN_TOP_TEXTFILED)
//#define WIDTH_VR_MODEBTN (HEIGHT_VR_MODEBTN)
//
//#define CENTERY_SUBVIEWS ((MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED)/2)

@interface WVRPlayerLiveBottomView()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *vrModeBtn;
@property (nonatomic, weak) UIButton *defiBtn;

@property (nonatomic, strong) NSDate *lastSendDate;

@property (nonatomic, weak) UIButton *cameraBtn;
@property (nonatomic, strong) NSArray *cameraStandBtns;

@end


@implementation WVRPlayerLiveBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.defiButton = self.defiBtn;
    self.launchBtn = self.vrModeBtn;
    [self msgBtn];
}

- (void)fillData:(WVRPlayBottomCellViewModel *)args {
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    
    [self installRAC];
    
    [self dealWithCameraBtnPosition];
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
    [RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), defiTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *title = x;
        if (title.length == 0) { return; }
        [self.defiBtn setTitle:x forState:UIControlStateNormal];
    }];
    [RACObserve(((WVRPlayLiveBottomCellViewModel*)self.gViewModel), danmuSwitch) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self changeDanmuSwitchStatus:((WVRPlayLiveBottomCellViewModel*)self.gViewModel).danmuSwitch];
    }];
    [[RACObserve(((WVRPlayLiveBottomCellViewModel*)self.gViewModel), keyboardAnimatoinDone) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self keyboardAnimatoinDoneWithStatu:((WVRPlayLiveBottomCellViewModel*)self.gViewModel).isKeyboardOn];
    }];
    [[RACObserve(((WVRPlayLiveBottomCellViewModel*)self.gViewModel), isKeyboardOn) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self changeToKeyboardOnStatu:((WVRPlayLiveBottomCellViewModel*)self.gViewModel).isKeyboardOn];
    }];
    [[RACObserve(((WVRPlayBottomCellViewModel *)self.gViewModel), canShowGift) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateGiftStatus:self.gViewModel.canShowGift];
    }];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (self.cameraStandBtns) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLiveCarChooseCameraStandNoti" object:@(!hidden)];
    }
}

- (void)updateGiftStatus:(BOOL)enableShowGift {
    
    self.gGiftBtn.hidden = !self.gViewModel.canShowGift;
    
    [self dealWithCameraBtnPosition];
}

- (void)dealWithCameraBtnPosition {
    
    if (self.gViewModel.showCameraBtn) {
        if (self.gGiftBtn.hidden) {
            
            kWeakSelf(self);
            [self.cameraBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(weakself.defiBtn.mas_left).offset(0 - 20);
            }];
        } else {
            
            kWeakSelf(self);
            [self.cameraBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(weakself.gGiftBtn.mas_left).offset(0 - 20);
            }];
        }
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
}

//- (void)configSubviews {
//
//    [self vrModeBtn];
//
//    [self defiBtn];
//    [self msgBtn];
//}

- (void)updateLeadingCons {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.superview) {
        return;
    }
    
    CGFloat offset = (SCREEN_WIDTH < SCREEN_HEIGHT) && kDevice_Is_iPhoneX ? (kTabBarHeight - 49.f) : 0;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.gViewModel.height + offset);
    }];
    CGFloat offset_last_right_btn = (SCREEN_WIDTH > SCREEN_HEIGHT) && kDevice_Is_iPhoneX ? (kTabBarHeight - 49.f): 0;
    [self.vrModeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(self).offset(0 - 20 - offset_last_right_btn);
    }];
    CGFloat offset_leading = (SCREEN_WIDTH > SCREEN_HEIGHT) && kDevice_Is_iPhoneX ? kStatuBarHeight : 0;
    [self.msgBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20 + offset_leading);
    }];
}

#pragma mark - getter

- (UIButton *)msgBtn {
    if (!_msgBtn) {
        
        UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        msgBtn.backgroundColor = [UIColor clearColor];
        msgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [msgBtn setImage:[UIImage imageNamed:@"player_live_message"] forState:UIControlStateNormal];
        [msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [msgBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [msgBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [msgBtn setTitle:@"你也来说两句吧~" forState:UIControlStateNormal];
        [msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        msgBtn.titleLabel.font = FONT(14);
        msgBtn.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        msgBtn.frame = CGRectMake(10, 0, adaptToWidth(225), fitToWidth(36));
        msgBtn.layer.cornerRadius = fitToWidth(8);
        msgBtn.layer.masksToBounds = YES;
        [msgBtn addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:msgBtn];
        _msgBtn = msgBtn;
        
        @weakify(self);
        [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.vrModeBtn);
            make.left.equalTo(self).offset(20);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(adaptToWidth(160));
//            make.width.mas_equalTo(30);
//            make.right.equalTo(self.defiBtn.mas_left).offset(-20);
        }];
        msgBtn.alpha = 0.6;
    }
    return _msgBtn;
}

- (UIButton *)vrModeBtn {
    if (!_vrModeBtn) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btn setImage:[UIImage imageNamed:@"live_btn_luancher_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"live_btn_luancher_press"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(vrModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _vrModeBtn = btn;
        
        @weakify(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self).offset(15);
            make.height.equalTo(@(30));
            make.width.equalTo(@(35));
            make.right.equalTo(self).offset(0 - 20);
        }];
    }
    return _vrModeBtn;
}

- (UIButton *)defiBtn {
    
    if (!_defiBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *img = [UIImage roundImageWithColor:[UIColor colorWithWhite:0 alpha:0.3] frame:CGRectMake(0, 0, 35, 30) cornerRadius:30/2];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setTitle:@"高清" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:FONT(14)];
        
        [btn addTarget:self action:@selector(defiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _defiBtn = btn;
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.vrModeBtn);
            make.width.equalTo(weakself.vrModeBtn);
            make.height.equalTo(weakself.vrModeBtn);
            make.right.equalTo(weakself.vrModeBtn.mas_left).offset(0 - 20);
        }];
    }
    return _defiBtn;
}

- (UIButton *)gGiftBtn {
    
    if (!_gGiftBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btn setImage:[UIImage imageNamed:@"icon_gift_btn"] forState:UIControlStateNormal];
        [btn setAdjustsImageWhenHighlighted:YES];
//        [btn setImage:[UIImage imageNamed:@"icon_gift_btn"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(actionGiftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        [self addSubview:btn];
        _gGiftBtn = btn;
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.vrModeBtn);
            make.width.equalTo(weakself.vrModeBtn);
            make.height.equalTo(weakself.vrModeBtn);
            make.right.equalTo(weakself.defiBtn.mas_left).offset(0 - 20);
        }];
    }
    return _gGiftBtn;
}

/// 机位切换
- (UIButton *)cameraBtn {
    
    if (!_cameraBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btn setImage:[UIImage imageNamed:@"live_camera_stand_normal"] forState:UIControlStateNormal];
        [btn setAdjustsImageWhenHighlighted:YES];
        
        [btn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _cameraBtn = btn;
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.vrModeBtn);
            make.width.equalTo(weakself.vrModeBtn);
            make.height.equalTo(weakself.vrModeBtn);
            make.right.equalTo(weakself.gGiftBtn.mas_left).offset(0 - 20);
        }];
    }
    
    _cameraBtn.hidden = !self.gViewModel.showCameraBtn;
    
    return _cameraBtn;
}

#pragma mark - action

- (void)messageButtonClick:(UIButton *)sender {
    
    if (![self.gViewModel.delegate actionCheckLogin]) {
        return;
    }
    
    if (![self.gViewModel.delegate isCharged]) {
        SQToastInKeyWindow(kToastChargeDanmu);
        return;
    };
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(actionDanmuMessageBtnClick)]) {
        [self.gViewModel.delegate performSelector:@selector(actionDanmuMessageBtnClick)];
    }
}

- (void)vrModeBtnClick:(UIButton *)sender {
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(launchOnClick:)]) {
        [self.gViewModel.delegate launchOnClick:sender];
    }
}

- (void)actionGiftBtnClick:(UIButton*)sender
{
    if ([self.gViewModel.delegate respondsToSelector:@selector(actionGiftBtnClick)]) {
        [self.gViewModel.delegate actionGiftBtnClick];
    }
}

- (void)defiBtnClick:(UIButton *)sender {
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(chooseQuality)]) {
        [self.gViewModel.delegate chooseQuality];
    }
}

- (void)cameraBtnClick:(UIButton *)sender {
    
    if (self.cameraStandBtns) {
        
        [self removeCameraStandBtns];
        
    } else {
        
        NSArray *arr = nil;
        if ([self.gViewModel.delegate respondsToSelector:@selector(actionGetCameraStandList)]) {
            arr = [self.gViewModel.delegate actionGetCameraStandList];
        }
        
        NSMutableArray *btnArr = [NSMutableArray array];
        
        int j = (int)arr.count;
        for (NSDictionary *dict in arr) {
            
            WVRCameraChangeButton *btn = [[WVRCameraChangeButton alloc] init];
            
            btn.x = sender.x;
            btn.y = sender.y - (adaptToWidth(10) + btn.height) * j;
            btn.standType = [[dict allKeys] firstObject];
            [btn setTitle:btn.standType forState:UIControlStateNormal];
            btn.isSelect = [[[dict allValues] firstObject] boolValue];
            
            [btn addTarget:self action:@selector(changeCameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            [btnArr addObject:btn];
            
            j -= 1;
        }
        _cameraStandBtns = btnArr;
    }
    
    BOOL show = _cameraStandBtns != nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLiveCarChooseCameraStandNoti" object:@(show)];
}

- (void)changeCameraBtnClick:(WVRCameraChangeButton *)sender {
    
//    [self removeCameraStandBtns];
    
    for (WVRCameraChangeButton *btn in _cameraStandBtns) {
        btn.isSelect = (btn == sender);
    }
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(actionChangeCameraStand:)]) {
        [self.gViewModel.delegate actionChangeCameraStand:sender.standType];
    }
}

- (void)removeCameraStandBtns {
    for (UIButton *btn in _cameraStandBtns) {
        [btn removeFromSuperview];
    }
    _cameraStandBtns = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.hidden == NO) {        // 修复隐藏后还有效果的bug
        
        for (UIButton *btn in _cameraStandBtns) {
            CGPoint buttonPoint = [btn convertPoint:point fromView:self];
            if ([btn pointInside:buttonPoint withEvent:event]) {
                return btn;
            }
        }
    }
    
    UIView * view = [super hitTest:point withEvent:event];
    return view;
}

#pragma mark - func

- (void)changeToKeyboardOnStatu:(BOOL)isKeyboardOn {
    _msgBtn.alpha = (isKeyboardOn || !((WVRPlayLiveBottomCellViewModel *)self.gViewModel).danmuSwitch) ? 0 : 0.6;
    
    self.alpha = isKeyboardOn ? 0 : 1;
}

- (void)keyboardAnimatoinDoneWithStatu:(BOOL)isKeyboardOn {
    _msgBtn.hidden = isKeyboardOn && ((WVRPlayLiveBottomCellViewModel *)self.gViewModel).danmuSwitch;
    
    self.hidden = isKeyboardOn;
}

- (void)changeDanmuSwitchStatus:(BOOL)isOn {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _msgBtn.alpha = isOn ? 0.6 : 0;
    }];
}

@end

//
//  WVRPlayerLiveFootBallBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLiveFootBallBottomView.h"
#import "WVRCameraChangeButton.h"
#import "WVRPlayerUIFrameMacro.h"
#import "UIImage+Extend.h"
#import "WVRPlayerViewDelegate.h"

//#define MARGIN_RIGHT (fitToWidth(10))
//#define MARGIN_BETWEEN_VRMODE_DEFINE (fitToWidth(20))
//#define MAX_LENGTH_SEND_TEXT (fitToWidth(40) + MARGIN_BOTTOM_TEXTFILED + MARGIN_TOP_TEXTFILED)
//
//#define HEIGHT_VR_MODEBTN (35.0f)//(MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED - MARGIN_TOP_TEXTFILED)
//#define WIDTH_VR_MODEBTN (30.0f)//(HEIGHT_VR_MODEBTN)
//
//#define CENTERY_SUBVIEWS (HEIGHT_BOTTOM_VIEW_DEFAULT/2)//((MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED)/2)

@interface WVRPlayerLiveFootBallBottomView()<UITextFieldDelegate>

//@property (nonatomic, weak) UIButton *msgBtn;

//@property (nonatomic, weak) UIButton *vrModeBtn;
//@property (nonatomic, weak) UIButton *defiBtn;

@property (nonatomic, weak) UIButton *cameraBtn;    // 机位切换

@property (nonatomic, strong) NSDate *lastSendDate;

@property (nonatomic, strong) NSArray *cameraStandBtns;

@end


@implementation WVRPlayerLiveFootBallBottomView

-(void)awakeFromNib
{
    [super awakeFromNib];
//    [self configSubviews];
    [self cameraBtn];
//    self.defiButton = self.defiBtn;
//    self.launchBtn = self.vrModeBtn;
}

-(void)createLayouts
{
    @weakify(self);
    [self.gGiftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(15);
        make.height.equalTo(@(30));
        make.width.equalTo(@(35));
        make.right.equalTo(self.cameraBtn.mas_left).offset(0 - 20);
    }];
}

- (void)fillData:(WVRPlayBottomCellViewModel *)args {
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    [self installRAC];
    [self resetCameraStandBtn];
    [self createLayouts];
}

- (void)installRAC {
    [super installRAC];
    @weakify(self);
    [RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), defiTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *title = x;
        if (title.length == 0) { return; }
        [self.defiButton setTitle:x forState:UIControlStateNormal];
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
}

//-(void)updateGiftStatus:(BOOL)enableShowGift
//{
//    
//}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
}

//- (void)configSubviews {
////    [self vrModeBtn];
////    [self defiBtn];
//    [self cameraBtn];
////    [self msgBtn];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = (SCREEN_WIDTH + SCREEN_HEIGHT) * 0.5f;
    self.cameraBtn.hidden = self.width < width;
    self.gGiftBtn.hidden = self.cameraBtn.hidden||!self.gViewModel.canShowGift;
    [self checkCameraStandBtns];
}

- (void)checkCameraStandBtns {
    
    if (!_cameraStandBtns.count) { return; }
    
    float width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self.width < width) {
        
        [self removeCameraStandBtns];
    }
}

#pragma mark - overwrite func

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];

}

#pragma mark - getter

- (BOOL)isFootball {
    
    return YES;
}

- (UIButton *)cameraBtn {

    if (!_cameraBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"live_camera_stand_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"live_camera_stand_press"] forState:UIControlStateHighlighted];

        [btn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btn];
        _cameraBtn = btn;
        @weakify(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self).offset(15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.right.equalTo(self.defiButton.mas_left).offset(0 - 20);
        }];
    }
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
    
//    if (![self.gViewModel.delegate isCharged]) {
//        SQToastInKeyWindow(kToastNotChargeToUnity);
//        return;
//    }
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(launchOnClick:)]) {
        [self.gViewModel.delegate launchOnClick:sender];
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
            id<WVRPlayerViewDelegate> delegate = (id<WVRPlayerViewDelegate>)self.gViewModel.delegate;
            arr = [delegate actionGetCameraStandList];
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
}

- (void)changeCameraBtnClick:(WVRCameraChangeButton *)sender {

    for (WVRCameraChangeButton *btn in _cameraStandBtns) {
        btn.isSelect = (btn == sender);
    }

    if ([self.gViewModel.delegate respondsToSelector:@selector(actionChangeCameraStand:)]) {
        [self.gViewModel.delegate actionChangeCameraStand:sender.standType];
    }
}

-(void)resetCameraStandBtn
{
    for (WVRCameraChangeButton *btn in _cameraStandBtns) {
        btn.isSelect = NO;
    }
    WVRCameraChangeButton *btn = [_cameraStandBtns firstObject];
    btn.isSelect = YES;
}

- (void)removeCameraStandBtns {
    for (UIButton *btn in _cameraStandBtns) {
        [btn removeFromSuperview];
    }
    _cameraStandBtns = nil;
}

#pragma mark - func

- (void)changeToKeyboardOnStatu:(BOOL)isKeyboardOn {
    
    self.msgBtn.alpha = (isKeyboardOn || !((WVRPlayLiveBottomCellViewModel*)self.gViewModel).danmuSwitch) ? 0 : 0.6;
    
    self.alpha = isKeyboardOn ? 0 : 1;
}

- (void)keyboardAnimatoinDoneWithStatu:(BOOL)isKeyboardOn {
    
    self.msgBtn.hidden = isKeyboardOn && ((WVRPlayLiveBottomCellViewModel*)self.gViewModel).danmuSwitch;
    
    self.hidden = isKeyboardOn;
}

- (void)setVisibel:(BOOL)isVisibel {
    
    if (isVisibel) { self.hidden = NO; }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = isVisibel ? 1 : 0;
        
    } completion:^(BOOL finished) {
        
        self.hidden = !isVisibel;
    }];
}

- (void)changeDanmuSwitchStatus:(BOOL)isOn {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.msgBtn.alpha = isOn ? 0.6 : 0;
    }];
}

- (void)updateCamerabtnForFootball {
    
    float width = (SCREEN_WIDTH + SCREEN_HEIGHT) * 0.5f;
    self.cameraBtn.hidden = self.width < width;
    self.gGiftBtn.hidden = self.cameraBtn.hidden || !self.gViewModel.canShowGift;
}

- (NSString *)cameraPoint {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];

    CGPoint point = [self convertPoint:_cameraBtn.center toView:window];
    
    return NSStringFromCGPoint(point);
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

@end

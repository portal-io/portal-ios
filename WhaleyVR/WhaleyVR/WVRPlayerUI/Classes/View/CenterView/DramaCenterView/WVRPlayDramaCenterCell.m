//
//  WVRPlayDramaCenterCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayDramaCenterCell.h"
#import "WVRPlayDramaCenterCellViewModel.h"

#define MARGIN_LEADING_TWO_FULL (91.f)
#define MARGIN_LEADING_THREE_FULL (73.5f)
#define MARGIN_LEADING_TWO_SMALL (45.f)
#define MARGIN_LEADING_THREE_SMALL (43.5f)
#define WIDTH_FULL (155.f)
#define WIDTH_SMALL (105.f)

@interface WVRPlayDramaCenterCell() {
    BOOL _isRegisterObserver;
}

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnLeadingCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnTraillingCons;

@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, assign) CGFloat gFullLeading;
@property (nonatomic, assign) CGFloat gSmallLeading;

@property (nonatomic, strong) UIImage *placeholderImg;

- (IBAction)chooseDramsOnClick:(id)sender;

@end


@implementation WVRPlayDramaCenterCell

#define HeartbeatAnimationName @"transform.scale"

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton *btn in self.subviews) {
        if (![btn isKindOfClass:[UIButton class]]) {
            continue;
        }
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    self.leftBtn.tag = 0;
    self.middleBtn.tag = 1;
    self.rightBtn.tag = 2;
    
    [self dealWithNotification];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - data handle

- (void)fillData:(WVRPlayViewCellViewModel *)args
{
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    
    [self installRAC];
}

- (UIImage *)placeholderImg {
    
    if (!_placeholderImg) {
        _placeholderImg = [[UIImage alloc] init];
    }
    return _placeholderImg;
}

- (void)dealWithNotification {
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self stopHeartbeatAnimation];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self startHeartbeatAnimation];
    }];
}

- (void)didMoveToSuperview {
    if (_isRegisterObserver) {
        return;
    }
    _isRegisterObserver = YES;
    
    @weakify(self);
    [[[self wvr_viewController] rac_signalForSelector:@selector(viewDidDisappear:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self stopHeartbeatAnimation];
    }];
    [[[self wvr_viewController] rac_signalForSelector:@selector(viewDidAppear:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self startHeartbeatAnimation];
    }];
}

- (void)installRAC
{
    @weakify(self);
    [RACObserve(self.gViewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus:self.gViewModel.playStatus];
    }];
    [RACObserve(((WVRPlayDramaCenterCellViewModel *)self.gViewModel), gDramaStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateDramaStatus:[x integerValue]];
    }];
    
    kWeakSelf(self);
    [RACObserve(((WVRPlayDramaCenterCellViewModel *)self.gViewModel), leftIcon) subscribeNext:^(id  _Nullable x) {
        
        [weakself.leftBtn setImage:weakself.placeholderImg forState:UIControlStateNormal];
        if (x) {
            [weakself.leftBtn.imageView wvr_setImageWithURL:[NSURL URLWithString:x] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
                
                [weakself.leftBtn setImage:image forState:UIControlStateNormal];
            }];
        }
    }];
    [RACObserve(((WVRPlayDramaCenterCellViewModel *)self.gViewModel), middleIcon) subscribeNext:^(id  _Nullable x) {
        
        [weakself.middleBtn setImage:weakself.placeholderImg forState:UIControlStateNormal];
        if (x) {
            
            [weakself.middleBtn.imageView wvr_setImageWithURL:[NSURL URLWithString:x] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
                
                [weakself.middleBtn setImage:image forState:UIControlStateNormal];
            }];
            
            [weakself layoutForThreeDrama];
        } else {
            
            [weakself layoutForTwoDrama];
        }
    }];
    [RACObserve(((WVRPlayDramaCenterCellViewModel *)self.gViewModel), rightIcon) subscribeNext:^(id  _Nullable x) {
        
        [weakself.rightBtn setImage:weakself.placeholderImg forState:UIControlStateNormal];
        if (x) {
            [weakself.rightBtn.imageView wvr_setImageWithURL:[NSURL URLWithString:x] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
                
                [weakself.rightBtn setImage:image forState:UIControlStateNormal];
            }];
        }
    }];
    ((WVRPlayDramaCenterCellViewModel *)self.gViewModel).goFullAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startGoFullAnimation];
        });
        return [RACSignal empty];
    }];
    
    ((WVRPlayDramaCenterCellViewModel *)self.gViewModel).goSmallAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startGoSmallAnimation];
        });
        return [RACSignal empty];
    }];
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    
}

- (void)updateDramaStatus:(WVRPlayerToolVStatus)status {
    switch (status) {
        case WVRPlayerToolVStatusWatingChooseDrama:
            [self startHeartbeatAnimation];
            
            self.gViewModel.lockStatus = WVRPlayerToolVStatusNotLock;
            self.hidden = NO;
            break;
        case WVRPlayerToolVStatusPreChooseDrama:
        case WVRPlayerToolVStatusChoosedDrama:
            [self stopHeartbeatAnimation];
            self.hidden = YES;
            break;
        default:
            self.hidden = YES;
            break;
    }
    
}

- (void)layoutForTwoDrama
{
    if (self.isFull) {
        self.leftBtnLeadingCons.constant = MARGIN_LEADING_TWO_FULL;
        self.rightBtnTraillingCons.constant = MARGIN_LEADING_TWO_FULL;
        
    } else {
        self.leftBtnLeadingCons.constant = MARGIN_LEADING_TWO_SMALL;
        self.rightBtnTraillingCons.constant = MARGIN_LEADING_TWO_SMALL;
        
    }
    self.gFullLeading = MARGIN_LEADING_TWO_FULL;
    self.gSmallLeading = MARGIN_LEADING_TWO_SMALL;
    self.middleBtn.hidden = YES;
    [self layoutIfNeeded];
}

- (void)layoutForThreeDrama
{
    if (self.isFull) {
        self.leftBtnLeadingCons.constant = MARGIN_LEADING_THREE_FULL;
        self.rightBtnTraillingCons.constant = MARGIN_LEADING_THREE_FULL;
    }else{
        self.leftBtnLeadingCons.constant = MARGIN_LEADING_THREE_SMALL;
        self.rightBtnTraillingCons.constant = MARGIN_LEADING_THREE_SMALL;
        
    }
    self.gFullLeading = MARGIN_LEADING_THREE_FULL;
    self.gSmallLeading = MARGIN_LEADING_THREE_SMALL;
    self.middleBtn.hidden = NO;
    [self layoutIfNeeded];
}

- (void)startGoFullAnimation {
    
    [self stopHeartbeatAnimation];
    
    self.isFull = YES;
    self.leftBtnLeadingCons.constant = 158.5f;
    self.rightBtnTraillingCons.constant = 158.5f;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        self.middleTopCons.constant = self.height-WIDTH_FULL;
        self.leftWidthCons.constant = WIDTH_FULL;
        self.leftHeightCons.constant = WIDTH_FULL;
        self.leftBtnLeadingCons.constant = self.gFullLeading;
        self.rightBtnTraillingCons.constant = self.gFullLeading;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self startHeartbeatAnimation];
    }];
}

- (void)startGoSmallAnimation {
    
    [self stopHeartbeatAnimation];
    
    self.isFull = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.middleTopCons.constant = 35.f;
        self.leftWidthCons.constant = WIDTH_SMALL;
        self.leftHeightCons.constant = WIDTH_SMALL;
        self.leftBtnLeadingCons.constant = self.gSmallLeading;
        self.rightBtnTraillingCons.constant = self.gSmallLeading;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self startHeartbeatAnimation];
    }];
}

- (IBAction)chooseDramsOnClick:(UIButton *)sender {
    self.hidden = YES;
    [((WVRPlayDramaCenterCellViewModel *)self.gViewModel).gChooseDramaSubjcet sendNext:@(sender.tag)];
    
    [self stopHeartbeatAnimation];
}

- (BOOL)playerUINotAutoHide {
    
    return YES;
}

- (BOOL)playerUINotAutoShow
{
    return YES;
}

/// TopView不需要接收事件，不过他的子视图可以接收
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

- (void)startHeartbeatAnimation {
    
    if (self.superview) {
        
        [self heartbeatAnimationForBtn:self.leftBtn];
        [self heartbeatAnimationForBtn:self.middleBtn];
        [self heartbeatAnimationForBtn:self.rightBtn];
    }
}

- (void)stopHeartbeatAnimation {
    
    [self.leftBtn.layer removeAnimationForKey:HeartbeatAnimationName];
    [self.middleBtn.layer removeAnimationForKey:HeartbeatAnimationName];
    [self.rightBtn.layer removeAnimationForKey:HeartbeatAnimationName];
}

/// 心跳动画
- (void)heartbeatAnimationForBtn:(UIButton *)btn {
    
    if (!btn || !btn.superview) { return; }
    if (btn.hidden) { return; }
    
    // 心跳动画
    float bigSize = 1.04;
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:HeartbeatAnimationName];
    pulseAnimation.duration = 0.6;
    pulseAnimation.toValue = [NSNumber numberWithFloat:bigSize];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    // 倒转动画
    pulseAnimation.autoreverses = YES;
    // 设置重复次数为无限大
    pulseAnimation.repeatCount = FLT_MAX;
    // 添加动画到layer
    [btn.layer addAnimation:pulseAnimation forKey:HeartbeatAnimationName];
}

@end

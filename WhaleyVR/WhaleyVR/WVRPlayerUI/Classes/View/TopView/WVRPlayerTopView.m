//
//  WVRPlayerTopToolView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerTopView.h"
#import "WVRPlayTopCellViewModel.h"

@interface WVRPlayerTopView ()

@property (nonatomic, weak) UIView *topShadow;

@property (nonatomic, assign) WVRPlayerToolVStatus gPlayStatus;

@property (nonatomic, weak) CAGradientLayer *gGradientLayer;

@end


@implementation WVRPlayerTopView
@synthesize gViewModel = _gViewModel;

- (void)setGViewModel:(WVRPlayTopCellViewModel *)gViewModel
{
    _gViewModel = gViewModel;
}

- (WVRPlayTopCellViewModel *)gViewModel
{
    return (WVRPlayTopCellViewModel*)_gViewModel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gGradientLayer.frame = self.bounds;
    self.topShadow.frame = self.bounds;
    [self updateLeadingCons];
}

- (void)updateLeadingCons
{
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* cur in cons) {
        if (cur.firstItem == self.backBtn) {
            if (cur.firstAttribute == NSLayoutAttributeTop) {
                cur.constant = (self.height - self.backBtn.height)/2;
            }
        }
    }
    if (kDevice_Is_iPhoneX) {
        self.backBtnLeadingCons.constant = kStatuBarHeight + 15.f;
    } else {
        self.backBtnLeadingCons.constant = 15.f;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self topShadow];
}

- (void)fillData:(WVRPlayViewCellViewModel *)args
{
    [super fillData:args];
//    self.gViewModel.delegate;
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
//    RAC(self.titleL, text) = RACObserve(self.gViewModel, title);
    [RACObserve(((WVRPlayTopCellViewModel*)self.gViewModel), title) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.titleL.text = x;
    }];
    
    [RACObserve(self.gViewModel, animationStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gViewModel.animationStatus == WVRPlayerToolVStatusAnimating) {
            self.backBtn.hidden = YES;
        } else if (self.gViewModel.animationStatus == WVRPlayerToolVStatusAnimationComplete) {
            self.backBtn.hidden = NO;
        }
    }];
}

- (UIView *)topShadow {
    if (!_topShadow) {
        
        UIView *topShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), self.height)];
        
        // 设置渐变效果
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = topShadow.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                                (id)[[UIColor colorWithWhite:0 alpha:0] CGColor], nil];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        self.gGradientLayer = gradientLayer;
        [topShadow.layer insertSublayer:gradientLayer atIndex:0];
        
        topShadow.backgroundColor = [UIColor clearColor];
        
        [self insertSubview:topShadow atIndex:0];
//        [topShadow mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(0));
//            make.right.equalTo(@(0));
//            make.top.equalTo(@(0));
//            make.bottom.equalTo(@(0));
//        }];
        _topShadow = topShadow;
    }
    return _topShadow;
}

- (IBAction)backOnClick:(id)sender {
    if ([self.gViewModel.delegate respondsToSelector:@selector(backOnClick:)]) {
        [self.gViewModel.delegate backOnClick:sender];
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
//    if (self.gViewModel.lockStatus == WVRPlayerToolVStatusNotLock) {
//        self.hidden = NO;
//    }else{
//
//    }
    switch (status) {
        case WVRPlayerToolVStatusDefault:
            
            break;
        case WVRPlayerToolVStatusPrepared:
            
            break;
        case WVRPlayerToolVStatusPlaying:
            
            break;
        case WVRPlayerToolVStatusPause:
            
            break;
        case WVRPlayerToolVStatusStop:
            
            break;
        case WVRPlayerToolVStatusError:
            
            break;
            
        default:
            break;
    }
}

/// TopView不需要接收事件，不过他的子视图可以接收
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self || hitView == self.topShadow) {
        return nil;
    }
    return hitView;
}

@end

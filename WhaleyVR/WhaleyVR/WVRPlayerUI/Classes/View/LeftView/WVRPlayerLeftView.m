//
//  WVRPlayerLeftToolView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLeftView.h"
#import "WVRPlayLeftCellViewModel.h"

@interface WVRPlayerLeftView ()

@property (nonatomic) WVRPlayerToolVQuality quality;

- (IBAction)clockBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clockBtn;

@end


@implementation WVRPlayerLeftView

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//
//}

- (void)fillData:(WVRPlayLeftCellViewModel *)args
{
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    [self installRAC];
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
    [RACObserve(self.gViewModel, gDramaStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateDramaStatus:[x integerValue]];
    }];
}

// MARK: - UI

// 防止它影响层级在它之下的控件的点击事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

// MARK: - external func

- (void)updateHidenStatus:(BOOL)isHiden
{
    if (self.gViewModel.gDramaStatus == WVRPlayerToolVStatusWatingChooseDrama) {
        return;
    }
    self.hidden = isHiden;
}

- (IBAction)clockBtnOnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if ([self.gViewModel.delegate respondsToSelector:@selector(clockOnClick:)]) {
        [self.gViewModel.delegate clockOnClick:sender.selected];
    }
}

-(void)updateLockStatus:(WVRPlayerToolVStatus)status
{
    switch (status) {
        case WVRPlayerToolVStatusNotLock:
            self.clockBtn.selected = NO;
            break;
        case WVRPlayerToolVStatusLock:
            self.clockBtn.selected = YES;
            break;
        default:
            break;
    }
}

-(void)updatePayStatus:(WVRPlayerToolVStatus)status
{
    [super updatePayStatus:status];
    switch (status) {
        case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        case WVRPlayerToolVStatusPaySuccess:
            [self enablePaySuccessStatus];
            break;
        default:
            break;
    }
}

-(void)enableWatingPayStatus
{
    self.hidden = YES;
}

-(void)enablePaySuccessStatus
{
    self.hidden = NO;
}

- (void)updateDramaStatus:(WVRPlayerToolVStatus)status {
    switch (status) {
        case WVRPlayerToolVStatusWatingChooseDrama:
            self.hidden = YES;
            break;
        case WVRPlayerToolVStatusPreChooseDrama:
        case WVRPlayerToolVStatusChoosedDrama:
            self.hidden = self.gViewModel.viewIsHiden;
            break;
        default:
            
            break;
    }
    
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
//    self.hidden = NO;
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

- (BOOL)playerUINotAutoShow {
    
    return YES;//(self.gViewModel.gDramaStatus == WVRPlayerToolVStatusWatingChooseDrama);
}
- (BOOL)playerUINotAutoHide {
    
    return YES;
}

@end

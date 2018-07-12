//
//  WVRPlayGiftContainerCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayGiftContainerCell.h"
#import "WVRPlayGiftContainerCellViewModel.h"
#import "WVRGiftAnimalView.h"
#import "WVRGiftTempView.h"
#import "WVRMediator+AccountActions.h"

@interface WVRPlayGiftContainerCell()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) WVRGiftTempView * gGiftView;
@property (nonatomic, weak) WVRGiftAnimalView * gGiftAnimalView;

@end

@implementation WVRPlayGiftContainerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponse)];
    [self addGestureRecognizer:tapG];
    tapG.delegate = self;
}

- (void)fillData:(WVRPlayViewCellViewModel *)args
{
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    WVRPlayGiftContainerCellViewModel* curViewModel = (WVRPlayGiftContainerCellViewModel *)args;//self.gViewModel;
    
    self.gGiftView = (WVRGiftTempView *)[curViewModel.gGiftPresenter bindContainerView:self];
    self.gGiftAnimalView = (WVRGiftAnimalView*)[curViewModel.gGiftAnimationPresenter bindContainerView:self];
    @weakify(self);
    curViewModel.gShowGiftContainerCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [WVRAppModel sharedInstance].shouldContinuePlay = YES;
        BOOL isLogin = [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:nil];
        if (isLogin) {
            self.userInteractionEnabled = YES;
            curViewModel.gGiftPresenter.viewIsHiden = NO;
            [curViewModel.gGiftPresenter reloadData];
            [self updateGiftAnimationViewForShowGiftTemp];
            curViewModel.gGiftStatus = WVRPlayerToolVStatusGiftShow;
        }
        return [RACSignal empty];
    }];
    curViewModel.gGiftPresenter.isPortrait = YES;
    curViewModel.gGiftPresenter.viewIsHiden = YES;
    curViewModel.gGiftAnimationPresenter.isPortrait = YES;
    [RACObserve(curViewModel, displayMode) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (curViewModel.displayMode == WVRLiveDisplayModeHorizontal) {
            curViewModel.gGiftPresenter.isPortrait = NO;
            curViewModel.gGiftAnimationPresenter.isPortrait = NO;
        }
        [self updategiftAnimationViewForHidenGiftTemp];
    }];
}

- (void)updateGiftAnimationViewForShowGiftTemp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WVRPlayGiftContainerCellViewModel* curViewModel = (WVRPlayGiftContainerCellViewModel*)self.gViewModel;//self.gViewModel;
        CGFloat offsetY = 0;
        if (curViewModel.displayMode == WVRLiveDisplayModeHorizontal) {
            offsetY = self.gGiftAnimalView.height/2-self.height/2;
            self.gGiftAnimalView.hidden = YES;
        } else {
            offsetY = -self.height/4;
            self.gGiftAnimalView.hidden = NO;
        }
        [self.gGiftAnimalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(offsetY);
        }];
        [self layoutIfNeeded];
    });
}

- (void)updategiftAnimationViewForHidenGiftTemp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WVRPlayGiftContainerCellViewModel* curViewModel = (WVRPlayGiftContainerCellViewModel*)self.gViewModel;//self.gViewModel;
        CGFloat offsetY = 0;
        if (curViewModel.displayMode == WVRLiveDisplayModeHorizontal) {
            offsetY = -MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2+HEIGHT_TOP_VRMODE_VIEW_DEFAULT+20;
        }
        self.gGiftAnimalView.hidden = NO;
        [self.gGiftAnimalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(offsetY);
        }];
        [self layoutIfNeeded];
    });
}

- (void)tapResponse
{
    WVRPlayGiftContainerCellViewModel* curViewModel = (WVRPlayGiftContainerCellViewModel*)self.gViewModel;//self.gViewModel;
    curViewModel.gGiftPresenter.viewIsHiden = YES;
    self.userInteractionEnabled = NO;
    curViewModel.gGiftStatus = WVRPlayerToolVStatusGiftHiden;
    [self updategiftAnimationViewForHidenGiftTemp];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    UIView * view = touch.view;
    if (view == self || [NSStringFromClass([view class]) isEqualToString:@"WVRGiftTempView"]) {
        return YES;
    }
    return NO;
}

@end

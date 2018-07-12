//
//  WVRPlayCenterViewCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayVRCenterViewCell.h"
#import "WVRPlayerLoadingView.h"
#import "WVRPlayLoadingCellViewModel.h"

@interface WVRPlayVRCenterViewCell()

@property (nonatomic, strong) WVRPlayLoadingCellViewModel * gLeftViewModel;
@property (nonatomic, strong) WVRPlayLoadingCellViewModel * gRightViewModel;

@property (weak, nonatomic) IBOutlet WVRPlayerLoadingView *leftLoadingView;
@property (weak, nonatomic) IBOutlet WVRPlayerLoadingView *rightLoadingView;

@end

@implementation WVRPlayVRCenterViewCell
@synthesize gViewModel = _gViewModel;

-(void)setGViewModel:(WVRPlayViewCellViewModel *)gViewModel
{
    _gViewModel = gViewModel;
}

-(WVRPlayViewCellViewModel *)gViewModel
{
    return (WVRPlayLoadingCellViewModel *)_gViewModel;
}

-(WVRPlayLoadingCellViewModel *)gLeftViewModel
{
    if (!_gLeftViewModel) {
        _gLeftViewModel = [[WVRPlayLoadingCellViewModel alloc] init];
    }
    return _gLeftViewModel;
}

-(WVRPlayLoadingCellViewModel *)gRightViewModel
{
    if (!_gRightViewModel) {
        _gRightViewModel = [[WVRPlayLoadingCellViewModel alloc] init];
    }
    return _gRightViewModel;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
//    self.backBtn.hidden = YES;
}

- (void)installRAC
{
    @weakify(self);
    RAC(self.gLeftViewModel, gNetSpeed) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gNetSpeed);
    RAC(self.gRightViewModel, gNetSpeed) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gNetSpeed);
    RAC(self.gLeftViewModel, gTitle) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gTitle);
    RAC(self.gRightViewModel, gTitle) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gTitle);
    RAC(self.gLeftViewModel, gErrorMsg) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gErrorMsg);
    RAC(self.gRightViewModel, gErrorMsg) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gErrorMsg);
    RAC(self.gLeftViewModel, gErrorCode) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gErrorCode);
    RAC(self.gRightViewModel, gErrorCode) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gErrorCode);
    RAC(self.gLeftViewModel, delegate) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), delegate);
    RAC(self.gRightViewModel, delegate) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), delegate);
    RAC(self.gLeftViewModel, gHidenBack) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gHidenBack);
    RAC(self.gRightViewModel, gHidenBack) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gHidenBack);
    RAC(self.gLeftViewModel, gCanTrail) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gCanTrail);
    RAC(self.gRightViewModel, gCanTrail) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gCanTrail);
    RAC(self.gLeftViewModel, gPrice) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gPrice);
    RAC(self.gRightViewModel, gPrice) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gPrice);
    RAC(self.gLeftViewModel, vrStatus) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), vrStatus);
    RAC(self.gRightViewModel, vrStatus) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), vrStatus);
    RAC(self.gLeftViewModel, gIsLive) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gIsLive);
    RAC(self.gRightViewModel, gIsLive) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gIsLive);
    RAC(self.gLeftViewModel, gPayStatus) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gPayStatus);
    RAC(self.gRightViewModel, gPayStatus) = RACObserve(((WVRPlayLoadingCellViewModel *)[self gViewModel]), gPayStatus);
    self.gLeftViewModel.gHidenVRBackBtn = NO;
    self.gRightViewModel.gHidenVRBackBtn = YES;
    self.gLeftViewModel.gHidenBack = YES;
    self.gRightViewModel.gHidenBack = YES;
    [RACObserve(self.gViewModel, playStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus:self.gViewModel.playStatus];
    }];
    [RACObserve(self.gViewModel, lockStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateLockStatus:self.gViewModel.lockStatus];
    }];
    [RACObserve(self.gViewModel, vrStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateVRStatus:self.gViewModel.vrStatus];
    }];
    [RACObserve(self.gViewModel, gPayStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updatePayStatus:self.gViewModel.gPayStatus];
    }];
}

- (void)fillData:(WVRPlayLoadingCellViewModel *)args
{
    if (self.gViewModel == args) {
        [self updateStatus:self.gViewModel.playStatus];
        self.gLeftViewModel.gHidenVRBackBtn = NO;
        self.gRightViewModel.gHidenVRBackBtn = YES;
        self.gLeftViewModel.gHidenBack = YES;
        self.gRightViewModel.gHidenBack = YES;
        return;
    }
    self.gViewModel = args;
    [self installRAC];
    [self.leftLoadingView fillData:self.gLeftViewModel];
    [self.rightLoadingView fillData:self.gRightViewModel];
}

-(void)updateVRStatus:(WVRPlayerToolVStatus)status
{
//    [self.superview insertSubview:self atIndex:0];
//    switch (status) {
//        case WVRPlayerToolVStatusVR:
//            [self enableVRStatus];
//            break;
//        case WVRPlayerToolVStatusNotVR:
//            [self enableNotVRStatus];
//            break;
//        default:
//            break;
//    }
}

-(void)updatePayStatus:(WVRPlayerToolVStatus)status
{
    [super updatePayStatus:status];
    switch (status) {
        case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        case WVRPlayerToolVStatusPaySuccess:
            
            break;
        default:
            break;
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    self.gLeftViewModel.playStatus = status;
    self.gRightViewModel.playStatus = status;
    
    switch (status) {
        case WVRPlayerToolVStatusDefault:
            [self enableDefaultStatus];
            break;
        case WVRPlayerToolVStatusPreparing:
            [self enablePreparingStatus];
            break;
        case WVRPlayerToolVStatusPrepared:
            [self enablePreparedStatus];
            break;
        case WVRPlayerToolVStatusPlaying:
            [self enablePlayingStatus];
            break;
        case WVRPlayerToolVStatusPause:
        case WVRPlayerToolVStatusUserPause:
            [self enablePauseStatus];
            break;
        case WVRPlayerToolVStatusStop:
            [self enableStopStatus];
            break;
        case WVRPlayerToolVStatusComplete:
            [self enableCompleteStatus];
            break;
        case WVRPlayerToolVStatusError:
            [self enableErrorStatus];
            break;
        case WVRPlayerToolVStatusChangeQuality:
            [self enableChangeQuStatus];
            break;
        case WVRPlayerToolVStatusSliding:
            [self enableSlidingStatus];
            break;
        case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        default:
            break;
    }
}

//- (void)enableNotClockStatus {
//    self.hidden = NO;
//    self.userInteractionEnabled = NO;
//}

- (void)enableDefaultStatus {
    self.hidden = YES;
    self.userInteractionEnabled = NO;
//    self.leftLoadingView.hidden = NO;
//    self.rightLoadingView.hidden = NO;
}

- (void)enablePreparingStatus
{
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    [self.superview bringSubviewToFront:self];
}

- (void)enablePreparedStatus {
    self.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enablePlayingStatus {
    self.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enablePauseStatus {
    self.hidden = NO;
    self.userInteractionEnabled = NO;
}

- (void)enableStopStatus {
    self.hidden = NO;
    self.userInteractionEnabled = NO;
}

- (void)enableCompleteStatus {
    self.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)enableErrorStatus {
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    [self.superview bringSubviewToFront:self];
}

- (void)enableChangeQuStatus {
    self.hidden = NO;
    self.userInteractionEnabled = NO;
}

- (void)enableSlidingStatus {
    self.hidden = NO;
    self.userInteractionEnabled = NO;
}

- (void)enableWatingPayStatus {
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    [self.superview bringSubviewToFront:self];
}

- (void)enableVRStatus {
//    self.hidden = NO;
    
}

-(void)enableNotVRStatus
{
//    self.hidden = YES;
//    [self.superview insertSubview:self atIndex:0];
}

- (IBAction)backOnClick:(id)sender {
    if ([self.gViewModel.delegate respondsToSelector:@selector(backOnClick:)]) {
        [self.gViewModel.delegate backOnClick:sender];
    }
}

@end

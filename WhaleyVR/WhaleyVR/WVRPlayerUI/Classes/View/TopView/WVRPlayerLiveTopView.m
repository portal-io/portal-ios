
//
//  WVRLivePlayerTopToolView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerLiveTopView.h"
#import "WVRPlayLiveTopCellViewModel.h"
#import "WVRLotteryBoxView.h"
#import "WVRLiveInfoAlertView.h"
#import "SNUtilToolHead.h"
#import "WVRPlayLiveTopCellViewModel.h"

#define WIDTH_SHARE_BTN (37)


@interface WVRPlayerLiveTopView ()

@property (nonatomic, weak) WVRLiveInfoAlertView * mTitleAlertV;


@end


@implementation WVRPlayerLiveTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contributionListV.hidden = YES;
    self.contributionListV.layer.masksToBounds = YES;
    self.contributionListV.layer.cornerRadius = self.contributionListV.height/2;
    UITapGestureRecognizer *tapContribL = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContribLResponse)];
    [self.contributionListV addGestureRecognizer:tapContribL];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.titleLabel addGestureRecognizer:tap];
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.countLabel addGestureRecognizer:_tap];
    for (UIView *view in self.subviews) {
        view.userInteractionEnabled = YES;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLeadingCons];
//    if (SCREEN_WIDTH>SCREEN_HEIGHT) {
//        self.contributionListV.x = 
//    }else{
//        
//    }
}

-(void)updateLeadingCons
{
    CGFloat offsetLeading = (SCREEN_WIDTH>SCREEN_HEIGHT)&&kDevice_Is_iPhoneX? kStatuBarHeight:0;
    CGFloat offsetTraining = (SCREEN_WIDTH>SCREEN_HEIGHT)&&kDevice_Is_iPhoneX? (kTabBarHeight-49.f):0;
    self.titleLableCons.constant = offsetLeading + 16.f;
    self.backCons.constant = offsetTraining+16.f;
}

-(void)tapContribLResponse
{
//    SQToastInKeyWindow(@"贡献榜");
    if ([self.gViewModel.delegate respondsToSelector:@selector(gotoContribution:)]) {
        [self.gViewModel.delegate gotoContribution:self];
    }
}

- (WVRPlayLiveTopCellViewModel *)getGViewModel
{
    return (WVRPlayLiveTopCellViewModel*)self.gViewModel;
}

- (void)fillData:(WVRPlayLiveTopCellViewModel *)args
{
    [super fillData:args];
    
}

- (void)installRAC
{
    [super installRAC];
//    RAC(self.titleLabel,text) = RACObserve([self getGViewModel], title);
    @weakify(self);
    [RACObserve([self getGViewModel], title) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.titleLabel.text = x;
    }];
    [RACObserve(((WVRPlayLiveTopCellViewModel*)self.gViewModel), playCount) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString * str = [NSString stringWithFormat:@" %@人", [WVRComputeTool numberToString:[self getGViewModel].playCount]];
        CGSize size = [WVRComputeTool sizeOfString:str Size:CGSizeMake(100, self.countLabel.height) Font:self.countLabel.font];
        self.countLabelWidth.constant = size.width;
        self.countLabel.text = str;
    }];
    [RACObserve(self.gViewModel, canShowGift) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateContributionViewStatus:self.gViewModel.canShowGift];
    }];
}

-(void)updateContributionViewStatus:(BOOL)show
{
    self.contributionListV.hidden = !show;
}

- (IBAction)shareOnClick:(id)sender {
    if ([[self getGViewModel].delegate respondsToSelector:@selector(shareOnClick:)]) {
        [[self getGViewModel].delegate shareOnClick:self];
    }
}

- (void)updateStatus:(WVRPlayerToolVStatus)status
{
    [super updateStatus:status];
    if (self.gViewModel.gPayStatus == WVRPlayerToolVStatusWatingPay) {//如果是等待支付状态，一切操作都不响应
        
        return;
    }
    switch (status) {
        case WVRPlayerToolVStatusDefault:
        case WVRPlayerToolVStatusPrepared:
        case WVRPlayerToolVStatusPlaying:
        case WVRPlayerToolVStatusPause:
        case WVRPlayerToolVStatusStop:
        case WVRPlayerToolVStatusError:
            [self enablePaySuccessStatus];
            break;
       case WVRPlayerToolVStatusWatingPay:
            [self enableWatingPayStatus];
            break;
        default:
            break;
    }
}

-(void)enableWatingPayStatus
{
    for (UIView * cur in self.subviews) {
        cur.hidden = YES;
    }
    self.hidden = NO;
    self.backBtn.hidden = NO;
    [self.backBtn setImage:[UIImage imageNamed:@"icon_live_watingPay_close"] forState:UIControlStateNormal];
    self.backBtn.tintColor = [UIColor whiteColor];
}

-(void)enablePaySuccessStatus
{
    for (UIView * cur in self.subviews) {
        cur.hidden = NO;
    }
    self.contributionListV.hidden = !self.gViewModel.canShowGift;
    self.shareLeftLineV.hidden = !self.gViewModel.canShowGift;
    [self.backBtn setImage:[UIImage imageNamed:@"player_live_exit"] forState:UIControlStateNormal];
}

#pragma mark - action

- (void)tapAction {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self.superview respondsToSelector:@selector(scheduleHideControls)]) {
        [self.superview performSelector:@selector(scheduleHideControls)];
    }
#pragma clang diagnostic pop
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(refreshLiveAlertInfo)]) {
        [((WVRPlayLiveTopCellViewModel *)self.gViewModel).delegate refreshLiveAlertInfo];
    }
    
    self.mTitleAlertV = (WVRLiveInfoAlertView *)VIEW_WITH_NIB(NSStringFromClass([WVRLiveInfoAlertView class]));
    self.mTitleAlertV.titleL.text = ((WVRPlayLiveTopCellViewModel *)self.gViewModel).title;
    self.mTitleAlertV.subTitleL.text = [NSString stringWithFormat:@"%@人正在观看", [WVRComputeTool numberToString:[self getGViewModel].playCount]];
    
    long time = [[NSDate date] timeIntervalSince1970];
    long t = (time - [self getGViewModel].beginTime / 1000) / 60;
    self.mTitleAlertV.ingTimeL.text = [NSString stringWithFormat:@"已开播%ld分钟", t];
    
    self.mTitleAlertV.addressL.text = [self getGViewModel].address;
    self.mTitleAlertV.intrL.text = [self getGViewModel].intro;
    
    UIView *view = kRootViewController.view;
    self.mTitleAlertV.frame = view.bounds;
    
    [view addSubview:self.mTitleAlertV];
}

@end

//
//  WVRFootballLiveCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballLiveCell.h"
#import "WVRFootballModel.h"
#import "SQDateTool.h"

@interface WVRFootballLiveCell ()

@property (weak, nonatomic) IBOutlet UIView *reserveV;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconPeoples;
@property (weak, nonatomic) IBOutlet UILabel *reservePeopleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconLiveAddress;
@property (weak, nonatomic) IBOutlet UILabel *liveAddressL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIButton *livingBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *intrL;
- (IBAction)btnOnClick:(id)sender;

@property (nonatomic) WVRFootballLiveCellInfo * cellInfo;

@end


@implementation WVRFootballLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.font = kFontFitForSize(13.f);
    self.intrL.font = kFontFitForSize(11.f);
    self.reserveV.layer.masksToBounds = YES;
    self.reserveV.layer.cornerRadius = fitToWidth(4.f);
    self.reserveV.layer.borderWidth = 1.0f;
    self.reserveV.layer.borderColor = k_Color1.CGColor;
    self.livingBtn.layer.masksToBounds = YES;
    self.livingBtn.layer.cornerRadius = fitToWidth(3.f);
    self.iconPeoples.image = [self.iconPeoples.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconPeoples.tintColor = [UIColor whiteColor];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRFootballLiveCellInfo *)info;
    self.title.text = self.cellInfo.itemModel.name;
    [self.iconImageV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    
    self.reserveV.hidden = YES;
    self.livingBtn.hidden = YES;
    self.iconPeoples.hidden = YES;
    self.reservePeopleL.hidden = YES;
    self.iconLiveAddress.hidden = YES;
    self.liveAddressL.hidden = YES;
    self.intrL.hidden = YES;
    if ([self.cellInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_FOOTBALLRECOMMENDPAGE]) {
        self.intrL.text = self.cellInfo.itemModel.intrDesc;
        
        return;
    }else if ([self.cellInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_FOOTBALLHOMEPAGE]) {
        self.intrL.text = self.cellInfo.itemModel.intrDesc;
        return;
    }
    if(self.cellInfo.itemModel.linkType_ != WVRLinkTypeLive)
    {
        return;
    }else{
        self.intrL.text = self.cellInfo.itemModel.intrDesc;
    }
    NSString *orderPeople = [WVRComputeTool numberToString:[self.cellInfo.itemModel.liveOrderCount integerValue]];
    NSString * startTime = [SQDateTool year_month_day_hour_minute_nian_liveStart:[self.cellInfo.itemModel.startDateFormat doubleValue]];
    NSString * notStartIntrStr = [NSString stringWithFormat:@"%@ | %@人已预约",startTime,orderPeople];
    NSString* playCountStr = [WVRComputeTool numberToString:[self.cellInfo.itemModel.playCount integerValue]];
    NSString * playingIntStr = [NSString stringWithFormat:@"%@人正在观看 立即前往>",playCountStr];
    if (self.cellInfo.itemModel.liveStatus == WVRLiveStatusNotStart) {
        self.reserveV.hidden = NO;
        self.intrL.text = notStartIntrStr;
        self.livingBtn.hidden = YES;
        [self.livingBtn setTitle:@"未开赛" forState:UIControlStateNormal];
        [self.livingBtn setBackgroundColor:[UIColor grayColor]];
    }else if (self.cellInfo.itemModel.liveStatus == WVRLiveStatusPlaying) {
        self.livingBtn.hidden = NO;
        [self.livingBtn setTitle:@"直播中" forState:UIControlStateNormal];
        [self.livingBtn setBackgroundColor:[UIColor colorWithHex:0x0CE88C]];
        self.intrL.text = playingIntStr;
    }else if (self.cellInfo.itemModel.liveStatus == WVRLiveStatusEnd) {
        self.livingBtn.hidden = NO;
        [self.livingBtn setTitle:@"已完赛" forState:UIControlStateNormal];
        [self.livingBtn setBackgroundColor:[UIColor grayColor]];
        self.intrL.text = playingIntStr;
    }
}

- (IBAction)btnOnClick:(id)sender {
    kWeakSelf(self);
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(weakself.cellInfo);
    }
}

@end


@implementation WVRFootballLiveCellInfo

@end

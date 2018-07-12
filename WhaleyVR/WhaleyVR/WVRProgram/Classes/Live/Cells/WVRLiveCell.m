//
//  WVRLiveCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveCell.h"
#import "WVRLiveItemModel.h"
#import "SQDateTool.h"

@interface WVRLiveCell ()

@property (weak, nonatomic) IBOutlet UIView *reserveV;
@property (weak, nonatomic) IBOutlet UILabel *reserveConutL;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconPeoples;
@property (weak, nonatomic) IBOutlet UILabel *reservePeopleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconLiveAddress;
@property (weak, nonatomic) IBOutlet UILabel *liveAddressL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIButton *livingBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *intrL;

@property (nonatomic) WVRLiveCellInfo * cellInfo;

- (IBAction)btnOnClick:(id)sender;

@end


@implementation WVRLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.font = kFontFitForSize(13);
    self.intrL.font = kFontFitForSize(11);
    self.reserveV.layer.masksToBounds = YES;
    self.reserveV.layer.cornerRadius = fitToWidth(4);
    self.reserveV.layer.borderWidth = 1;
    self.reserveV.layer.borderColor = k_Color1.CGColor;
    self.livingBtn.layer.masksToBounds = YES;
    self.livingBtn.layer.cornerRadius = fitToWidth(3);
    self.iconPeoples.image = [self.iconPeoples.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconPeoples.tintColor = [UIColor whiteColor];
}

- (void)setupConstraints {
    
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRLiveCellInfo *)info;
    self.title.text = self.cellInfo.itemModel.name;
//    self.intrL.text = self.cellInfo.itemModel.subTitle;
    
//    if (self.iconImageV.width != self.cellInfo.cellSize.width) {
//        self.iconImageV.width = self.cellInfo.cellSize.width;
//    }
//    if (self.iconImageV.height != (self.cellInfo.cellSize.height-fitToWidth(50.0f))) {
//        self.iconImageV.height = self.cellInfo.cellSize.height-fitToWidth(50.0f);
//    }
    [self.iconImageV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    NSString *orderPeople = [WVRComputeTool numberToString:[self.cellInfo.itemModel.liveOrderCount integerValue]];
    NSString * startTime = [SQDateTool year_month_day_hour_minute_nian_liveStart:[self.cellInfo.itemModel.startDateFormat doubleValue]];
    NSString * notStartIntrStr = [NSString stringWithFormat:@"%@ | %@人已预约", startTime, orderPeople];
//    self.reserveConutL.text = [NSString stringWithFormat:@"%@人\n已预约", orderPeople];
    NSString* playCountStr = [WVRComputeTool numberToString:[self.cellInfo.itemModel.playCount integerValue]];
//    self.reservePeopleL.text = [NSString stringWithFormat:@"%d人",playCount];
//    self.liveAddressL.text = self.cellInfo.itemModel.address;
    
    self.livingBtn.hidden = YES;
    self.iconPeoples.hidden = YES;
    self.reservePeopleL.hidden = YES;
    self.iconLiveAddress.hidden = YES;
    self.liveAddressL.hidden = YES;
    self.reserveV.hidden = YES;
    
    if (self.cellInfo.itemModel.liveStatus == WVRLiveStatusNotStart) {
        self.reserveV.hidden = NO;
        self.intrL.text = notStartIntrStr;
//        self.liveAddressL.hidden = NO;
//        self.iconLiveAddress.hidden = self.cellInfo.itemModel.address.length > 0 ? NO : YES;
        
    } else if (self.cellInfo.itemModel.liveStatus == WVRLiveStatusPlaying) {
        
        self.livingBtn.hidden = NO;
        NSString * playingIntStr = [NSString stringWithFormat:@"%@人正在观看 立即前往>", playCountStr];
        self.intrL.text = playingIntStr;
//        self.liveAddressL.hidden = NO;
//        self.iconLiveAddress.hidden = self.cellInfo.itemModel.address.length > 0 ? NO : YES;
//        self.iconPeoples.hidden = NO;
//        self.reservePeopleL.hidden = NO;
    } else {
        self.intrL.text = @"直播已结束";
    }
}

- (IBAction)btnOnClick:(id)sender {
    kWeakSelf(self);
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(weakself.cellInfo);
    }
}

@end


@implementation WVRLiveCellInfo

@end

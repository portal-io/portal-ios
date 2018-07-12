//
//  WVRFootballLiveCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballRecordCell.h"
#import "WVRFootballModel.h"
#import "SQDateTool.h"

@interface WVRFootballRecordCell ()


@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconPeoples;
@property (weak, nonatomic) IBOutlet UILabel *reservePeopleL;
@property (weak, nonatomic) IBOutlet UIImageView *iconLiveAddress;
@property (weak, nonatomic) IBOutlet UILabel *liveAddressL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *intrL;
- (IBAction)btnOnClick:(id)sender;

@property (nonatomic) WVRFootballRecordCellInfo * cellInfo;

@end


@implementation WVRFootballRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.font = kFontFitForSize(13.f);
    self.intrL.font = kFontFitForSize(11.f);
    
    self.iconPeoples.image = [self.iconPeoples.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconPeoples.tintColor = [UIColor whiteColor];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRFootballRecordCellInfo *)info;
    self.title.text = self.cellInfo.itemModel.name;
    [self.iconImageV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
//    NSString *orderPeople = [WVRComputeTool numberToString:[self.cellInfo.itemModel.liveOrderCount integerValue]];
    NSString * startTime = [SQDateTool currentDurationString:[self.cellInfo.itemModel.duration doubleValue]];
    NSString* playCountStr = [WVRComputeTool numberToString:[self.cellInfo.itemModel.playCount integerValue]];
    NSString * subIntrStr = [NSString stringWithFormat:@"%@ | %@人播放", startTime, playCountStr];
    
//    NSString * playingIntStr = [NSString stringWithFormat:@"%@人正在观看 立即前往>",playCountStr];
    self.iconPeoples.hidden = YES;
    self.reservePeopleL.hidden = YES;
    self.iconLiveAddress.hidden = YES;
    self.liveAddressL.hidden = YES;
    self.intrL.text = subIntrStr;
}

- (IBAction)btnOnClick:(id)sender {
    kWeakSelf(self);
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(weakself.cellInfo);
    }
}

@end


@implementation WVRFootballRecordCellInfo

@end

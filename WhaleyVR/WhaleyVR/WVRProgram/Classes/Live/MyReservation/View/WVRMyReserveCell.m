//
//  WVRMyReserveCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyReserveCell.h"
#import "WVRLiveItemModel.h"
#import "SQDateTool.h"

@interface WVRMyReserveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UILabel *flagL;
@property (weak, nonatomic) IBOutlet UIView *topV;

@property (nonatomic) WVRMyReserveCellInfo * cellInfo;
@end


@implementation WVRMyReserveCell

- (void)fillData:(SQBaseTableViewInfo *)info {
    
    self.cellInfo = (WVRMyReserveCellInfo *)info;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = self.cellInfo.itemModel.name;
    if ([self.cellInfo.itemModel.packageItemCharged boolValue]) {
        self.flagL.hidden = NO;
    } else {
        self.flagL.hidden = YES;
    }
    [self checkLiveStatus];
}

-(void)checkLiveStatus
{
//    self.topV.hidden = YES;
    self.contentView.alpha = 1.0;
    switch (self.cellInfo.itemModel.liveStatus) {
        case WVRLiveStatusNotStart:
            [self showTextForTime];
            self.titleL.textColor = k_Color3;
            self.subTitleL.textColor = k_Color15;
            break;
        case WVRLiveStatusPlaying:
            self.subTitleL.text = @"正在直播";
            self.titleL.textColor = k_Color3;
            self.subTitleL.textColor = k_Color15;
            break;
        case WVRLiveStatusEnd:
//            self.topV.hidden = NO;
            self.contentView.alpha = 0.4;
            self.titleL.textColor = k_Color7;
            self.subTitleL.textColor = k_Color7;
            self.subTitleL.text = @"直播已结束";
            break;
        default:
            break;
    }
}

-(void)showTextForTime
{
   
    if ([SQDateTool sysTimeSec]*1000>=[self.cellInfo.itemModel.startDateFormat doubleValue]) {
        self.subTitleL.text = @"即将开播";
    }else{
        [self formatTimeStr];
    }
}
    
-(void)formatTimeStr
{
    int hours =  [SQDateTool getHourNumFromNowWithEndTime:self.cellInfo.itemModel.startDateFormat];
    if (hours<=24) {
        //        NSString * timeStr = [SQDateTool hour_minute_second:[self.cellInfo.itemModel.startDateFormat doubleValue]];
        if (hours==0) {
            int minute =  [SQDateTool getMinuteNumFromNowWithEndTime:self.cellInfo.itemModel.startDateFormat];
            if (minute == 0) {
                int sec = [SQDateTool getSecondNumFromNowWithEndTime:self.cellInfo.itemModel.startDateFormat];
                self.subTitleL.text = [NSString stringWithFormat:@"距开始还有%d秒",sec];
            }else{
                self.subTitleL.text = [NSString stringWithFormat:@"距开始还有%d分钟",minute];
            }
        }else{
            self.subTitleL.text = [NSString stringWithFormat:@"距开始还有%d小时",hours];
        }
    }else{
        NSString * timeStr = [SQDateTool year_month_day_hour_minute_nian_liveStart:[self.cellInfo.itemModel.startDateFormat doubleValue]];
        self.subTitleL.text = [NSString stringWithFormat:@"%@开播",timeStr];
    }
}
@end

@implementation WVRMyReserveCellInfo

@end

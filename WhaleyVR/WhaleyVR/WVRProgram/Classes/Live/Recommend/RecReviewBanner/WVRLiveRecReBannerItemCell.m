//
//  WVRLiveRecSubCCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecReBannerItemCell.h"
#import "WVRItemModel.h"
#import "SQDateTool.h"

@interface WVRLiveRecReBannerItemCell ()


@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (nonatomic) WVRLiveRecReBannerItemCellInfo* cellInfo;

@end
@implementation WVRLiveRecReBannerItemCell

-(void)awakeFromNib
{
    [super awakeFromNib];

}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRLiveRecReBannerItemCellInfo*)info;
    self.titleL.text = self.cellInfo.itemModel.name;
    NSString* playCountStr = [WVRComputeTool numberToString:[self.cellInfo.itemModel.playCount longLongValue]];
    NSInteger duration = [self.cellInfo.itemModel.duration longLongValue];
//    NSInteger second = [self.cellInfo.itemModel.duration longLongValue]%60;
    NSString * durationStr = [self numberToTime:duration];;//[NSString stringWithFormat:@"%ld分%ld秒",minute,second];
    NSString * notStartIntrStr = [NSString stringWithFormat:@"%@ | %@人播放",durationStr,playCountStr];
    self.subTitleL.text = notStartIntrStr;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
}

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d分%02d秒", (int)time/60, (int)time%60];
}

@end



@implementation WVRLiveRecReBannerItemCellInfo

@end

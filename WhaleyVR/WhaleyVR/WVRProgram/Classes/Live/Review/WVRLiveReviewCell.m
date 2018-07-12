//
//  WVRLiveReviewCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveReviewCell.h"
#import "WVRItemModel.h"
#import "SQDateTool.h"
#import "WVRComputeTool.h"

@interface WVRLiveReviewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *countL;


@end
@implementation WVRLiveReviewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleL.font = kFontFitForSize(17.0f);
    self.countL.font = kFontFitForSize(13.0f);
    
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    WVRLiveReviewCellInfo* cellInfo = (WVRLiveReviewCellInfo *)info;
    
    kWeakSelf(self);
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageDownloaderHandleCookies progress:nil completed:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
        if(error){
            NSString * str = cellInfo.itemModel.thubImageUrl;
            if ([cellInfo.itemModel.thubImageUrl containsString:@"/zoom"]) {
                str = [[cellInfo.itemModel.thubImageUrl componentsSeparatedByString:@"/zoom"] firstObject];
            }
            [weakself.iconIV wvr_setImageWithURL:[NSURL URLWithString:str] placeholderImage:HOLDER_IMAGE options:SDWebImageRetryFailed | SDWebImageLowPriority];
        }
    }];
    self.titleL.text = cellInfo.itemModel.name;
    self.countL.text = @"";
    if ([cellInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_MANUAL_ARRANGE]) {
        if ([cellInfo.itemModel.detailCount intValue]>0) {
            self.countL.text = [NSString stringWithFormat:@"共 %d个内容", [cellInfo.itemModel.detailCount intValue]];
        }
    }else if ([cellInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_CONTENT_PACKAGE]) {
        if ([cellInfo.itemModel.detailCount intValue]>0) {
            self.countL.text = [NSString stringWithFormat:@"共 %d个视频",[cellInfo.itemModel.detailCount intValue]];
        }
        
    }else{
        NSInteger duration = [cellInfo.itemModel.duration longLongValue];
        NSString * timeStr = [self numberToTime:duration];
        NSString *orderPeople = [WVRComputeTool numberToString:[cellInfo.itemModel.playCount longLongValue]];
        self.countL.text = [NSString stringWithFormat:@"%@ | %@人观看",timeStr? timeStr:@"",orderPeople];
    }
//    if ([cellInfo.itemModel.itemCount integerValue] <= 1) {
//     
//    }
    
}

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d分%02d秒", (int)time/60, (int)time%60];
}

-(void)didHighlight
{
    self.titleL.hidden = YES;
    self.countL.hidden = YES;
    self.topV.hidden = YES;
}

-(void)didUnhighlight
{
    self.titleL.hidden = NO;
    self.countL.hidden = NO;
    self.topV.hidden = NO;
}

@end

@implementation WVRLiveReviewCellInfo

@end

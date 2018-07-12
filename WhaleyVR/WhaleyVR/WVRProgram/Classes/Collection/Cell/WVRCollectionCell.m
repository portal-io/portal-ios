//
//  WVRCollectionCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionCell.h"
#import "SQDateTool.h"

@interface WVRCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *tvSubTitleL;
@property (weak, nonatomic) IBOutlet UIImageView *gDramaTag;


@end
@implementation WVRCollectionCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    WVRCollectionCellInfo * cellInfo = (WVRCollectionCellInfo*) info;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.collectionModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = cellInfo.collectionModel.programName;
//    NSString * playCountStr = cellInfo.collectionModel.playCount? cellInfo.collectionModel.playCount:@"0";
    NSString * durStr = [SQDateTool formatDurationString:[cellInfo.collectionModel.duration doubleValue]];
    if ([cellInfo.collectionModel.programType isEqualToString:PROGRAMTYPE_MORETV_TV]) {
        self.tvSubTitleL.text = @"电视剧";
    } else {
        self.tvSubTitleL.text = [NSString stringWithFormat:@"%@",durStr];
    }
    if ([cellInfo.collectionModel.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
        self.gDramaTag.hidden = NO;
    }else{
        self.gDramaTag.hidden = YES;
    }
}

@end
@implementation WVRCollectionCellInfo

@end

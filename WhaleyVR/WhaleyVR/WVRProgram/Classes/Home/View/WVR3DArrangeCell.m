//
//  WVRSQFindArrangeCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVR3DArrangeCell.h"

@interface WVR3DArrangeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;

@end


@implementation WVR3DArrangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleL.font = kFontFitForSize(13);
    self.subTitleL.font = kFontFitForSize(11);
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    WVR3DArrangeCellInfo * cellInfo = (WVR3DArrangeCellInfo *)info;
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.videoModel.thubImage] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = cellInfo.videoModel.name;
    self.subTitleL.text = cellInfo.videoModel.subTitle;
}

@end


@implementation WVR3DArrangeCellInfo

@end

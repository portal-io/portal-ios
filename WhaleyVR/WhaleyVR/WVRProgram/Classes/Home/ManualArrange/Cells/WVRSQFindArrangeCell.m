//
//  WVRSQFindArrangeCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQFindArrangeCell.h"

@interface WVRSQFindArrangeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end
@implementation WVRSQFindArrangeCell

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRSQFindArrangeCellInfo * cellInfo = (WVRSQFindArrangeCellInfo*)info;
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.videoModel.thubImage] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = cellInfo.videoModel.name;
}

@end
@implementation WVRSQFindArrangeCellInfo

@end

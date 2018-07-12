//
//  WVRSQADCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/16.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQADCell.h"
#import "WVRImageTool.h"

@interface WVRSQADCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property WVRSQADCellInfo * cellInfo;

@end


@implementation WVRSQADCell

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRSQADCellInfo * cellInfo = (WVRSQADCellInfo*)info;
    self.cellInfo = cellInfo;
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrl]] placeholderImage:HOLDER_IMAGE];
}

- (NSString *)parseImageUrl
{
    if (self.cellInfo.scaleThubImage) {
        
    } else {
        self.cellInfo.scaleThubImage = [WVRImageTool parseImageUrl:self.cellInfo.thubImageUrl scaleSize:self.thubImageV.size];
    }
    return self.cellInfo.scaleThubImage;
}

@end


@implementation WVRSQADCellInfo

@end

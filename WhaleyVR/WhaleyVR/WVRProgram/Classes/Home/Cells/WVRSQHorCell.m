//
//  WVRSQHorCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQHorCell.h"
#import "WVRImageTool.h"

@interface WVRSQHorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property WVRSQHorCellInfo *cellInfo;

@end


@implementation WVRSQHorCell

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRSQHorCellInfo*)info;
    [self.iconImageV wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrl]] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = self.cellInfo.name;
    self.titleL.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleL.layer.shadowOffset =CGSizeMake(1,1);
    self.titleL.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.titleL.layer.shadowRadius = 1;//阴影半径，默认3
}

-(NSString*)parseImageUrl
{
    if (self.cellInfo.scaleThubImage) {
        
    }else{
        self.cellInfo.scaleThubImage = [WVRImageTool parseImageUrl:self.cellInfo.thubImage scaleSize:self.iconImageV.size];
    }
    return self.cellInfo.scaleThubImage;
}
@end


@implementation WVRSQHorCellInfo

@end

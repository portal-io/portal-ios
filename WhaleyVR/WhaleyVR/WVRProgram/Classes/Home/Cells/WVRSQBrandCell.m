//
//  WVRSQBrandCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/16.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQBrandCell.h"
#import "WVRImageTool.h"

@interface WVRSQBrandCell ()
@property (weak, nonatomic) IBOutlet UILabel *numUnitL;
//@property (weak, nonatomic) IBOutlet UIImageView *littleIconIV;

@property (weak, nonatomic) IBOutlet UIImageView *thumIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *introL;

@property (nonatomic) WVRSQBrandCellInfo * cellInfo;

@end
@implementation WVRSQBrandCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.nameL.font = kFontFitForSize(13.0f);
    self.introL.font = kFontFitForSize(11.0f);
//    self.littleIconIV.layer.masksToBounds = YES;
//    self.littleIconIV.layer.cornerRadius = self.littleIconIV.height/2;
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRSQBrandCellInfo*)info;
    [self.thumIcon wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrl]] placeholderImage:HOLDER_IMAGE];
//    [self.littleIconIV wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrlWithSize:CGSizeMake(25, 25)]] placeholderImage:HOLDER_IMAGE];
    
    self.nameL.text = self.cellInfo.name;
    self.introL.text = self.cellInfo.subTitle;
    self.numUnitL.text = [NSString stringWithFormat:@"%@部",self.cellInfo.unitConut];
}

-(NSString*)parseImageUrlWithSize:(CGSize)size
{
    if (self.cellInfo.scaleLogoImageUrl) {
        
    }else{
//        self.cellInfo.scaleLogoImageUrl = [WVRImageTool parseImageUrl:self.cellInfo.logoImageUrl scaleSize:self.littleIconIV.size];
    }
    return self.cellInfo.scaleLogoImageUrl;
}


-(NSString*)parseImageUrl
{
    if (self.cellInfo.scaleThubImage) {
        
    }else{
        self.cellInfo.scaleThubImage = [WVRImageTool parseImageUrl:self.cellInfo.thubImage scaleSize:self.thumIcon.size];
    }
    return self.cellInfo.scaleThubImage;
}


@end
@implementation WVRSQBrandCellInfo

@end

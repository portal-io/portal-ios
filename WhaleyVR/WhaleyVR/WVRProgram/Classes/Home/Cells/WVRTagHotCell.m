//
//  WVRSQTagCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRTagHotCell.h"

@interface WVRTagHotCell ()
@property (weak, nonatomic) IBOutlet UILabel *tagL;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (nonatomic) WVRTagHotCellInfo * cellInfo;
@end
@implementation WVRTagHotCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tagL.font = kFontFitForSize(12.0f);
//    self.tagL.backgroundColor = Color_RGBA(0, 0, 0, 0.02);
//    self.tagL.layer.masksToBounds = YES;
//    self.tagL.layer.cornerRadius = self.tagL.height/2.0;
//    self.tagL.layer.borderWidth = 1.0f;
//    self.tagL.layer.borderColor = Color_RGBA(0, 0, 0, 0.2).CGColor;
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.tagL.layer.cornerRadius = self.tagL.height/2.0;
    self.cellInfo = (WVRTagHotCellInfo*)info;
    self.tagL.text = self.cellInfo.tagModel.name;
    
    NSString * str = self.cellInfo.tagModel.thubUrl;
    if ([str containsString:@"/zoom"]) {
        str = [[str componentsSeparatedByString:@"/zoom"] firstObject];
    }
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:str] placeholderImage:HOLDER_IMAGE];
}


@end
@implementation WVRTagHotCellInfo

@end

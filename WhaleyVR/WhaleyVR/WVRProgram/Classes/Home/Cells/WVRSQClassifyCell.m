//
//  WVRSQClassifyCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQClassifyCell.h"
#import "WVRImageTool.h"

@interface WVRSQClassifyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *introL;

@property (weak, nonatomic) IBOutlet UIImageView *gDramaTag;

@property (nonatomic) WVRSQClassifyCellInfo * cellInfo;

@end
@implementation WVRSQClassifyCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.nameL.font = kFontFitForSize(13.0f);
    self.introL.font = kFontFitForSize(11.0f);
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRSQClassifyCellInfo*)info;
    [self.thumIcon wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrl]] placeholderImage:HOLDER_IMAGE];
    self.nameL.text = [self.cellInfo.args name];
    self.introL.text = [self.cellInfo.args subTitle];
    if ([[self.cellInfo.args linkArrangeType] isEqualToString:LINKARRANGETYPE_DRAMA_PROGRAM]) {
        self.gDramaTag.hidden = NO;
    }else if ([[self.cellInfo.args programType] isEqualToString:PROGRAMTYPE_DRAMA]) {
        self.gDramaTag.hidden = NO;
    }else{
        self.gDramaTag.hidden = YES;
    }
    
}

-(NSString*)parseImageUrl
{
    if ([self.cellInfo.args scaleThubImage]) {
        
    }else{
        ((WVRItemModel*)self.cellInfo.args).scaleThubImage = [WVRImageTool parseImageUrl:((WVRItemModel*)self.cellInfo.args).thubImageUrl scaleSize:self.thumIcon.size];
    }
    return [self.cellInfo.args scaleThubImage];
}

@end
@implementation WVRSQClassifyCellInfo

@end

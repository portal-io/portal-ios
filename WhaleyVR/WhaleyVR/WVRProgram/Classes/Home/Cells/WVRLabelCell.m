//
//  WVRLabelCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLabelCell.h"
#import "WVRItemModel.h"
#import "WVRLabel.h"
#import "WVRWidgetColorHeader.h"

@interface WVRLabelCell ()

@property (weak, nonatomic) IBOutlet WVRLabel *labelL;

@end


@implementation WVRLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelL.textInsets = UIEdgeInsetsMake(0, fitToWidth(7.f), 0, fitToWidth(7.f));
    self.labelL.layer.masksToBounds = YES;
    self.labelL.layer.cornerRadius = self.labelL.height/2;
    self.labelL.textColor = k_Color4;
    self.labelL.backgroundColor = UIColorFromRGBA(0x000000,0.02);
    self.labelL.font = [UIFont systemFontOfSize:fitToWidth(15.f)];
    self.labelL.layer.borderWidth = 1.0f;
    self.labelL.layer.borderColor = UIColorFromRGBA(0x000000,0.05).CGColor;
}

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRLabelCellInfo * cellInfo = (WVRLabelCellInfo*)info;
    self.labelL.text = cellInfo.itemModel.name;
}

@end

@implementation WVRLabelCellInfo

@end

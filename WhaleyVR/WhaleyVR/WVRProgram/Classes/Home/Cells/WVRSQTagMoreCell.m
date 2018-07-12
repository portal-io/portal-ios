//
//  WVRSQTagMoreCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQTagMoreCell.h"
#import "WVRWidgetColorHeader.h"

@interface WVRSQTagMoreCell ()

@property (nonatomic) WVRSQTagMoreCellInfo * cellInfo;
@property (weak, nonatomic) IBOutlet UILabel *tagL;

@end


@implementation WVRSQTagMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tagL.backgroundColor = UIColorFromRGBA(0x1e9ef4,0.05);
    
    self.tagL.layer.masksToBounds = YES;
    self.tagL.layer.cornerRadius = self.tagL.height/2;
    self.tagL.layer.borderWidth = 1.0f;
    self.tagL.layer.borderColor = UIColorFromRGBA(0x1e9ef4,0.5).CGColor;
    self.tagL.textColor = UIColorFromRGBA(0x1e9ef4,0.5);
}

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRSQTagMoreCellInfo*)info;
    self.tagL.text = self.cellInfo.tagModel.name;
}

@end


@implementation WVRSQTagMoreCellInfo

@end

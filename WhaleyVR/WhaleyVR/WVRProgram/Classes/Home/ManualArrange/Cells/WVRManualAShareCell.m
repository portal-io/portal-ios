//
//  WVRManualAShareCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRManualAShareCell.h"

@interface WVRManualAShareCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagL;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) WVRManualAShareCellInfo * cellInfo;

@end


@implementation WVRManualAShareCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tagL.font = kFontFitForSize(12.0f);
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.tagL.layer.cornerRadius = self.tagL.height/2.0;
    self.cellInfo = (WVRManualAShareCellInfo*)info;
    self.tagL.text = self.cellInfo.title;
    
    [self.iconIV setImage:[UIImage imageNamed:self.cellInfo.localImageStr]];
}

//- (void)dealloc {
//    
//    DDLogInfo(@"");
//}

@end


@implementation WVRManualAShareCellInfo

@end

//
//  WVRLiveCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveEndCell.h"
#import "WVRLiveItemModel.h"
#import "WVRLiveCell.h"

@interface WVRLiveEndCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *intrL;
- (IBAction)btnOnClick:(id)sender;

@property (nonatomic) WVRLiveCellInfo * cellInfo;
@end


@implementation WVRLiveEndCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.font = kFontFitForSize(13.f);
    self.intrL.font = kFontFitForSize(11.f);
}

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRLiveCellInfo *)info;
    self.title.text = self.cellInfo.itemModel.name;
    self.intrL.text = self.cellInfo.itemModel.subTitle;
    [self.iconImageV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    
}

- (IBAction)btnOnClick:(id)sender {
    kWeakSelf(self);
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(weakself.cellInfo);
    }
}

@end


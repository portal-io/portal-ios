//
//  WVRLiveRBannerCCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRBannerCCell.h"
#import "WVRItemModel.h"

@interface WVRLiveRBannerCCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (nonatomic) NSLayoutConstraint * originTopC;
@property (nonatomic) NSLayoutConstraint * originHC;
@property (nonatomic) CGFloat originTop;
@property (nonatomic) CGFloat originH;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@end
@implementation WVRLiveRBannerCCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray * superCons = self.contentView.constraints;
    for (NSLayoutConstraint * cur in superCons) {
        if (cur.firstItem == self.iconIV) {
            self.originTop = cur.constant;
            self.originTopC = cur;
        }
    }
    NSArray* constraints = self.iconIV.constraints;
    for (NSLayoutConstraint * cur in constraints) {
        if (cur.firstAttribute == NSLayoutAttributeTopMargin) {
            
        }else if (cur.firstAttribute == NSLayoutAttributeHeight){
            self.originH = cur.constant;
            self.originHC = cur;
        }
    }
}

- (void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRLiveRBannerCCellInfo * cellInfo = (WVRLiveRBannerCCellInfo*)info;
    self.titleL.text = [NSString stringWithFormat:@"%ld",(long)cellInfo.cellIndex];
//    if(info.cellIndex % 2 == 0)
//    {
//        self.backgroundColor = [UIColor redColor];
//    }else{
//        self.backgroundColor = [UIColor blueColor];
//    }
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
}

- (void)updateAnimalBig
{
    self.originTopC.constant = self.originTop-20;
    self.originHC.constant = self.originH+40;
}

- (void)updateAnimalSmall
{
    self.originTopC.constant = self.originTop;
    self.originHC.constant = self.originH;
    
}

@end


@implementation WVRLiveRBannerCCellInfo

@end

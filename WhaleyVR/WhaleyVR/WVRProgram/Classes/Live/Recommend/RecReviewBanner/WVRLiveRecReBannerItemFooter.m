//
//  WVRLiveRecSubCMoreCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecReBannerItemFooter.h"

@interface WVRLiveRecReBannerItemFooter ()

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

- (IBAction)moreBtnOnClick:(id)sender;

@property (nonatomic) SQCollectionViewFooterInfo * cellInfo;

@end
@implementation WVRLiveRecReBannerItemFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.moreBtn.layer.borderWidth = fitToWidth(2.0f);
    self.moreBtn.layer.borderColor = k_Color10.CGColor;
}

-(void)fillData:(SQCollectionViewFooterInfo *)info
{
    self.cellInfo = info;
}

- (IBAction)moreBtnOnClick:(id)sender {
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(self.cellInfo);
    }
}
@end

//
//  WVRSQMoreReusableFooter.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQMore2ReusableFooter.h"
#import "UIButton+Extends.h"

@interface WVRSQMore2ReusableFooter ()

@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

- (IBAction)refreshOnClick:(id)sender;
@property (nonatomic) WVRSQMore2ReusableFooterInfo * footerInfo;

@end


@implementation WVRSQMore2ReusableFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.refreshBtn rightImageLeftTitle:6.f];
//    [self updateButtonEdgeInsets:self.refreshBtn];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.footerInfo = (WVRSQMore2ReusableFooterInfo*)info;
    self.titleL.text = self.footerInfo.btnTitle;
    self.titleIcon.image = [UIImage imageNamed:self.footerInfo.btnIcon];
}


- (IBAction)goToOnClick:(id)sender {
    if (self.footerInfo.sectionModel.subTitle.length>0) {
        if (self.footerInfo.gotoBlock) {
            self.footerInfo.gotoBlock(self.footerInfo);
        }
    }
}

- (IBAction)refreshOnClick:(id)sender {
    if (self.footerInfo.refreshBlock) {
        self.footerInfo.refreshBlock(self.footerInfo);
    }
}
@end


@implementation WVRSQMore2ReusableFooterInfo

@end

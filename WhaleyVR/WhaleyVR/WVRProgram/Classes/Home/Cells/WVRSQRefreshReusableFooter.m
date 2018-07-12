//
//  WVRSQMoreReusableFooter.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQRefreshReusableFooter.h"
#import "UIButton+Extends.h"

@interface WVRSQRefreshReusableFooter ()

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (nonatomic) WVRSQRefreshReusableFooterInfo * footerInfo;

- (IBAction)refreshOnClick:(id)sender;

@end


@implementation WVRSQRefreshReusableFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.refreshBtn rightImageLeftTitle:6.f];
//    [self updateButtonEdgeInsets:self.refreshBtn];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.footerInfo = (WVRSQRefreshReusableFooterInfo *)info;
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

@implementation WVRSQRefreshReusableFooterInfo

@end

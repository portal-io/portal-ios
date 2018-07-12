//
//  WVRSQMoreReusableFooter.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQMoreReusableFooter.h"
#import "UIButton+Extends.h"

@interface WVRSQMoreReusableFooter ()

@property (weak, nonatomic) IBOutlet UIButton *gotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

- (IBAction)goToOnClick:(id)sender;
- (IBAction)refreshOnClick:(id)sender;
@property (nonatomic) WVRSQMoreReusableFooterInfo * footerInfo;

@end


@implementation WVRSQMoreReusableFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.refreshBtn rightImageLeftTitle:6.f];
    [self.gotoBtn rightImageLeftTitle:6.f];
    
//    [self updateButtonEdgeInsets:self.gotoBtn];
//    [self updateButtonEdgeInsets:self.refreshBtn];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.footerInfo = (WVRSQMoreReusableFooterInfo*)info;
    [self parseType];
}

- (void)parseType {
    
//    if (self.footerInfo.type == WVRSQMoreReusableFooterTypeDefault) {
//        [self.gotoBtn setTitle:@"进入频道" forState:UIControlStateNormal];
//        [self.refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
//    }
}

- (IBAction)goToOnClick:(id)sender {
    if (self.footerInfo.gotoBlock) {
        self.footerInfo.gotoBlock(self.footerInfo);
    }
}

- (IBAction)refreshOnClick:(id)sender {
    if (self.footerInfo.refreshBlock) {
        self.footerInfo.refreshBlock(self.footerInfo);
    }
}

@end


@implementation WVRSQMoreReusableFooterInfo

@end

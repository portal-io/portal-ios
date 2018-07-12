//
//  WVRCurrencyBalanceFootView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyBalanceFootView.h"

@interface WVRCurrencyBalanceFootView()
@property (weak, nonatomic) IBOutlet UIButton *wcDscrB;
- (IBAction)wcDescrBOnClick:(id)sender;

@property (nonatomic, weak) SQBaseTableViewInfo* gViewModel;

@end

@implementation WVRCurrencyBalanceFootView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.wcDscrB setTitleColor:k_Color6 forState:UIControlStateNormal];
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.gViewModel = info;
}

- (IBAction)wcDescrBOnClick:(id)sender {
    if (self.gViewModel.gotoNextBlock) {
        self.gViewModel.gotoNextBlock(self.gViewModel);
    }
}
@end

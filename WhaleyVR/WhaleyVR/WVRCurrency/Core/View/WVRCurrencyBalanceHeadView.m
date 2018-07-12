//
//  WVRCurrencyBalanceHeadView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyBalanceHeadView.h"

@interface WVRCurrencyBalanceHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@property (nonatomic , strong) id args;
@end

@implementation WVRCurrencyBalanceHeadView

-(void)fillData:(SQBaseTableViewInfo *)info
{
    if (self.args == info) {
        return;
    }
    [self installRAC];
}

-(void)installRAC
{
    @weakify(self);
    [RACObserve([WVRUserModel sharedInstance], wcBalance) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.balanceL.text = [NSString stringWithFormat:@"%ld",(long)[WVRUserModel sharedInstance].wcBalance];
    }];
}
@end

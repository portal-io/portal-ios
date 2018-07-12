//
//  WVRCurrencyDetailTitleCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyDetailTitleCell.h"
#import "WVRCurrencyDetailTitleViewModel.h"

@interface WVRCurrencyDetailTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (nonatomic, weak) WVRCurrencyDetailTitleViewModel * gViewModel;

@end

@implementation WVRCurrencyDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleL.textColor = k_Color6;
    self.backgroundColor = [UIColor clearColor];
}

- (void)fillData:(SQBaseTableViewInfo *)info
{
    self.gViewModel = (WVRCurrencyDetailTitleViewModel *)info;
    NSInteger totalNum = self.gViewModel.totalNum;
    NSInteger whaleyCurrencyAmount = self.gViewModel.whaleyCurrencyAmount;
    NSInteger priceAmount = self.gViewModel.priceAmount;
    NSString * cur = [NSString stringWithFormat:@"总计充值%ld次，获得%ld鲸币，共价值%@元", totalNum, whaleyCurrencyAmount, [self amountToPrice:(int)priceAmount]];
    self.titleL.text = cur;
}

- (NSString *)amountToPrice:(int)amount {
    
    int price = amount;
    if (price % 100 == 0) {
        
        return [NSString stringWithFormat:@"%d", price/100];
        
    } else if (price % 10 == 0) {
        
        return [NSString stringWithFormat:@"%.1f", price/100.f];
    }
    
    return [NSString stringWithFormat:@"%.2f", price/100.f];
}

@end

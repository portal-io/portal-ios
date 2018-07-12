//
//  WVRCurrencyDetailItemCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyDetailItemCell.h"
#import "WVRCurrencyDetailItemViewModel.h"
#import "WVRCurrencyOrderListModel.h"
#import "SQDateTool.h"

@interface WVRCurrencyDetailItemCell()

@property (nonatomic, weak) WVRCurrencyDetailItemViewModel * gViewModel;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *payMethodL;
@property (weak, nonatomic) IBOutlet UILabel *payPriceL;
//@property (weak, nonatomic) IBOutlet UILabel *orderDateL;
@property (weak, nonatomic) IBOutlet UILabel *orderDateHourL;

@end

@implementation WVRCurrencyDetailItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleL.textColor = k_Color3;
    self.payMethodL.textColor = k_Color8;
    self.payPriceL.textColor = k_Color3;
//    self.orderDateL.textColor = k_Color8;
    self.orderDateHourL.textColor = k_Color8;
}

- (void)fillData:(SQBaseTableViewInfo *)info
{
    self.gViewModel = (WVRCurrencyDetailItemViewModel*)info;
    WVRCurrencyOrderListItem * item = self.gViewModel.orderItem;
    self.titleL.text = item.merchandiseName;
    [self parserPayMethod];
    self.payPriceL.text = [self amountToPrice:item.amount];
//    self.orderDateL.text = [SQDateTool year_month_day:item.updateTime withFormatStr:@"YYYY.MM.dd"];
    self.orderDateHourL.text = [[SQDateTool year_month_day_hour_minute:item.updateTime] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

- (NSString *)amountToPrice:(NSString *)amount {
    
    int price = amount.intValue;
    if (price % 100 == 0) {
        
        return [NSString stringWithFormat:@"¥%d", price/100];
        
    } else if (price % 10 == 0) {
        
        return [NSString stringWithFormat:@"¥%.1f", price/100.f];
    }
    
    return [NSString stringWithFormat:@"¥%.2f", price/100.f];
}

- (void)parserPayMethod {
    
    // （weixin：微信支付；alipay：支付宝；appStore：内购支付；鲸币支付：whaleyCurrency）
    WVRCurrencyOrderListItem * item = self.gViewModel.orderItem;
    
    if ([item.platform isEqualToString:@"alipay"]) {
        self.payMethodL.text = @"支付宝支付";
    } else if ([item.platform isEqualToString:@"weixin"]) {
        self.payMethodL.text = @"微信支付";
    } else if ([item.platform isEqualToString:@"appStore"]) {
        self.payMethodL.text = @"内购支付";
    } else if ([item.platform isEqualToString:@"whaleyCurrency"]) {
        self.payMethodL.text = @"鲸币支付";
    } else {
        DDLogError(@"error：未识别的支付方式，%@", item.platform);
        self.payMethodL.text = @"";
    }
}

@end

//
//  WVRCurrencyFaceValueCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyFaceValueCell.h"
#import "WVRCurrencyBuyConfigListModel.h"
#import "WVRCurrencyFaceValueCellViewModel.h"

@interface WVRCurrencyFaceValueCell ()

@property (nonatomic, weak) WVRCurrencyFaceValueCellViewModel * gViewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagWidthCons;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *prePriceL;
@property (weak, nonatomic) IBOutlet UILabel *GiveCurrencyL;
@property (weak, nonatomic) IBOutlet UILabel *realtimeTagL;
@property (weak, nonatomic) IBOutlet UIView *preLineV;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnOnClick:(id)sender;

@end

@implementation WVRCurrencyFaceValueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.payBtn setTitleColor:k_Color1 forState:UIControlStateNormal];
    self.payBtn.layer.borderColor = k_Color1.CGColor;
    //设置边框宽度
    self.payBtn.layer.borderWidth = 1.0f;
    //给按钮设置角的弧度
    self.payBtn.layer.cornerRadius = 5.0f;
    self.payBtn.layer.masksToBounds = YES;

    self.titleL.textColor = k_Color3;
    self.priceL.textColor = k_Color20;
    self.prePriceL.textColor = k_Color20;
    self.GiveCurrencyL.textColor = k_Color20;
    self.preLineV.backgroundColor = k_Color20;
    self.realtimeTagL.layer.masksToBounds = YES;
    self.realtimeTagL.layer.cornerRadius = 2.f;
    self.realtimeTagL.backgroundColor = [UIColor colorWithHex:0xFF3E3E alpha:0.7];
}

-(void)fillData:(WVRCurrencyFaceValueCellViewModel *)info
{
    self.gViewModel = (WVRCurrencyFaceValueCellViewModel*)info;
    WVRCurrencyBuyConfigItemModel * itemModel = info.configModel;
    self.titleL.text = [NSString stringWithFormat:@"%d鲸币",(int)itemModel.whaleyCurrencyNumber];
    self.priceL.text = [NSString stringWithFormat:@"%0.2f元",(float)itemModel.price/100.0];
    if (itemModel.preferPrice>0) {
        self.prePriceL.text = [NSString stringWithFormat:@"%0.2f元",(float)itemModel.preferPrice/100.0];
        self.realtimeTagL.hidden = NO;
        self.realtimeTagL.text = @"限时特惠";
        self.tagWidthCons.constant = fitToWidth(45.f);
        self.preLineV.hidden = NO;
    }else{
        self.prePriceL.text = @"";
        self.realtimeTagL.hidden = YES;
        self.realtimeTagL.text = @"";
        self.tagWidthCons.constant = 0;
        self.preLineV.hidden = YES;
    }
    if(itemModel.whaleyCurrencyGiveNumber>0){
        self.GiveCurrencyL.text = [NSString stringWithFormat:@"(赠送%d鲸币)",(int)itemModel.whaleyCurrencyGiveNumber];
        self.GiveCurrencyL.hidden = NO;
    }else{
        self.GiveCurrencyL.hidden = YES;
    }
}

- (IBAction)payBtnOnClick:(id)sender {
    if (self.gViewModel.gotoNextBlock) {
        self.gViewModel.gotoNextBlock(self.gViewModel);
    }
}
@end

//
//  WVRLiveReserveCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveReserveCell.h"
#import "SQDateTool.h"

@interface WVRLiveReserveCell ()


@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;
- (IBAction)reserveBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *intrL;
@property (nonatomic) WVRLiveReserveCellInfo * cellInfo;

@end


@implementation WVRLiveReserveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.reserveBtn.layer.masksToBounds = YES;
    self.reserveBtn.layer.cornerRadius = fitToWidth(4.f);
    self.reserveBtn.layer.borderWidth = 1.0f;
    self.reserveBtn.layer.borderColor = k_Color1.CGColor;
    [self.reserveBtn setTitleColor:k_Color1 forState:UIControlStateNormal];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRLiveReserveCellInfo*)info;
    self.titleL.text = self.cellInfo.itemModel.name;
    NSString *orderPeople = [WVRComputeTool numberToString:[self.cellInfo.itemModel.liveOrderCount integerValue]];
    NSString *orderPStr = [orderPeople stringByAppendingString:@"人已预约"];
    NSString * startStr = [SQDateTool year_month_day_hour_minute_nian_liveStart:[self.cellInfo.itemModel.beginTime doubleValue]];
    self.intrL.text = [NSString stringWithFormat:@"%@ | %@", startStr, orderPStr];
    [self.iconV wvr_setImageWithURL:[NSURL URLWithString:(self.cellInfo.itemModel.thubImageUrl ?: @"")] placeholderImage:HOLDER_IMAGE];
    self.reserveBtn.userInteractionEnabled = YES;
    @weakify(self);
    [RACObserve(self.cellInfo.itemModel, hasOrder) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([self.cellInfo.itemModel.hasOrder boolValue]) {
            [self.reserveBtn setTitle:@"已预约" forState:UIControlStateNormal];
            self.reserveBtn.alpha = 0.5;
        } else {
            [self.reserveBtn setTitle:@"立即预约" forState:UIControlStateNormal];
            self.reserveBtn.alpha = 1;
        }
    }];
}

- (IBAction)reserveBtnOnClick:(id)sender {
    if (self.cellInfo.reserveBlock) {
        self.cellInfo.reserveBlock(sender);
    }
}

@end
@implementation WVRLiveReserveCellInfo

@end

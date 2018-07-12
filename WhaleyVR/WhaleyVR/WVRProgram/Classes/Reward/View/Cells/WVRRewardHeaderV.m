//
//  WVRRewardHeaderV.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRRewardHeaderV.h"
#import "WVRWidgetColorHeader.h"

@interface WVRRewardHeaderV ()

@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

- (IBAction)changeBtnOnClick:(id)sender;

@property (nonatomic) WVRRewardHeaderVInfo * vInfo;

@end


@implementation WVRRewardHeaderV

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.changeBtn.layer.masksToBounds = YES;
    self.changeBtn.layer.cornerRadius = fitToWidth(2.5f);
    self.changeBtn.layer.borderWidth = 1.0f;
    self.changeBtn.layer.borderColor = UIColorFromRGB(0x29a1f7).CGColor;
    [self.changeBtn setTitleColor:UIColorFromRGB(0x29a1f7) forState:UIControlStateNormal];
}

- (void)fillData:(WVRRewardHeaderVInfo*)info{
    self.vInfo = info;
    self.addressL.text = info.address;
    [self.changeBtn setTitle:info.operateTitle forState:UIControlStateNormal];
}

- (IBAction)changeBtnOnClick:(id)sender {
    if (self.vInfo.changeBlock) {
        self.vInfo.changeBlock();
    }
}

@end


@implementation WVRRewardHeaderVInfo

@end

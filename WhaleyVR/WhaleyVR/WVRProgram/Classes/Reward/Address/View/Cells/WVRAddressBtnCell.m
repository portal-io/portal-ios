//
//  WVRAddressBtnCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAddressBtnCell.h"

@interface WVRAddressBtnCell ()

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic) WVRAddressBtnCellInfo *cellInfo;

- (IBAction)commitBtnOnClick:(id)sender;

@end


@implementation WVRAddressBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commitBtn.layer.cornerRadius = 2;
    self.commitBtn.layer.masksToBounds = YES;
}

- (void)fillData:(SQBaseTableViewInfo *)info {
    
    self.cellInfo = (WVRAddressBtnCellInfo *)info;
}

- (IBAction)commitBtnOnClick:(id)sender {
    if (self.cellInfo.commitBlock) {
        self.cellInfo.commitBlock();
    }
}

- (void)updateBtnStatus:(BOOL)enabel {
    
    if (enabel) {
        self.commitBtn.backgroundColor = Color_RGB(56, 178, 244);
    } else {
        self.commitBtn.backgroundColor = k_Color9;
    }
}

@end


@implementation WVRAddressBtnCellInfo

@end

//
//  WVRServerSegmentCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRServerSegmentCell.h"

@interface WVRServerSegmentCell ()

- (IBAction)segmentOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentV;
@property (nonatomic) WVRServerSegmentCellInfo * cellInfo;
//@property (nonatomic, copy) void(^onLineBlock)(void);
@end


@implementation WVRServerSegmentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    kWeakSelf(self);
//    __weak typeof(self) weakself = self;
//    __weak WVRServerSegmentCell weakself = self;
//     WVRServerSegmentCell* __weak weakSelf = self;
//    self.onLineBlock = ^{
//        weakself.cellInfo = nil;
//    };
}

- (void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRServerSegmentCellInfo *)info;
    self.textLabel.text = @"切换服务器";
    self.segmentV.selectedSegmentIndex = [WVRUserModel sharedInstance].isTest;
}

- (IBAction)segmentOnClick:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex==0) {
        if (self.cellInfo.onLineBlock) {
            self.cellInfo.onLineBlock();
        }
    }else{
        if (self.cellInfo.onTestBlock) {
            self.cellInfo.onTestBlock();
        }
    }
}
@end


@implementation WVRServerSegmentCellInfo

@end

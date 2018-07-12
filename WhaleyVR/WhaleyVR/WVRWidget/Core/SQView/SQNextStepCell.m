//
//  SQNextCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQNextStepCell.h"

@interface SQNextStepCell ()

@property (nonatomic) SQNextStepCellInfo * cellInfo;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
- (IBAction)nextStepOnClick:(id)sender;
@end
@implementation SQNextStepCell

-(void)fillData:(SQBaseTableViewInfo *)info
{
    __block SQNextStepCell * blockSelf = self;
    self.cellInfo = (SQNextStepCellInfo*)info;
    [self.nextStepBtn setTitle:self.cellInfo.title forState:UIControlStateNormal];
    self.cellInfo.updateBtnStatus = ^(BOOL canNextStep){
        blockSelf.nextStepBtn.enabled = canNextStep;
        blockSelf.nextStepBtn.selected = !canNextStep;
    };
}

- (IBAction)nextStepOnClick:(id)sender {
    if (self.cellInfo.nextSetpBlock) {
        self.cellInfo.nextSetpBlock();
    }
}
@end
@implementation SQNextStepCellInfo

-(CGFloat)cellHeight
{
    return 100;
}
@end


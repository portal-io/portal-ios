//
//  WVRLiveCalendarCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRTVDetailWorkCell.h"
#import "WVRWidgetColorHeader.h"
#import "UIButton+Extends.h"

@interface WVRTVDetailWorkCell ()

@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (nonatomic) WVRTVDetailWorkCellInfo * cellInfo;

- (IBAction)dayBtnOnClick:(id)sender;

@end


@implementation WVRTVDetailWorkCell

-(void)awakeFromNib
{
    [super awakeFromNib];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponse)];
//    self.userInteractionEnabled = YES;
//    [self addGestureRecognizer:tap];
//    self.dayBtn.layer.masksToBounds = YES;
//    self.dayBtn.layer.cornerRadius = self.dayBtn.height/2.0;
    [self.dayBtn setTitleColor:UIColorFromRGB(0x29a1f7) forState:UIControlStateSelected];
    [self.dayBtn setTitleColor:UIColorFromRGBA(0x666666, 1) forState:UIControlStateNormal];
    [self.dayBtn setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dayBtn setBackgroundImageWithColor:UIColorFromRGB(0xfafafa) forState:UIControlStateSelected];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRTVDetailWorkCellInfo*)info;
    [self.dayBtn setTitle:self.cellInfo.itemModel.curEpisode forState:UIControlStateNormal];
    self.dayBtn.selected = self.cellInfo.selected;
}

- (IBAction)dayBtnOnClick:(id)sender {
    if (self.cellInfo.didSelectBlock) {
        self.cellInfo.didSelectBlock();
    }
}

//-(void)tapResponse
//{
//    if (self.cellInfo.didSelectBlock) {
//        self.cellInfo.didSelectBlock();
//    }
//}
@end
@implementation WVRTVDetailWorkCellInfo

@end

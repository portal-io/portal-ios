//
//  WVRVirtualRewardCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/19.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRVirtualCardRewardCell.h"

@interface WVRVirtualCardRewardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (nonatomic) WVRVirtualCardRewardCellInfo * cellInfo;
- (IBAction)copyBtnOnClick:(id)sender;

@end
@implementation WVRVirtualCardRewardCell

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRVirtualCardRewardCellInfo*)info;
    self.titleL.text = [NSString stringWithFormat:@"%@我抽中了",self.cellInfo.rewardModel.formatDateStr];
    self.subTitleL.text = self.cellInfo.rewardModel.title;
    
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.rewardModel.thubImageStr] placeholderImage:HOLDER_IMAGE];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6.0f;
    NSString * string = self.cellInfo.rewardModel.rewardInfo;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attrString addAttribute:NSForegroundColorAttributeName   //文字颜色
//                       value:[UIColor blackColor]
//                       range:NSMakeRange(0, 3)];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
//    [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12.5f) range:NSMakeRange(0, string.length)];
    
    self.codeL.attributedText = attrString;
}

- (IBAction)copyBtnOnClick:(id)sender {
    if (self.cellInfo.copyBlock) {
        self.cellInfo.copyBlock();
    }
}
@end
@implementation WVRVirtualCardRewardCellInfo

@end

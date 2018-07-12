//
//  WVRTVIntrCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVIntrCell.h"

@interface WVRTVIntrCell()

@property (weak, nonatomic) IBOutlet UILabel *intrL;
@end
@implementation WVRTVIntrCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRTVIntrCellInfo * cellInfo = (WVRTVIntrCellInfo*)info;

    NSString *string = [NSString stringWithFormat:@"简介：%@",cellInfo.itemModel.intrDesc? :@""];
    if (!string) {
        string = @"";
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6.0f;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName   //文字颜色
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, 3)];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12.5f) range:NSMakeRange(0, string.length)];
    
    self.intrL.attributedText = attrString;
    

}

@end

@implementation WVRTVIntrCellInfo

@end

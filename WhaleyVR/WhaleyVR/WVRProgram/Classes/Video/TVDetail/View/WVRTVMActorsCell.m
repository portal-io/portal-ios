//
//  WVRTVMActorsCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVMActorsCell.h"

@interface WVRTVMActorsCell ()
@property (weak, nonatomic) IBOutlet UILabel *areaL;
@property (weak, nonatomic) IBOutlet UILabel *ageL;
@property (weak, nonatomic) IBOutlet UILabel *actorL;
@property (weak, nonatomic) IBOutlet UILabel *directorL;

@end
@implementation WVRTVMActorsCell

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRTVMActorsCellInfo * cellInfo = (WVRTVMActorsCellInfo*)info;
    self.areaL.text = cellInfo.model.area;
    self.ageL.text = cellInfo.model.year;
    self.directorL.text = cellInfo.model.director;
    NSString *string = [NSString stringWithFormat:@"主演：%@",cellInfo.model.actors];
    if (!string) {
        string = @"";
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6.0f;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12.5f) range:NSMakeRange(0, string.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName   //文字颜色
                             value:[UIColor blackColor]
                             range:NSMakeRange(0, 3)];
    
    if (string.length>3) {
        [attrString addAttribute:NSForegroundColorAttributeName   //文字颜色
                           value:[UIColor colorWithHex:0x898989]
                           range:NSMakeRange(3, string.length - 3)];
    }
    
    self.actorL.attributedText = attrString;

}
@end

@implementation WVRTVMActorsCellInfo

@end

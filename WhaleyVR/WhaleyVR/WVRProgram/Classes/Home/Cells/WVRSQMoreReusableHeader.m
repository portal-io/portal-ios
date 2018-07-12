//
//  WVRSQCollectionReusableHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQMoreReusableHeader.h"

@interface WVRSQMoreReusableHeader ()
- (IBAction)moreOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthCons;

@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UIImageView *subTitleIcon;
@property (nonatomic) WVRSQMoreReusableHeaderInfo * cellInfo;
@end
@implementation WVRSQMoreReusableHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRSQMoreReusableHeaderInfo*)info;
    self.titleL.text = self.cellInfo.sectionModel.name;
    self.subTitleL.text = self.cellInfo.sectionModel.subTitle;
    CGSize sizeL = [WVRComputeTool sizeOfString:self.cellInfo.sectionModel.name Size:CGSizeMake(2000.0, 21.f) Font:self.titleL.font];
    self.titleWidthCons.constant = sizeL.width;
    if(self.cellInfo.sectionModel.subTitle.length == 0){
        self.subTitleIcon.hidden = YES;
    }else{
        self.subTitleIcon.hidden = NO;
    }
}

- (IBAction)moreOnClick:(id)sender {
    if(self.cellInfo.sectionModel.subTitle.length == 0){
        return;
    }
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(self.cellInfo);
    }
}
@end
@implementation WVRSQMoreReusableHeaderInfo

@end

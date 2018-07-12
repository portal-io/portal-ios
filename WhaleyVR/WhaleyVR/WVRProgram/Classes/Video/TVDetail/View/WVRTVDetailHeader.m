//
//  WVRSQCollectionReusableHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRTVDetailHeader.h"

@interface WVRTVDetailHeader ()
- (IBAction)moreOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UIImageView *subTitleIcon;
@property (nonatomic) WVRTVDetailHeaderInfo * cellInfo;
@end
@implementation WVRTVDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRTVDetailHeaderInfo*)info;
    if (self.cellInfo.isOpen) {
        [self.subTitleIcon setImage:[UIImage imageNamed:@"icon_video_detail_floder_down"]];
        self.subTitleL.text = @"收起";
    }else{
        [self.subTitleIcon setImage:[UIImage imageNamed:@"icon_video_detail_floder_up"]];
        self.subTitleL.text = @"全部";
    }
}

- (IBAction)moreOnClick:(id)sender {
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(self.cellInfo);
    }
}
@end
@implementation WVRTVDetailHeaderInfo

@end

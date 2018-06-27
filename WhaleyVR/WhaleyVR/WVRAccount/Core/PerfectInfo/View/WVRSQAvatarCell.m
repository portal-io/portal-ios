//
//  WVRSQAvatarCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQAvatarCell.h"

@interface WVRSQAvatarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;

@property (nonatomic) WVRSQAvatarCellInfo * cellInfo;
@end

@implementation WVRSQAvatarCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.avatarImageV.layer setCornerRadius:self.avatarImageV.frame.size.width/2];
    self.avatarImageV.layer.masksToBounds = YES;

}
-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRSQAvatarCellInfo*)info;
    [self.avatarImageV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.avatar] placeholderImage:HOLDER_HEAD_IMAGE];
    
}
@end

@implementation WVRSQAvatarCellInfo
-(CGFloat)cellHeight
{
    return 200;
}
@end

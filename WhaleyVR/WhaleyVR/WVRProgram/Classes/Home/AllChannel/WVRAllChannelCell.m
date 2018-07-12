//
//  WVRAllChannelCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAllChannelCell.h"
#import "WVRItemModel.h"

@interface WVRAllChannelCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagL;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@end


@implementation WVRAllChannelCell

- (void)fillData:(WVRAllChannelCellInfo *)info {
    
    self.tagL.layer.cornerRadius = self.tagL.height/2.0;
    self.tagL.text = info.itemModel.name;
    
    NSString * str = info.itemModel.logoImageUrl;
    if ([str containsString:@"/zoom"]) {
        str = [[str componentsSeparatedByString:@"/zoom"] firstObject];
    }
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:str] placeholderImage:HOLDER_IMAGE];
}

@end


@implementation WVRAllChannelCellInfo

@end

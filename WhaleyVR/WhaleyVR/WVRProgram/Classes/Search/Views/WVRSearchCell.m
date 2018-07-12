//
//  WVRSearchCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSearchCell.h"
#import "SQDateTool.h"

@interface WVRSearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;

@property (nonatomic, weak) UIImageView *dramaTagImgV;

@end


@implementation WVRSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleL.font = kFontFitForSize(13.5f);
    self.subTitleL.font = kFontFitForSize(11.5f);
    
    [self dramaTagImgV];
}

- (UIImageView *)dramaTagImgV {
    if (!_dramaTagImgV) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_drama_tag"]];
        
        imgV.hidden = YES;
        [self.iconIV addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgV.superview);
            make.right.equalTo(imgV.superview);
            make.height.mas_equalTo(imgV.height);
            make.width.mas_equalTo(imgV.width);
        }];
        _dramaTagImgV = imgV;
    }
    return _dramaTagImgV;
}

- (void)fillData:(SQBaseTableViewInfo *)info {
    
    WVRSearchCellInfo * cellInfo = (WVRSearchCellInfo *) info;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = cellInfo.itemModel.name;
//    NSString * playCountStr = cellInfo.itemModel.playCount? cellInfo.itemModel.playCount:@"0";
    self.subTitleL.text = cellInfo.itemModel.intrDesc;  //[NSString stringWithFormat:@"%@次播放",playCountStr];
    self.dramaTagImgV.hidden = !cellInfo.isDrama;
}

@end

@implementation WVRSearchCellInfo

@end

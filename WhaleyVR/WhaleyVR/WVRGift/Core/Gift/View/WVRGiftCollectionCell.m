//
//  WVRGiftCollectionCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftCollectionCell.h"
#import "WVRGiftModel.h"

@interface WVRGiftCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *gIconV;
@property (weak, nonatomic) IBOutlet UILabel *gTitleL;
@property (weak, nonatomic) IBOutlet UILabel *gSubTitleL;

@property (nonatomic, weak) UIImageView *borderImgV;

@property (weak, nonatomic) WVRGiftCollectionCellViewModel * gCellInfo;

@end


@implementation WVRGiftCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self borderImgV];
}

- (UIImageView *)borderImgV {
    if (!_borderImgV) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"ic_gift_selected"];
        imgV.hidden = YES;
        
        [self addSubview:imgV];
        _borderImgV = imgV;
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV.superview);
            make.top.equalTo(imgV.superview);
            make.right.equalTo(imgV.superview);
            make.bottom.equalTo(imgV.superview);
        }];
    }
    
    return _borderImgV;
}

- (void)fillData:(WVRGiftCollectionCellViewModel *)info
{
    if (self.gCellInfo == info) {
        return;
    }
    WVRGiftModel * giftModel = info.args;
    self.gCellInfo = info;
    [self.gIconV wvr_setImageWithURL:[NSURL URLWithString:giftModel.icon] placeholderImage:HOLDER_IMAGE];
    self.gTitleL.text = giftModel.title;
    self.gSubTitleL.text = [NSString stringWithFormat:@"%@鲸币",giftModel.price];
    @weakify(self);
    [RACObserve(self.gCellInfo, isSelected) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateSelectStatus:self.gCellInfo.isSelected];
    }];
}

- (void)updateSelectStatus:(BOOL)isSelected {
    
    self.borderImgV.hidden = !isSelected;
    
//    if (isSelected) {
//        self.layer.borderWidth = 2.0f;
//        self.layer.borderColor = k_Color1.CGColor;
//    } else {
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//    }
}

@end


@implementation WVRGiftCollectionCellViewModel

@end

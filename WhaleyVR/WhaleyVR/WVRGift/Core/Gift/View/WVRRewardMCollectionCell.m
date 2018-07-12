//
//  WVRRewardMCollectionCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRewardMCollectionCell.h"
#import "WVRProgramMemberModel.h"

@interface WVRRewardMCollectionCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconVTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lTrainCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lLeadCons;

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (nonatomic, weak) UIImageView *borderImgV;

@property (weak, nonatomic) WVRRewardMCollectionCellViewModel * gCellInfo;

@end

@implementation WVRRewardMCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconIV.clipsToBounds = YES;
    self.iconIV.layer.cornerRadius = self.iconIV.height/2;
    
    [self borderImgV];
}

- (UIImageView *)borderImgV {
    if (!_borderImgV) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"ic_member_selected"];
        imgV.hidden = YES;
        
        [self addSubview:imgV];
        _borderImgV = imgV;
        
        kWeakSelf(self);
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.iconIV);
            make.top.equalTo(weakself.iconIV);
            make.right.equalTo(weakself.iconIV);
            make.bottom.equalTo(weakself.iconIV);
        }];
    }
    
    return _borderImgV;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconVTopCons.constant = fitToWidth(8.f);
    self.lBottomCons.constant = fitToWidth(7.f);
    self.lLeadCons.constant = fitToWidth(5.f);
    self.lTrainCons.constant = fitToWidth(5.f);
}

-(void)fillData:(WVRRewardMCollectionCellViewModel *)info
{
    if (self.gCellInfo == info) {
        return;
    }
    WVRProgramMemberModel * mModel = info.args;
    self.gCellInfo = info;
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:mModel.smallPic] placeholderImage:HOLDER_IMAGE];
    self.nameL.text = mModel.memberName;
    @weakify(self);
    [RACObserve(self.gCellInfo, isSelected) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateSelectStatus:self.gCellInfo.isSelected];
    }];
}

- (void)updateSelectStatus:(BOOL)isSelected {
    
    self.borderImgV.hidden = !isSelected;
    
//    if (isSelected) {
//        self.iconIV.layer.borderWidth = 2.0f;
//        self.iconIV.layer.borderColor = k_Color1.CGColor;
//        self.nameL.textColor = k_Color1;
//    }else{
//        self.iconIV.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.nameL.textColor = k_Color4;
//    }
}

@end


@implementation WVRRewardMCollectionCellViewModel

@end


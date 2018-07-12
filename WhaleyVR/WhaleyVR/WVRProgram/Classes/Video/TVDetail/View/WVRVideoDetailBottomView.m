//
//  WVRVideoDetailBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRVideoDetailBottomView.h"

@interface WVRVideoDetailBottomView ()

@property (weak, nonatomic) WVRCenterButton *downBtn;
@property (weak, nonatomic) WVRCenterButton *collectionBtn;
@property (weak, nonatomic) WVRCenterButton *shareBtn;

@end


@implementation WVRVideoDetailBottomView

- (instancetype)init {
    
    float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    return [self initWithFrame:CGRectMake(0, 0, width, 105)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createDownBtn];
        [self createCollectionBtn];
        [self createShareBtn];
        
        for (UIButton *btn in self.subviews) {
            [btn addTarget:self action:@selector(onClickItem:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

#pragma mark - UI

- (void)createDownBtn {
    
    WVRCenterButton *btn = [[WVRCenterButton alloc] initWithTitle:@"缓存" image:[UIImage imageNamed:@"icon_video_detail_down_disable"] selectImage:[UIImage imageNamed:@"icon_video_detail_down_enable"] tag:WVRVideoDBottomViewTypeDown containerView:self];
    btn.bottomX = self.width / 2.f - adaptToWidth(80);
    _downBtn = btn;
}

- (void)createCollectionBtn {
    
    WVRCenterButton *btn = [[WVRCenterButton alloc] initWithTitle:@"加入播单" image:[UIImage imageNamed:@"icon_video_detail_collection_default"] selectImage:[UIImage imageNamed:@"icon_video_detail_collection_select"] tag:WVRVideoDBottomViewTypeCollection containerView:self];
    btn.centerX = self.width / 2.f;
    _collectionBtn = btn;
}

- (void)createShareBtn {
    
    WVRCenterButton *btn = [[WVRCenterButton alloc] initWithTitle:@"分享" image:[UIImage imageNamed:@"icon_video_detail_share"] selectImage:[UIImage imageNamed:@"icon_video_detail_share"] tag:WVRVideoDBottomViewTypeShare containerView:self];
    btn.x = self.width / 2.f + adaptToWidth(80);
    _shareBtn = btn;
}

#pragma mark - action

- (IBAction)onClickItem:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(onClickItemType:bottomView:)]) {
        [self.delegate onClickItemType:sender.tag bottomView:self];
    }
}

- (void)updateCollectionDone:(BOOL)done {
    
    self.collectionBtn.selected = done;
    
    NSString *title = done ? @"已加入播单" : @"加入播单";
    
    [self.collectionBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateDownBtnStatus:(WVRVideoDBottomVDownStatus)status {
    
    [self.downBtn setStatus:status];
}

@end


@interface WVRCenterButton () {
    
    BOOL _isSelected;
}

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) UIImage *normalImage;

@end


@implementation WVRCenterButton

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage tag:(NSInteger)tag containerView:(UIView *)containerView {
    self = [super initWithFrame:CGRectMake(0, 0, 70, containerView.height)];
    if (self) {
        self.tag = tag;
        
        _normalImage = image;
        _selectImage = selectImage;
        
        [self createIconViewWithImage:image];
        [self createNameLabelWithText:title];
        
        [containerView addSubview:self];
    }
    return self;
}

- (void)createIconViewWithImage:(UIImage *)image {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imgV.image = image;
    
    [self addSubview:imgV];
    _iconView = imgV;
    imgV.centerX = self.width / 2.f;
    imgV.bottomY = self.height / 2.f - 3;
}

- (void)createNameLabelWithText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.font = FONT(13.5);
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    label.width = self.width;
    [self addSubview:label];
    _nameLabel = label;
    label.centerX = self.width / 2.f;
    label.y = self.height / 2.f + 3;
}

#pragma mark - overwrite

// for collection button
- (void)setSelected:(BOOL)selected {
    
    _isSelected = selected;
    
    self.iconView.image = _isSelected ? self.selectImage : self.normalImage;
//    self.alpha = _isSelected ? 0.5 : 1;
}

// for download button
- (void)setStatus:(WVRVideoDBottomVDownStatus)status {
    
    NSString *title = @"缓存";
    NSString *imgName = @"icon_video_detail_down_disable";
    switch (status) {
        case WVRVideoDBottomVDownStatusNeedCharge: {
//            self.iconView.alpha = 0.5;
            _nameLabel.textColor = k_Color8;
        }
            break;
            
        case WVRVideoDBottomVDownStatusEnable: {
            imgName = @"icon_video_detail_down_enable";
            self.iconView.alpha = 1;
            _nameLabel.textColor = [UIColor blackColor];
        }
            break;
            
        case WVRVideoDBottomVDownStatusDown: {
            imgName = @"icon_video_detail_down_select";
            title = @"已缓存";
//            self.iconView.alpha = 0.5;
            
        }
            break;
            
        default:
            break;
    }
    self.nameLabel.text = title;
    [self.iconView setImage:[UIImage imageNamed:imgName]];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    self.nameLabel.text = title;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    self.iconView.image = image;
}

@end

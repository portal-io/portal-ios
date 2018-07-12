//
//  WVRSQArrangeMAHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQArrangeMAHeader.h"
#import "WVRImageTool.h"

@interface WVRSQArrangeMAHeader ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *subNameL;

@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property (weak, nonatomic) IBOutlet UILabel *intrDesL;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

- (IBAction)playBtnOnClick:(id)sender;

@property (nonatomic) WVRSQArrangeMAHeaderInfo * cellInfo;

@property (nonatomic) CGFloat playWidth;
@property (nonatomic) CGFloat playBtnCenterX;
@property (nonatomic) CGFloat playBtnCenterY;

@property (nonatomic, assign) float nameLabelWidth;

@property (nonatomic, weak) UILabel *purchasedLabel;        // 已有观看券

@end


@implementation WVRSQArrangeMAHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _nameLabelWidth = SCREEN_WIDTH - 100;
    
    self.playWidth = fitToWidth(self.playBtn.width);
    self.playBtnCenterX = fitToWidth(self.playBtn.centerX);
    self.playBtnCenterY = fitToWidth(self.playBtn.centerY);
    self.playBtn.centerX = self.playBtnCenterX;
    self.playBtn.centerY = self.playBtnCenterY;
    self.playBtn.width = self.playWidth;
    
    [self.nameL mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_lessThanOrEqualTo(@(self.nameLabelWidth));
    }];
    
    float height = 19;
    float gap = 12;
    float offset = 0 - adaptToWidth(15 * 2);
    
    [self.subNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameL);
        make.top.equalTo(self.nameL.mas_bottom).offset(gap);
        make.height.mas_lessThanOrEqualTo(height);
        make.width.equalTo(@50);
    }];
    
    [self.intrDesL mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameL);
        make.top.equalTo(self.subNameL.mas_bottom).offset(gap);
        make.height.mas_greaterThanOrEqualTo(height);
        make.width.equalTo(self).offset(offset);
    }];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRSQArrangeMAHeaderInfo *)info;
    
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[WVRImageTool parseImageUrl:self.cellInfo.sectionModel.thubImageUrl scaleSize:_thubImageV.size]] placeholderImage:HOLDER_IMAGE];
    NSString *string = self.cellInfo.sectionModel.intrDesc ?: @"";
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    self.intrDesL.attributedText = attrString;
    self.nameL.text = self.cellInfo.sectionModel.name;
    NSInteger videoCount = [self.cellInfo.sectionModel.itemCount integerValue]-self.cellInfo.subManualArrangeCount;
    NSString * videoCountStr = @"";
    NSString * arrange = @"";
    if (self.cellInfo.subManualArrangeCount>0) {
        arrange = [NSString stringWithFormat:@"%d个子专题",(int)self.cellInfo.subManualArrangeCount];
    }
    if (videoCount>0) {
        videoCountStr = [NSString stringWithFormat:@"%d个视频", (int)videoCount];
    }
    NSString * midlleStr = @"";
    if (videoCount>0&&self.cellInfo.subManualArrangeCount>0) {
        midlleStr = @" | ";
    }
    self.subNameL.text = [NSString stringWithFormat:@"%@%@%@", videoCountStr, midlleStr, arrange];
    
    [self initPlayBtnStatusBlock];
    [self updateNameLabelHeight];
    
    [self createHavePurchasedLabelIfNeed];
    
    // 节目包未付费的情况下，不显示连播按钮（节目包收费，并且未付费，并且折扣价格不为0）
    self.playBtn.hidden = (self.cellInfo.sectionModel.isChargeable && !self.cellInfo.sectionModel.haveCharged && ![self.cellInfo.sectionModel programPackageHaveCharged]);
    self.playBtn.hidden = self.cellInfo.hidenPlayBtn||self.playBtn.hidden;
}

/// just for UnityTemp View
- (void)setSectionModel:(WVRSectionModel *)sectionModel {
    
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[WVRImageTool parseImageUrl:sectionModel.thubImageUrl scaleSize:_thubImageV.size]] placeholderImage:HOLDER_IMAGE];
    NSString *string = sectionModel.intrDesc ?: @"";
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    self.intrDesL.attributedText = attrString;
    self.nameL.text = sectionModel.name;
    
    NSString *count = sectionModel.itemCount;
    if (!count) {
        count = [NSString stringWithFormat:@"%d", (int)sectionModel.itemModels.count];
    }
    
    self.subNameL.text = [NSString stringWithFormat:@"%@个视频", count];
    
    [self initPlayBtnStatusBlock];
    [self updateNameLabelHeight];
}

- (void)createHavePurchasedLabelIfNeed {
    
    if (!self.cellInfo.sectionModel.isChargeable || !self.cellInfo.sectionModel.haveCharged) {
        self.purchasedLabel.hidden = YES;
        return;
    }
    if (self.purchasedLabel) {
        self.purchasedLabel.hidden = NO;
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(65), adaptToWidth(17))];
    label.text = @"已有观看券";
    label.font = kFontFitForSize(10);
    label.textColor = k_Color15;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.layer.cornerRadius = label.height * 0.5;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = label.textColor.CGColor;
    label.layer.borderWidth = 0.5;
    
    [self addSubview:label];
    _purchasedLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subNameL.mas_right).offset(10);
        make.centerY.equalTo(self.subNameL);
        make.height.mas_equalTo(label.height);
        make.width.mas_equalTo(label.width);
    }];
}

// 名称太长，显示为多行
- (void)updateNameLabelHeight {
    
    CGSize tmpSize = CGSizeMake(self.nameLabelWidth, 800);
    float height = [WVRComputeTool sizeOfString:self.nameL.text Size:tmpSize Font:self.nameL.font].height;
    
    if (height > self.nameL.height) {
        [self.nameL mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@(height));
        }];
    }
    
    CGSize subNameSize = CGSizeMake(300, self.subNameL.height);
    float width = [WVRComputeTool sizeOfString:self.subNameL.text Size:subNameSize Font:self.subNameL.font].width;
    [self.subNameL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)initPlayBtnStatusBlock {
    
    if (!self.cellInfo.playStatusBlock) {
        kWeakSelf(self);
        self.cellInfo.playStatusBlock = ^(CGFloat scale) {
            [weakself playBtnStatusBlock:scale];
        };
    }
}

- (void)playBtnStatusBlock:(CGFloat)scale {
    if (scale > 1) {
        self.playBtn.width = self.playWidth;
        self.playBtn.height = self.playWidth;
        self.playBtn.centerX = self.playBtnCenterX;
        self.playBtn.centerY = self.playBtnCenterY;
    } else {
        
        self.playBtn.width = self.playWidth * scale;
        self.playBtn.height = self.playWidth * scale;
        self.playBtn.centerX = self.playBtnCenterX;
        self.playBtn.centerY = self.playBtnCenterY;
    }
}

#pragma mark - action

- (IBAction)playBtnOnClick:(id)sender {
    if (self.cellInfo.gotoNextBlock) {
        self.cellInfo.gotoNextBlock(self.cellInfo);
    }
}

@end


@implementation WVRSQArrangeMAHeaderInfo

@end

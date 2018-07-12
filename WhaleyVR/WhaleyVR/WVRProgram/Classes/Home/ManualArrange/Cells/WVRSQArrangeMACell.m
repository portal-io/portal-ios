//
//  WVRSQArrangeMACell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQArrangeMACell.h"
#import "WVRImageTool.h"
#import "SQDateTool.h"

@interface WVRSQArrangeMACell ()

@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *intrDesL;
@property (weak, nonatomic) IBOutlet UIImageView *gDramaTag;
- (IBAction)gotoDetailOnClick:(id)sender;
- (IBAction)playBtnOnClick:(id)sender;

@property (weak, nonatomic) WVRSQArrangeMACellInfo * cellInfo;

@property (nonatomic, weak) UILabel *purchasedLabel;

@end


@implementation WVRSQArrangeMACell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleL.font = kFontFitForSize(14);
    self.intrDesL.font = kFontFitForSize(12);
    
    self.titleL.textColor = k_Color_hex(0x351d00);
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([NSStringFromClass([self wvr_viewController].class) isEqualToString:@"WVRSpring2018TopicController"]) {
        
        self.intrDesL.textColor = k_Color_hex(0xae8143);
        
    } else {
        
        self.intrDesL.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    }
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRSQArrangeMACellInfo *)info;
    [self.thubImageV wvr_setImageWithURL:self.cellInfo.iconUrl placeholderImage:HOLDER_IMAGE];
    self.titleL.text = self.cellInfo.title;
    self.intrDesL.text = self.cellInfo.intrDesL;
    if ([[self.cellInfo.args linkArrangeType] isEqualToString:LINKARRANGETYPE_DRAMA_PROGRAM]) {
        self.gDramaTag.hidden = NO;
    } else if ([[self.cellInfo.args programType] isEqualToString:PROGRAMTYPE_DRAMA]) {
        self.gDramaTag.hidden = NO;
    } else {
        self.gDramaTag.hidden = YES;
    }
    [self createHavePurchasedLabelIfNeed];
}

- (void)createHavePurchasedLabelIfNeed {
    
    BOOL shouldShow = self.cellInfo.packageItemCharged;
    if (!shouldShow) {
        self.purchasedLabel.hidden = YES;
        return;
    } else if (self.purchasedLabel) {
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
        make.left.equalTo(self.intrDesL.mas_right).offset(10);
        make.centerY.equalTo(self.intrDesL);
        make.height.mas_equalTo(label.height);
        make.width.mas_equalTo(label.width);
    }];
}

- (IBAction)playBtnOnClick:(id)sender {
    if (self.cellInfo.playBlock) {
        self.cellInfo.playBlock();
    }
}

- (IBAction)gotoDetailOnClick:(id)sender {
    if (self.cellInfo.gotoDetailBlock) {
        self.cellInfo.gotoDetailBlock();
    }
}

@end


@implementation WVRSQArrangeMACellInfo

- (void)convert:(WVRItemModel *)itemModel {
    
    self.iconUrl = [NSURL URLWithString:itemModel.thubImageUrl];
    self.title = itemModel.name;
    self.packageItemCharged = itemModel.packageItemCharged.boolValue;
    NSString* playCountStr = [WVRComputeTool numberToString:(long)[itemModel.playCount longLongValue]];
    long duration = (long)[itemModel.duration longLongValue];
    //    NSInteger second = [self.cellInfo.itemModel.duration longLongValue] % 60;
    NSString * durationStr = [self numberToTime:duration];  // [NSString stringWithFormat:@"%ld分%ld秒",minute,second];
    
    NSString * notStartIntrStr = [NSString stringWithFormat:@"%@ | %@人播放", durationStr, playCountStr];
    
    self.intrDesL = notStartIntrStr;
}

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d分%02d秒", (int)time/60, (int)time%60];
}


//- (NSString *)parseImageUrl:(WVRItemModel*)itemModel {
//    
//    //    NSArray* array = [self.cellInfo.itemModel.thubImage componentsSeparatedByString:@"zoom"];
//    //    NSString * result = [array firstObject];
//    //    result = [result stringByAppendingFormat:@"%d/%d",(int)self.cellInfo.cellSize.width,(int)self.cellInfo.cellSize.height];
//    if (itemModel.scaleThubImage) {
//        
//    } else {
//        itemModel.scaleThubImage = [WVRImageTool parseImageUrl:itemModel.thubImageUrl scaleSize:self.thubImageV.size];
//    }
//    return itemModel.scaleThubImage ?: itemModel.thubImageUrl;
//}

/// just for UnityTemp View
//- (void)setItemModel:(WVRItemModel *)itemModel {
//    _itemModel = itemModel;
//    
//    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrl]] placeholderImage:HOLDER_IMAGE];
//    self.titleL.text = itemModel.name;
//    NSString* playCountStr = [WVRComputeTool numberToString:(long)[itemModel.playCount longLongValue]];
//    long duration = (long)[itemModel.duration longLongValue];
//    
//    NSString * durationStr = [self numberToTime:duration];
//    NSString * notStartIntrStr = [NSString stringWithFormat:@"%@ | %@人播放", durationStr, playCountStr];
//    self.intrDesL.text = notStartIntrStr;
//}

@end

//
//  WVRSubManualArrangeCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSubManualArrangeCell.h"
#import "WVRImageTool.h"

@interface WVRSubManualArrangeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;

- (IBAction)gotoDetailOnClick:(id)sender;

@property (nonatomic, weak) WVRSubManualArrangeCellInfo * cellInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UILabel *intrL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thubIVTopConst;

//@property (weak, nonatomic) IBOutlet UIImageView *gDramaTag;

@property (nonatomic, strong) CALayer * gThubIVLayer;
@end
@implementation WVRSubManualArrangeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置渐变效果
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                            (id)[[UIColor colorWithWhite:0 alpha:0.9] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.thubImageV.layer insertSublayer:gradientLayer atIndex:0];
    self.gThubIVLayer = gradientLayer;
    [self.titleL sizeToFit];
    [self.subTitleL sizeToFit];
    [self.intrL sizeToFit];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gThubIVLayer.frame = CGRectMake(0, 0, self.thubImageV.width, self.thubImageV.height);
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRSubManualArrangeCellInfo *)info;
    [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:[self parseImageUrl]] placeholderImage:HOLDER_IMAGE];
    self.titleL.text = self.cellInfo.itemModel.name;
    
    NSInteger count = [self.cellInfo.itemModel.detailCount integerValue];
    self.subTitleL.text = [NSString stringWithFormat:@"共 %d 个内容", (int)count];

    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.cellInfo.itemModel.intrDesc attributes:nil];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:2.5];//行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.cellInfo.itemModel.intrDesc length])];
    self.intrL.attributedText = attributedString;
    self.thubIVTopConst.constant = self.cellInfo.gTop;
//    if ([self.cellInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_DRAMA_PROGRAM]) {
//        self.gDramaTag.hidden = NO;
//    }else if ([self.cellInfo.itemModel.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
//        self.gDramaTag.hidden = NO;
//    }else{
//        self.gDramaTag.hidden = YES;
//    }
}

- (NSString *)parseImageUrl {
    
    //    NSArray* array = [self.cellInfo.itemModel.thubImage componentsSeparatedByString:@"zoom"];
    //    NSString * result = [array firstObject];
    //    result = [result stringByAppendingFormat:@"%d/%d",(int)self.cellInfo.cellSize.width,(int)self.cellInfo.cellSize.height];
    if (self.cellInfo.itemModel.scaleThubImage) {
        
    } else {
        self.cellInfo.itemModel.scaleThubImage = [WVRImageTool parseImageUrl:self.cellInfo.itemModel.thubImageUrl scaleSize:self.thubImageV.size];
    }
    return self.cellInfo.itemModel.scaleThubImage ?: self.cellInfo.itemModel.thubImageUrl;
}


- (IBAction)gotoDetailOnClick:(id)sender {
    if (self.cellInfo.gotoDetailBlock) {
        self.cellInfo.gotoDetailBlock();
    }
}
@end

@implementation WVRSubManualArrangeCellInfo

@end

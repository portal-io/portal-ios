//
//  WVRUnityTempVideoView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityTempVideoView.h"

//#import "WVRDetailBottomVTool.h"
//#import "WVRPublisherView.h"
#import "YYText.h"

@interface WVRUnityTempVideoView () {
    
    float _layoutLength;
    float _spaceY;
}

@property (nonatomic, strong) WVRItemModel *detailModel;

@property (nonatomic, weak) UILabel         *nameLabel;
@property (nonatomic, weak) YYLabel         *countLabel;
@property (nonatomic, weak) UIImageView     *imageView;

//@property (nonatomic) WVRDetailBottomVTool *mBottomVTool;
//
//@property (nonatomic, weak) WVRPublisherView *publisherView;

@end


@implementation WVRUnityTempVideoView

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dataDict {
    self = [super initWithFrame:frame];
    if (self) {
        
        Class cls = NSClassFromString(@"WVRVideoDetailVCModel");
        _detailModel = [cls yy_modelWithDictionary:dataDict];
        
        _layoutLength = adaptToWidth(15);
        _spaceY = adaptToWidth(20);
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    [self createImageView];
    [self createNameLabel];
    [self createCountLabel];
    
    float descY = _countLabel.bottomY + 2 * _spaceY;
    [self createBottomToolWithY:descY];
    
    [self createPublisherView];
}

- (void)createImageView {
    
//    float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
//    float height = roundf(width / 18.f * 11);
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    imageView.clipsToBounds = YES;
//    imageView.userInteractionEnabled = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    [imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:_detailModel.bigPic] placeholderImage:HOLDER_IMAGE];
//    
//    [self addSubview:imageView];
//    _imageView = imageView;
}

- (void)createNameLabel {
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_layoutLength, _imageView.bottomY + _spaceY, SCREEN_WIDTH - 2*_layoutLength, 20)];
    nameLabel.font = kBoldFontFitSize(18.5);
    nameLabel.textColor = k_Color3;
    nameLabel.text = _detailModel.title;
    nameLabel.numberOfLines = 0;
    
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    float width = SCREEN_WIDTH - 2 * _layoutLength;
    nameLabel.size = [WVRComputeTool sizeOfString:_nameLabel.text Size:CGSizeMake(width, MAXFLOAT) Font:_nameLabel.font];
}

- (void)createCountLabel {
    
    // 播放次数
    YYLabel *countLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_layoutLength, _nameLabel.bottomY + _layoutLength - 2, _nameLabel.width, 20)];
    
    NSString *str = [NSString stringWithFormat:@"  %@次播放", [WVRComputeTool numberToString:[_detailModel.playCount longLongValue]]];
    UIFont *font = kFontFitForSize(13);
    UIImage *image = [UIImage imageNamed:@"icon_playCount"];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0x898989], NSFontAttributeName:font }]];
    countLabel.attributedText = text;
    CGSize sizeOriginal = CGSizeMake(200, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    
    CGSize size = layout.textBoundingSize;
    countLabel.textLayout = layout;
    countLabel.size = size;
    
    [self addSubview:countLabel];
    _countLabel = countLabel;
}

- (void)createPublisherView {
    
//    WVRPublisherView *publisherV = [[WVRPublisherView alloc] init];
//    publisherV.cpCode = _detailModel.cpCode;
//    publisherV.fansCount = _detailModel.fansCount;
//    publisherV.isFollow = _detailModel.isFollow;
//    publisherV.iconUrl = _detailModel.headPic;
//    publisherV.name = _detailModel.name;
//    
////    [publisherV.button addTarget:self action:@selector(publisherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:publisherV];
//    _publisherView = publisherV;
//    
//    _publisherView.y = self.mBottomVTool.mBottomView.bottomY;
}

- (void)createBottomToolWithY:(float)toolY {
    
//    if (self.mBottomVTool) { return; }
//    
//    WVRTVItemModel * model = [[WVRTVItemModel alloc] init];
//    model.detailType = WVRVideoDetailTypeVR;
//    model.name = self.detailModel.displayName;
//    model.programType = self.detailModel.programType;
//    model.videoType = self.detailModel.videoType;
//    model.duration = self.detailModel.duration;
//    model.playCount = self.detailModel.playCount;
//    model.thubImageUrl = self.detailModel.smallPic ?: self.detailModel.lunboPic;
//    model.isChargeable = self.detailModel.isChargeable;
//    model.downloadUrl = self.detailModel.downloadUrl;
//    model.linkArrangeType = LINKARRANGETYPE_PROGRAM;
//    self.mBottomVTool = [WVRDetailBottomVTool loadBottomView:model parentV:self];
//    
//    self.mBottomVTool.mBottomView.y = self.countLabel.bottomY + _layoutLength;
//    
//    [self.mBottomVTool.mBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.countLabel.mas_bottom).offset(_layoutLength);
//    }];
}

@end

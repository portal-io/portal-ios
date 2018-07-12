//
//  WVRUnityTempLiveView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUnityTempLiveView.h"

#import "YYText.h"
#import "SQDateTool.h"
#import "WVRUIEngine.h"

#import <WVRAppContextHeader.h>
#import <UIView+Extend.h>
#import <UIColor+Extend.h>

#import "WVRItemModel.h"

#import "WVRComputeTool.h"

#import <SDWebImage/SDWebImage.h>
#import <NSURL+Extend.h>
#import <UIImage+Extend.h>

@interface WVRUnityTempLiveView ()

@property (nonatomic, strong) WVRItemModel *dataModel;

@property (nonatomic, weak) UIScrollView    *scrollView;
@property (nonatomic, weak) UIImageView     *imageView;
@property (nonatomic, weak) UIView          *contentView;
@property (nonatomic, weak) UILabel         *countLabel;
@property (nonatomic, weak) YYLabel         *timeLabel;
@property (nonatomic, weak) YYLabel         *addressLabel;
@property (nonatomic, weak) UILabel         *descLabel;
@property (nonatomic, weak) UIView          *line;
@property (nonatomic, weak) UILabel         *purchasedLabel;

@property (nonatomic) UIButton * mReserveBtn;

@property (nonatomic, assign) float length;

@end


@implementation WVRUnityTempLiveView

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dataDict {
    self = [super initWithFrame:frame];
    if (self) {
        Class cls = NSClassFromString(@"WVRLiveItemModel");
        _dataModel = [cls yy_modelWithDictionary:dataDict];
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    _length = adaptToWidth(15);
    
    [self createImageView];
    [self createContentView];
    [self createTimeLabel];
    [self createAddressLabel];
    [self createDescLabel];
    [self createLine];
    [self createMembers];
}

- (void)createImageView {
    
    float height = roundf(SCREEN_WIDTH / 18.f * 11);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    NSString *poster = [_dataModel performSelector:@selector(poster)];
    NSString *pic = [_dataModel performSelector:@selector(pic)];
    [imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:poster ?: pic] placeholderImage:HOLDER_IMAGE options:SDWebImageRetryFailed progress:nil completed:nil];
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)createContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.bottomY, self.width, adaptToWidth(60))];
    contentView.backgroundColor = k_Color1;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [WVRAppModel fontFitForSize:13];
    label.textColor = [UIColor whiteColor];
    label.text = @"当前预约人数:";
    [label sizeToFit];
    label.x = _length;
    label.centerY = contentView.height / 2.f;
    [contentView addSubview:label];
    
    [self addSubview:contentView];
    _contentView = contentView;
    
    // liveOrderCount       当前预约人数
    // liveOrdered          是否已预约
    // timeLeftSeconds      距离开播时间
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.x = label.bottomX + adaptToWidth(5);
    [_contentView addSubview:countLabel];
    _countLabel = countLabel;
    
    [self updateCountLabel:[_dataModel performSelector:@selector(liveOrderCount)]];
    [contentView addSubview:[self createReserveBtn]];
    self.mReserveBtn.bottomX = self.width - adaptToWidth(15);
    self.mReserveBtn.centerY = label.centerY;
}

- (void)createTimeLabel {
    
    // 播放次数 或 开播时间
    YYLabel *timeLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, _contentView.bottomY + adaptToWidth(20), 60, 20)];
    
    UIFont *font = kFontFitForSize(13);
    
//    timeLabel.attributedText = [self lastTimeStr:_dataModel.beginTime];
    long time = [self.dataModel performSelector:@selector(timeLeftSeconds)];
    [self timeForSecond:(0 - time)];
    
    timeLabel.top = _contentView.bottomY + fitToWidth(30);
    
    // 距离2017.02.24 09:25 开播还有 1 天
    
    NSString *str = [SQDateTool year_month_day_hour_minute:[[_dataModel performSelector:@selector(beginTime)] doubleValue]];
    str = [NSString stringWithFormat:@"  %@", str];
    str = [NSString stringWithFormat:@"距离%@ 开播还有", str];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if ([self.dataModel performSelector:@selector(timeLeftSeconds)] > 0) {
        
        [text appendAttributedString:[[NSAttributedString alloc]
                                      initWithString:str
                                      attributes:@{ NSForegroundColorAttributeName:k_Color3, NSFontAttributeName:font }]];
        NSAttributedString *time = [self timeForSecond:[self.dataModel performSelector:@selector(timeLeftSeconds)]];
        
        [text appendAttributedString:time];
        timeLabel.attributedText = text;
        
    } else {
        
        text = [[NSMutableAttributedString alloc] initWithString:@"即将开播"];
    }
    CGSize sizeOriginal = CGSizeMake(self.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    
    timeLabel.size = layout.textBoundingSize;
    timeLabel.textLayout = layout;
    timeLabel.centerX = self.width / 2.f;
    
    [_scrollView addSubview:timeLabel];
    _timeLabel = timeLabel;
}

- (void)createAddressLabel {
    
    // 直播地址
    YYLabel *addressLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, _timeLabel.bottomY + adaptToWidth(8), self.width, 30)];
    
    UIFont *font = kFontFitForSize(13);
    
    UIImage *image = [UIImage imageNamed:@"icon_area_black"];
    NSString *address = _dataModel.address;
    if (address.length > 10) {
        address = [address substringToIndex:10];
    }
    NSString *str = [NSString stringWithFormat:@"  %@", _dataModel.address];
    
    NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:str
                                  attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHex:0x898989], NSFontAttributeName: font }]];
    
    addressLabel.attributedText = [text copy];
    
    CGSize sizeOriginal = CGSizeMake(self.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:sizeOriginal text:text];
    addressLabel.size = layout.textBoundingSize;
    addressLabel.textLayout = layout;
    
    addressLabel.centerX = _timeLabel.centerX;
    
    [_scrollView addSubview:addressLabel];
    _addressLabel = addressLabel;
}

- (void)createDescLabel {
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_length, _addressLabel.bottomY + adaptToWidth(20), self.width - 2 * _length, 30)];
    NSString *string = [NSString stringWithFormat:@"%@：%@", @"简介", _dataModel.intrDesc];
    NSAttributedString *attributedString = [WVRUIEngine descStringWithString:string];
    
    descLabel.attributedText = attributedString;
    descLabel.size = [WVRComputeTool sizeOfString:attributedString Size:CGSizeMake(SCREEN_WIDTH-34, MAXFLOAT)];
    descLabel.numberOfLines = 0;
    [_scrollView addSubview:descLabel];
    _descLabel = descLabel;
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _descLabel.bottomY + adaptToWidth(30));
}

- (void)createLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _descLabel.bottomY + adaptToWidth(20), self.width, 1)];
    line.backgroundColor = kLineBGColor;
    [_scrollView addSubview:line];
    _line = line;
}

- (void)createMembers {
    
    NSArray *picArray = [_dataModel performSelector:@selector(guestPics)];
    NSArray *nameArray = [_dataModel performSelector:@selector(guestNames)];
    [[NSMutableAttributedString alloc] initWithData:nil options:nil documentAttributes:nil error:nil];
    UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(_length, _line.bottomY + _length, 100, 25)];
    memberTitle.text = @"阵容成员：";
    memberTitle.font = kFontFitForSize(12.5);
    memberTitle.textColor = [UIColor blackColor];
    [_scrollView addSubview:memberTitle];
    
    float imgVWidth = roundf((SCREEN_WIDTH - 4* adaptToWidth(10) - 2*_length)/5.f);
    float imgVSpace = adaptToWidth(10);
    
    int i = 0;
    for (NSString *picURL in picArray) {
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(_length + (imgVWidth+imgVSpace)*i, memberTitle.bottomY, imgVWidth, imgVWidth)];
        headView.contentMode = UIViewContentModeScaleAspectFill;
        headView.layer.cornerRadius = imgVWidth/2.0;
        headView.layer.masksToBounds = YES;
        [headView wvr_setImageWithURL:[NSURL URLWithUTF8String:picURL] placeholderImage:HOLDER_IMAGE];
        [_scrollView addSubview:headView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.x, headView.bottomY, headView.width, 25)];
        nameLabel.font = kFontFitForSize(12.5);
        nameLabel.textColor = [UIColor colorWithHex:0x898989];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = nameArray[i];
        [_scrollView addSubview:nameLabel];
        
        i += 1;
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, memberTitle.bottomY + imgVWidth + adaptToWidth(30));
}

- (void)updateCountLabel:(NSString*)content {
    
    UIFont* font = [UIFont fontWithName:@"DIN Alternate" size:fitToWidth(30.f)];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    [text appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:content
                                  attributes:@{ NSForegroundColorAttributeName:k_Color12, NSFontAttributeName:font,NSKernAttributeName : @(2.f) }]];
    self.countLabel.attributedText = text;
    [self.countLabel sizeToFit];
    self.countLabel.centerY = self.contentView.height/2.f;
}

- (UIButton *)createReserveBtn {
    
    if (!self.mReserveBtn) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(87),adaptToWidth(39))];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = adaptToWidth(5);
        [btn setTitleColor:k_Color1 forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:k_Color12 size:btn.size] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[WVRAppModel fontFitForSize:15]];
        
//        [btn addTarget:self action:@selector(reserveOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.mReserveBtn = btn;
        
    }
    [self updateReserveBtn:NO];
    
    return self.mReserveBtn;
}

- (void)updateReserveBtn:(BOOL)isOrder {
    
    self.mReserveBtn.userInteractionEnabled = YES;
    
    if (isOrder) {
        [self.mReserveBtn setTitle:@"已预约" forState:UIControlStateNormal];
        self.mReserveBtn.alpha = 0.8;
    } else {
        [self.mReserveBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        self.mReserveBtn.alpha = 1;
    }
}

- (void)action_nothing {
    
}

// sec > 0 的时候使用
- (NSAttributedString *)timeForSecond:(long)sec {
    
    long day = sec / 3600 / 24;
    long hour = sec / 3600;
    long min = sec / 60;
    long lastSec = sec%60;
    NSString *str = nil;
    NSAttributedString *attStr = nil;
    if (day >= 1) {
        str = [NSString stringWithFormat:@" %ld 天", day];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 1)];
    } else if (hour >= 1) {
        str = [NSString stringWithFormat:@" %ld 小时", hour];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 2)];
    } else if (min > 0) {
        str = [NSString stringWithFormat:@" %ld 分钟", min];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 2)];
    } else {
        str = [NSString stringWithFormat:@" %ld 秒", lastSec];
        attStr = [self attributedTextStr:str range:NSMakeRange(0, str.length - 1)];
    }
    
    return attStr;
}

- (NSMutableAttributedString *)attributedTextStr:(NSString *)originStr range:(NSRange)range {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:originStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    [str addAttribute:NSFontAttributeName value:kFontFitForSize(15) range:range];
    
    return str;
}

@end

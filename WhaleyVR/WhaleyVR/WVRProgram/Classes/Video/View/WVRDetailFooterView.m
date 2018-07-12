//
//  WVRDetailFooterView.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRDetailFooterView.h"

@interface WVRDetailFooterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    float _lazyCellHeight;
    
    NSArray *_dataArray;
}

@property (nonatomic, weak  ) UILabel *titleLabel;
@property (nonatomic, weak) UICollectionView *collectionView;

@end


@implementation WVRDetailFooterView

static float headerHeight = 50;     // header height
static float lengthX = 15;          // 距离左边距离       fitTowidth
static float cellHeight = 80;       // cell height      fitTowidth
static float spaceY = 17;           // Y轴间距
static float footerHeight = 30;

static NSString *const detailFooterCellId = @"detailFooterCellId";

- (instancetype)initWithDatas:(NSArray *)array {
    
    _dataArray = array;
    
    float height = headerHeight + footerHeight + ceilf(fitToWidth(cellHeight)) * array.count + ceilf(fitToWidth(spaceY)) * (array.count - 1);
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, height);
    
    return [self initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        float toX = ceilf(fitToWidth(lengthX));
        
        UIView *_tagView = [[UIView alloc] init];
        _tagView.backgroundColor = k_Color1;
        _tagView.frame = CGRectMake(toX, 0, fitToWidth(5), fitToWidth(15));
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tagView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _tagView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _tagView.layer.mask = maskLayer;        // 此方法圆角不能超过宽度的一半
        
        _tagView.centerY = headerHeight/2.0;
        [self addSubview:_tagView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_tagView.bottomX+8, 0, self.width - 30, headerHeight)];
        label.font = kFontFitForSize(16);
        label.textColor = k_Color3;
        label.text = @"相关推荐";
        
        [self addSubview:label];
        _titleLabel = label;
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection             = UICollectionViewScrollDirectionVertical;
        
        CGRect rect = CGRectMake(0, headerHeight, self.width, self.height - headerHeight - footerHeight);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [collectionView registerClass:[WVRDetailFooterCell class] forCellWithReuseIdentifier:detailFooterCellId];
        
        [self addSubview:collectionView];
        self.collectionView = collectionView;
    }
    
    return self;
}

#pragma mark - Setter getter

- (void)setDataArray:(NSArray *)dataArray {
    
    if (_dataArray != dataArray) {
        
        _dataArray = dataArray;
        
        [_collectionView reloadData];
    }
}

- (float)cellHeight {
    
    if (_lazyCellHeight == 0) {
        _lazyCellHeight = ceilf(fitToWidth(cellHeight));
    }
    
    return _lazyCellHeight;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.realDelegate detailFooterView:self didSelectItem:indexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取出model，赋值页面
    WVRDetailFooterModel *model = _dataArray[indexPath.item];
    
    WVRDetailFooterCell *viewCell = [collectionView dequeueReusableCellWithReuseIdentifier:detailFooterCellId forIndexPath:indexPath];
    [viewCell setModel:model];
    
    return viewCell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width, [self cellHeight]);
}

// section 内偏移量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

// 上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return adaptToWidth(spaceY);
}

// 左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

@end


@implementation WVRDetailFooterCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float toX = ceilf(fitToWidth(lengthX));
        float picWidth = ceilf(self.height/9.0 * 16);
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(toX, 0, picWidth, self.height)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        
        [self addSubview:imageV];
        _imageView = imageV;
        
        
        float toImg = ceilf(fitToWidth(10));
        float titleWidth = self.width - (imageV.bottomX + toImg) - toX;
        YYLabel *titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(imageV.bottomX + toImg, 0, titleWidth, self.height/2.0)];
        titleLabel.numberOfLines = 1;
        titleLabel.font = kFontFitForSize(15.5);
        
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        
        YYLabel *timeLabel = [[YYLabel alloc] initWithFrame:CGRectMake(titleLabel.x, titleLabel.bottomY, titleLabel.width, titleLabel.height)];
        
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    
    return self;
}

- (void)setModel:(WVRDetailFooterModel *)model {
    
    if (_model != model) {
        
        _model = model;
        
        [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:model.imageURL]];
        
        _titleLabel.text = model.title;
        
        NSString *str;
        NSString *playCount = [WVRComputeTool numberToString:model.playCount];
        
        if (model.playCount > 0 && model.timeDuration.length > 0) {     // 次数为0时不显示
            
            str = [NSString stringWithFormat:@"  %@播放 / %@", playCount, model.timeDuration];
        } else if (model.timeDuration.length > 0) {
            
            str = [NSString stringWithFormat:@"  %@", model.timeDuration];
        } else if (model.playCount > 0) {
            
            str = [NSString stringWithFormat:@"  %@播放", playCount];
        } else {
            _timeLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
            return;     // 都没有数据，显示空字符串（不可见）
        }
        
        UIFont *font = kFontFitForSize(13);
        UIImage *image = [UIImage imageNamed:@"icon_playCount"];
        
        NSMutableAttributedString *text = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:[[NSAttributedString alloc]
                                      initWithString:str
                                      attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHex:0xb4b4b4], NSFontAttributeName:font }]];
        _timeLabel.attributedText = text;
    }
}

@end


@implementation WVRDetailFooterModel

- (NSString *)timeDuration {
    
    if (self.totalTime.length > 0) {
        return self.totalTime;
    }
    
    if (self.duration <= 0) {
        return @"";
    }
    
    NSInteger time = self.duration;
    
    long minute   = time/60;
    long second   = time%60;
    
    return [NSString stringWithFormat:@"%ld'%ld\"", minute, second];
}

@end

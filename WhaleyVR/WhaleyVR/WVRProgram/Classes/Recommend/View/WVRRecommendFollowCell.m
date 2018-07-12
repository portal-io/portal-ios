//
//  WVRRecommendFollowCell.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 推荐关注主列表Cell

#import "WVRRecommendFollowCell.h"
#import "WVRAttentionModel.h"
//#import "WVRLoginTool.h"
#import "WVRMediator+AccountActions.h"

@interface WVRRecommendFollowCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView;
@property (nonatomic, weak) WVRRecommendFollowCellHeader *headerView;
@property (nonatomic, weak) WVRRecommendFollowCellIntroView *introView;

@property (nonatomic, assign) float mainViewOffSet;

@end


@implementation WVRRecommendFollowCell

static NSString *const recommendFollowCellItemId   = @"recommendFollowCellItemId";
static NSString *const recommendFollowCellFooterId = @"recommendFollowCellFooterId";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self createHeaderView];
        [self createIntroView];
        
        _mainViewOffSet = _introView.width + _headerView.width;
        [self createMainView];
    }
    return self;
}

- (void)createMainView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(adaptToWidth(125), self.height);
    layout.footerReferenceSize = CGSizeMake(adaptToWidth(88), self.height);
    layout.sectionInset = UIEdgeInsetsMake(0, _mainViewOffSet, 0, 0);
    layout.minimumLineSpacing = adaptToWidth(9);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor clearColor];
    mainView.showsHorizontalScrollIndicator = NO;
    
    [mainView registerClass:[WVRRecommendFollowCellItem class] forCellWithReuseIdentifier:recommendFollowCellItemId];
    [mainView registerClass:[WVRRecommendFollowCellFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:recommendFollowCellFooterId];
    
    [self insertSubview:mainView belowSubview:_headerView];
    _mainView = mainView;
}

- (void)createHeaderView {
    
    WVRRecommendFollowCellHeader *header = [[WVRRecommendFollowCellHeader alloc] initWithFrame:CGRectMake(0, 0, adaptToWidth(88), self.height)];
    
    [header.button addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:header];
    _headerView = header;
}

- (void)createIntroView {
    WVRRecommendFollowCellIntroView *intro = [[WVRRecommendFollowCellIntroView alloc] initWithFrame:CGRectMake(_headerView.bottomX, 0, adaptToWidth(150), self.height)];
    
    [self insertSubview:intro belowSubview:_headerView];
    _introView = intro;
}

- (void)fillInfo {
    
    _headerView.picUrl = _dataModel.cpInfo.headPic;
    _headerView.cpCode = _dataModel.cpInfo.code;
    [_headerView updateFollowBtn:_dataModel.cpFollow > 0];
    
    _introView.name = _dataModel.cpInfo.name;
    _introView.fansCount = _dataModel.cpInfo.fansCount;
    _introView.intro = _dataModel.cpInfo.info;
    
    [self.mainView reloadData];
}

#pragma mark - setter

- (void)setDataModel:(WVRRecommendFollowItemModel *)dataModel {
    
    if (_dataModel != dataModel) {
        _dataModel = dataModel;
        
        [self fillInfo];
    }
}

#pragma mark - action

- (void)headerButtonClick:(UIButton *)sender {
    
    if ([self.realDelegate respondsToSelector:@selector(itemCellDidSelectAtIndex:withDataModel:)]) {
        [self.realDelegate itemCellDidSelectAtIndex:-1 withDataModel:_dataModel];
    }
}

#pragma mark - extern func

- (void)stopCollectionAnimation {
    
    CGPoint offset = self.mainView.contentOffset;
    offset.x ++;
    [self.mainView setContentOffset:offset animated:NO];
}

- (float)offsetX {
    
    return self.mainView.contentOffset.x;
}

- (void)setOffsetX:(float)offsetX {
    
    [self.mainView setContentOffset:CGPointMake(offsetX, 0)];
}

- (void)updateFansCountWithFollow:(BOOL)isFollow cpCode:(NSString *)cpCode {
    
    if ([cpCode isEqualToString:self.dataModel.cpInfo.code]) {
        
        int count = isFollow ? 1 : -1;
        _dataModel.cpInfo.fansCount = _dataModel.cpInfo.fansCount + count;
        
        [self.introView setFansCount:_dataModel.cpInfo.fansCount];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float x = _headerView.frame.size.width - scrollView.contentOffset.x;
    self.introView.x = x;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.realDelegate respondsToSelector:@selector(itemCellDidSelectAtIndex:withDataModel:)]) {
        [self.realDelegate itemCellDidSelectAtIndex:indexPath.item withDataModel:_dataModel];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataModel.cpProgramDtos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRRecommendFollowCellItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:recommendFollowCellItemId forIndexPath:indexPath];
    
    WVRPublisherListItemModel *model = [_dataModel.cpProgramDtos objectAtIndex:indexPath.item];
    item.name = model.displayName;
    item.picUrl = model.smallPic;
    item.playCount = model.stat.playCount;
    
    return item;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        WVRRecommendFollowCellFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:recommendFollowCellFooterId forIndexPath:indexPath];
        if ([footer.moreBtn allTargets].count == 0) {
            [footer.moreBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        return footer;
    }
    
    return nil;
}


@end

/********************************************/

@implementation WVRRecommendFollowCellFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createMoreBtn];
    }
    return self;
}

- (void)createMoreBtn {
    
    float width = adaptToWidth(72);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, adaptToWidth(24), width, width);
    btn.centerX = self.width / 2.f;
    btn.layer.borderWidth = 1.5;
    btn.layer.borderColor = k_Color8.CGColor;
    
    [btn.titleLabel setFont:kFontFitForSize(12)];
    [btn setTitle:@"查看全部" forState:UIControlStateNormal];
    [btn setTitleColor:k_Color6 forState:UIControlStateNormal];
    
    [self addSubview:btn];
    _moreBtn = btn;
}

@end

/********************************************/

@interface WVRRecommendFollowCellHeader ()

@property (nonatomic, weak) UIButton *followBtn;
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, assign) BOOL isFollow;

@end


@implementation WVRRecommendFollowCellHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        
        [self createImageView];
        [self createButton];
        [self createFollowBtn];
    }
    return self;
}

- (void)createButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = self.bounds;
    
    [self addSubview:btn];
    _button = btn;
}

- (void)createImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(21.5), adaptToWidth(24), adaptToWidth(45), adaptToWidth(45))];
    
    imgV.layer.cornerRadius = imgV.height / 2.f;
    imgV.clipsToBounds = YES;
    imgV.userInteractionEnabled = YES;
    imgV.layer.borderWidth = fitToWidth(0.6);
    imgV.layer.borderColor = k_Color9.CGColor;
    
    [self addSubview:imgV];
    _imageView = imgV;
}

- (void)createFollowBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(adaptToWidth(10.5), adaptToWidth(87), adaptToWidth(67), adaptToWidth(30));
    
    [btn setTitle:@"关注" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"attention_btn_follow"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:kFontFitForSize(13.5)];
    btn.layer.cornerRadius = btn.height / 2.f;
    btn.layer.borderColor = k_Color1.CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    
    [btn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _followBtn = btn;
}

#pragma mark - action

- (void)followBtnClick:(UIButton *)sender {
    if([WVRUserModel sharedInstance].isLogined){
        [self followAction];
        return;
    }
//    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        @strongify(self);
//        [self followAction];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{@"completeCmd":cmd};
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
}

- (void)followAction {
    
    kWeakSelf(self);
    
    int status = _isFollow ? 0 : 1;
    
    [WVRAttentionModel requestForFollow:self.cpCode status:status block:^(id responseObj, NSError *error) {
        NSString *msg = nil;
        if (responseObj) {
            BOOL isFollow = (status == 1);
            [weakself updateFollowBtn:isFollow];
            WVRRecommendFollowCell *cell = (WVRRecommendFollowCell *)weakself.superview;
            if ([cell isKindOfClass:[WVRRecommendFollowCell class]]) {
                [cell updateFansCountWithFollow:isFollow cpCode:weakself.cpCode];
            }
            msg = (status == 1) ? kToastAttentionSuccess : kToastCancelAttentionSuccess;
        } else {
            msg = (status == 1) ? kToastAttentionFail : kToastCancelAttentionFail;
        }
        SQToastInKeyWindow(msg);
    }];
}

#pragma mark - extern func

- (void)setPicUrl:(NSString *)picUrl {
    
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:picUrl] placeholderImage:[UIImage imageNamed:@"default_publisher_icon"]];
}

- (void)updateFollowBtn:(BOOL)isFollow {
    
    _isFollow = isFollow;
    UIColor *color = isFollow ? k_Color8 : k_Color1;
    NSString *title = isFollow ? @"已关注" : @"关注";
    NSString *image = isFollow ? @"attention_btn_followed" : @"attention_btn_follow";
    
    [_followBtn setTitle:title forState:UIControlStateNormal];
    [_followBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    _followBtn.layer.borderColor = color.CGColor;
    [_followBtn setTitleColor:color forState:UIControlStateNormal];
}

@end

/********************************************/

@interface WVRRecommendFollowCellIntroView () {
    
    float _maxIntroHeight;
}

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UILabel *introLabel;
@property (nonatomic, weak) UIImageView *braces;    // 大括号

@end


@implementation WVRRecommendFollowCellIntroView

@synthesize fansCount = _fansCount;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createNameLabel];
        [self createCountLabel];
        [self createIntroLabel];
        [self createBraces];
    }
    return self;
}

- (void)createNameLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color3;
    label.font = kFontFitForSize(15);
    label.text = @"名字";
    [label sizeToFit];
    label.frame = CGRectMake(3, adaptToWidth(25), adaptToWidth(115), label.height);
    
    [self addSubview:label];
    _nameLabel = label;
}

- (void)createCountLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color7;
    label.font = kFontFitForSize(12);
    label.text = @"粉丝";
    [label sizeToFit];
    label.frame = CGRectMake(_nameLabel.x, _nameLabel.bottomY + adaptToWidth(3), _nameLabel.width, label.height);
    
    [self addSubview:label];
    _countLabel = label;
}

- (void)createIntroLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color5;
    label.font = kFontFitForSize(12);
    label.text = @"简介";
    label.numberOfLines = 0;
    
    label.frame = CGRectMake(_nameLabel.x, _countLabel.bottomY + adaptToWidth(9), _nameLabel.width, label.height);
    _maxIntroHeight = self.height - label.y - adaptToWidth(15);
    label.height = _maxIntroHeight;
    
    [self addSubview:label];
    _introLabel = label;
}

- (void)createBraces {
    
    float width = adaptToWidth(6);
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 3*width, 0, width, self.height)];
    imgV.image = [UIImage imageNamed:@"recommend_follow_line"];
    
    [self addSubview:imgV];
    _braces = imgV;
}

#pragma mark - setter

- (void)setName:(NSString *)name {
    
    _nameLabel.text = name;
}

- (void)setFansCount:(long)fansCount {
    
    _fansCount = fansCount;
    
    NSString *str = [NSString stringWithFormat:@"%@粉丝", [WVRComputeTool numberToString:fansCount]];
    _countLabel.text = str;
}

- (void)setIntro:(NSString *)intro {
    
    _introLabel.text = intro;
    
    CGSize size = [WVRComputeTool sizeOfString:intro Size:CGSizeMake(_introLabel.width, LONG_MAX) Font:_introLabel.font];
    
    float height = size.height;
    
    _introLabel.height = (height < _maxIntroHeight) ? height : _maxIntroHeight;
}

@end

/********************************************/

@interface WVRRecommendFollowCellItem ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *countLabel;

@end

@implementation WVRRecommendFollowCellItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createImageView];
        [self createNameLabel];
        [self createCountLabel];
    }
    return self;
}

- (void)createImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, adaptToWidth(24), self.width, adaptToWidth(72))];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    
    [self addSubview:imgV];
    _imageView = imgV;
}

- (void)createNameLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color3;
    label.font = kFontFitForSize(15);
    label.text = @"名字";
    [label sizeToFit];
    label.frame = CGRectMake(_imageView.x, _imageView.bottomY + adaptToWidth(5), _imageView.width, label.height);
    
    [self addSubview:label];
    _nameLabel = label;
}

- (void)createCountLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color7;
    label.font = kFontFitForSize(12);
    label.text = @"播放";
    [label sizeToFit];
    label.frame = CGRectMake(_imageView.x, _nameLabel.bottomY + adaptToWidth(3), _imageView.width, label.height);
    
    [self addSubview:label];
    _countLabel = label;
}

#pragma mark - setter

- (void)setPicUrl:(NSString *)picUrl {
    
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:picUrl] placeholderImage:HOLDER_IMAGE];
}

- (void)setName:(NSString *)name {
    
    _nameLabel.text = name;
}

- (void)setPlayCount:(long)playCount {
    
    NSString *str = [NSString stringWithFormat:@"%@播放", [WVRComputeTool numberToString:playCount]];
    _countLabel.text = str;
}

@end

/********************************************/

@interface WVRRecommendFollowHeader ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation WVRRecommendFollowHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createImageView];
    }
    return self;
}

- (void)createImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.bounds];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    
    [self addSubview:imgV];
    _imageView = imgV;
}

- (void)setPicUrl:(NSString *)picUrl {
    
    // _picUrl != picUrl
    if (![_picUrl isEqualToString:picUrl]) {
        _picUrl = picUrl;
        
        [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:picUrl] placeholderImage:HOLDER_IMAGE];
    }
}

@end


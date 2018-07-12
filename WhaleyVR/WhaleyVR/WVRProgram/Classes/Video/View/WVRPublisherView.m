//
//  WVRPublisherView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPublisherView.h"
#import "WVRAttentionModel.h"

#import "WVRPublisherDetailModel.h"
#import "WVRMediator+AccountActions.h"

@interface WVRPublisherView ()

@property (nonatomic, weak) UIButton *followBtn;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UILabel *nameLabel;

@property (atomic, assign) BOOL needRefresh;

@end


@implementation WVRPublisherView

@synthesize fansCount = _fansCount;

- (instancetype)init {
    
    float height = adaptToWidth(80);
    float screen_h = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    float screen_w = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    return [self initWithFrame:CGRectMake(0, screen_h - height, screen_w, height)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createImageView];
        [self createFollowBtn];
        [self createNameLabel];
        [self createCountLabel];
        
        [self createButton];
        
        [self registNoti];
    }
    return self;
}


- (void)createImageView {
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(adaptToWidth(10), 0, adaptToWidth(45), adaptToWidth(45))];
    
    imgV.layer.cornerRadius = imgV.height / 2.f;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    imgV.centerY = self.height / 2.f;
    imgV.userInteractionEnabled = YES;
    
    [self addSubview:imgV];
    _imageView = imgV;
}

- (void)createFollowBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, adaptToWidth(67), adaptToWidth(30));
    btn.bottomX = self.width - adaptToWidth(10.5);
    btn.centerY = _imageView.centerY;
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

- (void)createNameLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = k_Color3;
    label.font = kFontFitForSize(15);
    label.text = @"名字";
    [label sizeToFit];
    label.frame = CGRectMake(_imageView.bottomX + adaptToWidth(10), adaptToWidth(25), adaptToWidth(100), label.height);
    label.bottomY = _imageView.centerY - 3;
    
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
    label.y = _imageView.centerY + 3;
    
    [self addSubview:label];
    _countLabel = label;
}

- (void)createButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.imageView.frame;
    
    [self addSubview:btn];
    _button = btn;
}

#pragma mark - Notification

- (void)registNoti {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionStatusChanged:) name:kAttentionStatusNoti object:nil];
}

#pragma mark - Notification

- (void)loginStatusChanged:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    int status = [dict[@"status"] intValue];
    
    if (status == 0) {
        [self updateFollowBtn:NO];
    }
    
    self.needRefresh = (status == 1);
}

- (void)attentionStatusChanged:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSString *code = dict[@"cpCode"];
    if ([code isEqualToString:self.cpCode]) {
        
        int status = [dict[@"status"] intValue];
        [self updateFollowBtn:(status == 1)];
    }
}

#pragma mark - setter

- (void)setName:(NSString *)name {
    
    _nameLabel.text = name;
}

- (void)setIsFollow:(long)isFollow {
    
    [self updateFollowBtn:isFollow == 1];
}

- (void)setFansCount:(long)fansCount {
    
    _fansCount = fansCount;
    
    NSString *str = [WVRComputeTool numberToString:fansCount];
    _countLabel.text = [NSString stringWithFormat:@"%@粉丝", str];
}

- (void)setIconUrl:(NSString *)iconUrl {
    
    [_imageView wvr_setImageWithURL:[NSURL URLWithUTF8String:iconUrl] placeholderImage:[UIImage imageNamed:@"default_publisher_icon"]];
}

#pragma mark - action

- (void)followBtnClick:(UIButton *)sender {
    if ([WVRUserModel sharedInstance].isLogined) {
        [self followAction];
        return;
    }
//    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            return nil;
        }];
    }];
    NSDictionary * params = @{ @"completeCmd":cmd };
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
            int count = isFollow ? 1 : -1;
            [weakself setFansCount:(weakself.fansCount + count)];
            msg = (status == 1) ? kToastAttentionSuccess : kToastCancelAttentionSuccess;
        } else {
            msg = (status == 1) ? kToastAttentionFail : kToastCancelAttentionFail;
        }
        SQToastInKeyWindow(msg);
    }];
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

#pragma mark - external function

- (void)viewWillAppear {
    
    if (self.needRefresh) {
        self.needRefresh = NO;
        
        [self requestForAttentionStatus];
    }
}

- (void)requestForAttentionStatus {
    
    kWeakSelf(self);
    [WVRPublisherDetailModel requestForPublisherDetailWithCode:self.cpCode block:^(WVRPublisherDetailModel * model, NSError *error) {
        
        if (model) {
            [weakself updateFollowBtn:(model.follow == 1)];
        }
    }];
}

@end

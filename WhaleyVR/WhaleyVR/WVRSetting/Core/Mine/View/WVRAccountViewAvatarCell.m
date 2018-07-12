//
//  WVRAccountAvatarCell.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAccountViewAvatarCell.h"
#import "WVRMineAvatarCellViewModel.h"
#import <ReactiveObjC.h>

#define HEIGHT_AVATER_VIEW (94.f)

@interface WVRAccountViewAvatarCell ()

@property (nonatomic, strong) WVRMineAvatarCellViewModel * gViewModel;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *mBgView;
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation WVRAccountViewAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self allocSubviews];
        [self selfConfig];
        [self configSubviews];
        [self positionSubviews];
    }
    
    return self;
}

-(void)positionNickNameLable
{
    CGSize size = [self labelTextSize:_nickNameLabel];
    CGFloat nameWidth = MIN(SCREEN_WIDTH*2/3,size.width);
    CGFloat containerW = nameWidth + 10 + 13;
    CGRect tmpRect = [self centerRectInSubviewWithWidth:containerW height:size.height + fitToWidth(20.0f) toTop:_avatarImageView.bottom];
    _containerView.frame = tmpRect;

    tmpRect = [_containerView rectInSubviewWithWidth:nameWidth height:size.height toLeft:0 toTop:fitToWidth(10.0f)];
    _nickNameLabel.frame = tmpRect;

    tmpRect = [self rectInSubviewWithWidth:13 height:13 toLeft:_nickNameLabel.right + fitToWidth(10.f) toTop:fitToWidth(10.f)];
    _editNickImageView.frame = tmpRect;
    _editNickImageView.centerY = _nickNameLabel.centerY;
}

//-(void)bindViewModel:(id)viewModel
-(void)fillData:(id)args
{
    if (self.gViewModel == args) {
        return;
    }
    self.gViewModel = args;
    
    [self selfConfig];
    [self configSubviews];
    [self positionSubviews];
    @weakify(self);
    [[RACObserve([WVRUserModel sharedInstance], username) skip:0] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.nickNameLabel.text = [WVRUserModel sharedInstance].username;
        [self positionNickNameLable];
    }];
    
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:0] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        @strongify(self);
        [self updateCellisLogined:[WVRUserModel sharedInstance].isLogined];
        if(![WVRUserModel sharedInstance].isLogined){
            self.avatarImageView.image = [UIImage imageNamed:@"avatar_myPage"];
        }
    }];
    [[[RACObserve([WVRUserModel sharedInstance], loginAvatar) skip:0] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        @strongify(self);
        if ([WVRUserModel sharedInstance].isLogined) {
            if ([WVRUserModel sharedInstance].loginAvatar.length > 0) {
                
                [self requestForAvatar:[WVRUserModel sharedInstance].loginAvatar];
                
            } else {
                self.avatarImageView.image = [UIImage imageNamed:@"avatar_myPage"];
            }
        }else{
            self.avatarImageView.image = [UIImage imageNamed:@"avatar_myPage"];
        }
      self.gViewModel.clickSignal = [self.loginBtn rac_signalForSelector:@selector(buttonClicked:)];
    }];
}

- (void)selfConfig {
    
    [self setBackgroundColor:[UIColor greenColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)allocSubviews {
    
    _avatarImageView = [[UIImageView alloc] init];
    
    _nickNameLabel = [[UILabel alloc] init];
    _editNickImageView = [[UIImageView alloc] init];
    _containerView = [[UIView alloc] init];
    
    _seperateLine = [[UILabel alloc] init];
    _loginBtn = [[UIButton alloc] init];
    _registerBtn = [[UIButton alloc] init];
    self.settingBtn = [[UIButton alloc] init];
    self.mBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 206)];
    _bottomLine = [[UIView alloc] init];
}

- (void)configSubviews {
    
    self.mBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImage *img = [UIImage imageNamed:@"setting_bg"];
    [self.mBgView setImage:img];
    
    /* Title */
    [_nickNameLabel setText:@""];
    [_nickNameLabel setTextColor:[UIColor colorWithHex:0x2a2a2a]];
    [_nickNameLabel setFont:kFontFitForSize(17.5f)];
    [_nickNameLabel setTextAlignment:NSTextAlignmentLeft];
    _nickNameLabel.tag = WVRMAvatarClickTypeEdit;
    _nickNameLabel.userInteractionEnabled = YES;
    
    _avatarImageView.tag = WVRMAvatarClickTypeEdit;
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarImageView addGestureRecognizer:[self tapGesture]];
    
    _avatarImageView.layer.cornerRadius = fitToWidth(HEIGHT_AVATER_VIEW)/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _editNickImageView.image = [UIImage imageNamed:@"edit_nick"];
    _editNickImageView.tag = WVRMAvatarClickTypeEdit;
    _editNickImageView.userInteractionEnabled = YES;
    
    _containerView.tag = WVRMAvatarClickTypeEdit;
    _containerView.userInteractionEnabled = YES;
    [_containerView addGestureRecognizer:[self tapGesture]];
    
    _seperateLine.backgroundColor = [UIColor colorWithHex:0xc9c9c9];
    
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.tag = WVRMAvatarClickTypeLogin;
    [_loginBtn.titleLabel setFont:kFontFitForSize(15)];
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        
//    }];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.tag = WVRMAvatarClickTypeRegister;
    [_registerBtn.titleLabel setFont:kFontFitForSize(15)];
    [_registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_containerView addSubview:_nickNameLabel];
    [_containerView addSubview:_editNickImageView];
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
    [self addSubview:_avatarImageView];
    [self addSubview:_containerView];
    [self addSubview:_seperateLine];
    [self addSubview:_loginBtn];
    [self addSubview:_registerBtn];
    [self addSubview:_bottomLine];
    
    [self.settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
    self.settingBtn.tag = WVRMAvatarClickTypeSetting;
    [self.settingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.settingBtn];
    self.backgroundView = self.mBgView;
}

- (void)positionSubviews {
    
    self.mBgView.frame = CGRectMake(0, 0, self.width, self.height);
    CGRect tmpRect = CGRectZero;
    
    tmpRect =  [self centerRectInSubviewWithWidth:fitToWidth(HEIGHT_AVATER_VIEW) height:fitToWidth(HEIGHT_AVATER_VIEW) toTop:fitToWidth(65.5f)];
    _avatarImageView.frame = tmpRect;
    
    CGSize size = [self labelTextSize:_nickNameLabel];
    CGFloat nameWidth = MIN(SCREEN_WIDTH*2/3,size.width);
    CGFloat containerW = nameWidth + 10 + 13;
    tmpRect = [self centerRectInSubviewWithWidth:containerW height:size.height + fitToWidth(20.0f) toTop:_avatarImageView.bottom];
    _containerView.frame = tmpRect;
    
    tmpRect = [_containerView rectInSubviewWithWidth:nameWidth height:size.height toLeft:0 toTop:fitToWidth(10.0f)];
    _nickNameLabel.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:13 height:13 toLeft:_nickNameLabel.right + fitToWidth(10.f) toTop:fitToWidth(10.f)];
    _editNickImageView.frame = tmpRect;
    _editNickImageView.centerY = _nickNameLabel.centerY;
    tmpRect =  [self centerRectInSubviewWithWidth:0.5 height:adaptToWidth(15.0f) toTop:self.height-fitToWidth(20.f)-fitToWidth(15.0f)];

    _seperateLine.frame = tmpRect;
    
    size = [self labelTextSize:_loginBtn.titleLabel];
    tmpRect = [self rectInSubviewWithWidth:size.width+adaptToWidth(20) height:size.height+adaptToWidth(15) toRight:_seperateLine.left + fitToWidth(31.0f) toTop:0];
    _loginBtn.frame = tmpRect;
    _loginBtn.centerY = _seperateLine.centerY;
    size = [self labelTextSize:_registerBtn.titleLabel];
    tmpRect = [self rectInSubviewWithWidth:size.width+adaptToWidth(20) height:size.height+adaptToWidth(15) toLeft:_seperateLine.right + fitToWidth(31.0f) toTop:0];
    _registerBtn.frame = tmpRect;
    _registerBtn.centerY = _seperateLine.centerY;
    tmpRect = [self centerRectInSubviewWithWidth:self.width height:0.5 toBottom:0.5];
    _bottomLine.frame = tmpRect;
    
    tmpRect = [self rectInSubviewWithWidth:fitToWidth(60.0f) height:fitToWidth(60.0f) toRight:fitToWidth(20.0f) toTop:fitToWidth(45.0f)];
    self.settingBtn.frame = tmpRect;
    self.settingBtn.centerY = fitToWidth(57.5f);
    self.settingBtn.centerX = SCREEN_WIDTH-fitToWidth(32.5f);
}

#pragma mark - 这个方法调用后会多处一条线
- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self positionSubviews];
}

- (CGSize)labelTextSize:(UILabel*) label {
    
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - label.x-10, 9999);//labelsize的最大值
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (void)updateCellisLogined:(BOOL)isLogined {
    
    if (isLogined) {
        _nickNameLabel.hidden = NO;
        _editNickImageView.hidden = NO;
        
        _seperateLine.hidden = YES;
        _loginBtn.hidden = YES;
        _registerBtn.hidden = YES;
        
        _avatarImageView.image = [WVRUserModel sharedInstance].tmpAvatar;
    } else {
        _nickNameLabel.hidden = YES;
        _editNickImageView.hidden = YES;
        
        _seperateLine.hidden = NO;
        _loginBtn.hidden = NO;
        _registerBtn.hidden = NO;
        _avatarImageView.image = [UIImage imageNamed:@"avatar_myPage"];
    }
    
    [self positionSubviews];
}

- (void)buttonClicked:(UIView *)sender {
    [self.gViewModel.gAvatarClickSubject sendNext:@(sender.tag)];

}

- (void)tapGestureResponse:(UIGestureRecognizer *)gesture
{
    UIView *tmpView = gesture.view;
    [self buttonClicked:tmpView];
}
#pragma mark - MISC

- (UIGestureRecognizer *)tapGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureResponse:)];
    return tapGesture;
}

- (void)requestForAvatar:(NSString *)avatar {
    
    NSLog(@"updateCellWithAvatar ->> %@", avatar);
    
    NSURL *url = [NSURL URLWithString:avatar];
    
    // NSURLRequestReloadIgnoringLocalAndRemoteCacheData 表示忽略本地和服务器的 缓存文件 直接从原始地址下载图片 缓存策略的一种
    NSURLRequest *re = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    kWeakSelf(self);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:re completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        int code = (int)res.statusCode;
        NSLog(@"updateCellWithAvatar statusCode: %d", code);
        
        if (code >= 200 && code < 300) {
            
            UIImage *overlayImage = [UIImage imageWithData:data];
            [WVRUserModel sharedInstance].tmpAvatar = overlayImage;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakself.avatarImageView.image = overlayImage;
            });
            
            [weakself saveAvatarImage:data];
        } else {
            DDLogError(@"updateCellWithAvatar error: %d", code);
            self.avatarImageView.image = [UIImage imageNamed:@"avatar_myPage"];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)saveAvatarImage:(NSData *)data {
    
    NSString *imageFilePath = [WVRFilePathTool getDocumentWithName:@"selfPhoto.jpg"];
    
    BOOL success = [data writeToFile:imageFilePath atomically:YES];    // 写入文件
    if (success) {
        
        NSLog(@"saveAvatarImage success");
    }
}

@end

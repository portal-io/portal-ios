//
//  WVRMineInfoView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/12/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineInfoView.h"

@interface WVRMineInfoView ()

@property (nonatomic, weak) UIImageView *avatarImgV;
@property (nonatomic, weak) UILabel *nicknameLabel;
@property (nonatomic, weak) UIButton *selfInfoBtn;

@property (nonatomic, weak) UIImageView *arrowsImgV;

@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *registerBtn;
@property (nonatomic, weak) UIView *line;

@end


@implementation WVRMineInfoView

// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSelf];
        [self createSubviews];
        [self initRAC];
    }
    return self;
}

- (void)configSelf {
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)createSubviews {
    
    [self avatarImgV];
    [self nicknameLabel];
    
    [self arrowsImgV];
    [self selfInfoBtn];
    [self registerBtn];
    [self line];
    [self loginBtn];
}

- (void)initRAC {
    
    @weakify(self);
    [RACObserve([WVRUserModel sharedInstance], isLogined) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self loginStatusChanged:[x boolValue]];
    }];
    [RACObserve([WVRUserModel sharedInstance], loginAvatar) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([WVRUserModel sharedInstance].isLogined) {
            if ([WVRUserModel sharedInstance].loginAvatar.length > 0) {
                
                [self requestForAvatar:[WVRUserModel sharedInstance].loginAvatar];
                
            } else {
                self.avatarImgV.image = [UIImage imageNamed:@"avatar_login"];
            }
        } else {
            self.avatarImgV.image = [UIImage imageNamed:@"avatar_login"];
        }
    }];
    [RACObserve([WVRUserModel sharedInstance], username) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        self.nicknameLabel.attributedText = [WVRUserModel sharedInstance].isLogined ? [self userNickname] : [self defaultNickname];
    }];
}


// MARK: - getter

- (UIImageView *)avatarImgV {
    if (!_avatarImgV) {
        UIImageView *imgV = [[UIImageView alloc] init];
        [self addSubview:imgV];
        _avatarImgV = imgV;
        
        float width = adaptToWidth(52);
        float top = adaptToWidth(31);
        float left = adaptToWidth(25);
        imgV.layer.cornerRadius = width * 0.5;
        imgV.layer.masksToBounds = YES;
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.height.equalTo(@(width));
            make.top.equalTo(@(top));
            make.left.equalTo(@(left));
        }];
    }
    return _avatarImgV;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        UILabel *label = [[UILabel alloc] init];
        
        [self addSubview:label];
        _nicknameLabel = label;
        
        float height = adaptToWidth(40);
        float width = adaptToWidth(150);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImgV.mas_right).offset(adaptToWidth(10));
            make.centerY.equalTo(_avatarImgV);
            make.height.equalTo(@(height));
            make.width.equalTo(@(width));
        }];
    }
    return _nicknameLabel;
}

- (UIImageView *)arrowsImgV {
    if (!_arrowsImgV) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icon_find_MA_goto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        imgV.tintColor = [UIColor whiteColor];
        [self addSubview:imgV];
        _arrowsImgV = imgV;
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgV.superview).offset(0 - fitToWidth(25));
            make.centerY.equalTo(_avatarImgV);
        }];
    }
    return _arrowsImgV;
}

- (UIButton *)selfInfoBtn {
    if (!_selfInfoBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSDictionary *att = @{ NSFontAttributeName: kFontFitForSize(13), NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3] };
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"个人信息" attributes:att];
        [btn setAttributedTitle:attStr forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _selfInfoBtn = btn;
        
        float height = fitToWidth(35);
        float width = fitToWidth(65);
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.arrowsImgV.mas_left);  // .offset(0 - fitToWidth(8))
            make.height.equalTo(@(height));
            make.width.equalTo(@(width));
            make.centerY.equalTo(weakself.avatarImgV);
        }];
    }
    return _selfInfoBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        NSDictionary *att = @{ NSFontAttributeName: kFontFitForSize(16.5), NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:1] };
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"注册" attributes:att];
        [btn setAttributedTitle:attStr forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _registerBtn = btn;
        
        float height = fitToWidth(35);
        float width = fitToWidth(55);
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.arrowsImgV.mas_left);  // .offset(0 - fitToWidth(8))
            make.height.equalTo(@(height));
            make.width.equalTo(@(width));
            make.centerY.equalTo(weakself.avatarImgV);
        }];
    }
    return _registerBtn;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self addSubview:line];
        
        _line = line;
        
        kWeakSelf(self);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.registerBtn.mas_left);
            make.height.equalTo(@(fitToWidth(12)));
            make.width.equalTo(@(1));
            make.centerY.equalTo(_avatarImgV);
        }];
    }
    return _line;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSDictionary *att = @{ NSFontAttributeName: kFontFitForSize(16.5), NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:1] };
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"登录" attributes:att];
        [btn setAttributedTitle:attStr forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _loginBtn = btn;
        
        float height = fitToWidth(35);
        float width = fitToWidth(55);
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.line.mas_left);  // .offset(0 - fitToWidth(8))
            make.height.equalTo(@(height));
            make.width.equalTo(@(width));
            make.centerY.equalTo(weakself.avatarImgV);
        }];
    }
    return _loginBtn;
}

- (NSAttributedString *)defaultNickname {
    
    NSDictionary *att = @{ NSFontAttributeName: kFontFitForSize(12), NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3] };
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"您未登录" attributes:att];
    
    return attStr;
}

- (NSAttributedString *)userNickname {
    
    NSDictionary *att = @{ NSFontAttributeName: kFontFitForSize(17), NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:1] };
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[WVRUserModel sharedInstance].username attributes:att];
    
    return attStr;
}

// MARK: - login status change

- (void)loginStatusChanged:(BOOL)isLogined {
    
    self.loginBtn.hidden = isLogined;
    self.registerBtn.hidden = self.loginBtn.hidden;
    self.line.hidden = self.loginBtn.hidden;
    
    self.selfInfoBtn.hidden = !isLogined;
    
    self.nicknameLabel.attributedText = isLogined ? [self userNickname] : [self defaultNickname];
}

// MARK: - action

- (void)btnClick:(UIButton *)sender {
    
    if (self.infoClickBlock) {
        self.infoClickBlock();
    }
}

- (void)registerBtnClick:(UIButton *)sender {
    if (self.registerClickBlock) {
        self.registerClickBlock();
    }
}

- (void)loginBtnClick:(UIButton *)sender {
    if (self.loginClickBlock) {
        self.loginClickBlock();
    }
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
                
                weakself.avatarImgV.image = overlayImage;
            });
            
            [weakself saveAvatarImage:data];
        } else {
            DDLogError(@"updateCellWithAvatar error: %d", code);
            self.avatarImgV.image = [UIImage imageNamed:@"avatar_login"];
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

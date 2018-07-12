
//
//  WVRSQDownView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQDownView.h"
#import "UIButton+Extends.h"
#import "WVRAppContextHeader.h"

@interface WVRSQDownView ()

@property (weak, nonatomic) IBOutlet WVRSQDownView *view;
@property (nonatomic, strong) WVRSQDownViewInfo * viewInfo;

@property (nonatomic) UIButton *downBtn;

- (IBAction)downBtnOnClick:(UIButton *)sender;

@property (nonatomic) NSString * defaultTitle;
@property (nonatomic) NSString * downingTitle;
@property (nonatomic) NSString * pauseTitle;
@property (nonatomic) NSString * downTitle;
@property (nonatomic) NSString * downFailTitle;

@property (nonatomic) NSString* downIcon;

@end


@implementation WVRSQDownView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
//        VIEW_WITH_NIB([WVRSQDownView description]);
        [self initTitle];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [[NSBundle mainBundle] loadNibNamed:@"WVRSQDownView" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.downBtn.layer.masksToBounds = YES;
    self.downBtn.layer.cornerRadius = 4.0f;
    self.downBtn.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    self.downBtn.layer.borderWidth = 1.0f;
}

+ (instancetype)loadView {
    
    WVRSQDownView * downView = [[WVRSQDownView alloc] init];
    [downView initTitle];
    [[NSBundle mainBundle] loadNibNamed:@"WVRSQDownView" owner:downView options:nil];
    downView.frame = downView.view.frame;
    [downView addSubview:downView.view];
    return downView;
}

- (void)initTitle {
    
    self.defaultTitle = @"缓存";
    self.downingTitle = @"等待";
    self.pauseTitle = @"继续";
    self.downTitle = @"播放";
    self.downFailTitle = @"重新缓存";
    self.downIcon = @"icon_download_default";
}

- (void)updateTitle:(NSString*)defaultTitle downingTitle:(NSString*)downingTitle pauseTitle:(NSString*)pauseTitle downTitle:(NSString*)downTitle downFailTitle:(NSString*)downFailTitle {
    
    if (defaultTitle) {
        self.defaultTitle = defaultTitle;
    }
    if (downingTitle) {
        self.downingTitle = downingTitle;
    }
    if (pauseTitle) {
        self.pauseTitle = pauseTitle;
    }
    if (downTitle) {
        self.downTitle = downTitle;
        self.downIcon = @"icon_download_did";
    }
    if (downFailTitle) {
        self.downFailTitle = downFailTitle;
    }
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initTitle];
        self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.downBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.downBtn addTarget:self action:@selector(downBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.downBtn];
    }
    return self;
}

- (void)reloadData {
    
    self.downBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.downBtn setTitleColor:UIColorFromRGB(0x898989) forState:UIControlStateNormal];
    switch (self.viewInfo.downStatus) {
        case WVRSQDownViewStatusDefault:
            self.downBtn.userInteractionEnabled = YES;
            [self.downBtn setTitle:self.defaultTitle forState:UIControlStateNormal];
//            [self.downBtn setBackgroundImage:[UIImage imageNamed:@"icon_download_default"] forState:UIControlStateNormal];
            [self.downBtn setBackgroundImageWithColor:Color_RGB(249, 249, 249) forState:UIControlStateNormal];
            break;
        case WVRSQDownViewStatusDowning:
            self.downBtn.userInteractionEnabled = YES;
            [self.downBtn setTitle:self.downingTitle forState:UIControlStateNormal];
//            [self.downBtn setBackgroundImage:[UIImage imageNamed:@"icon_download_did"] forState:UIControlStateNormal];
            [self.downBtn setBackgroundImageWithColor:Color_RGB(249, 249, 249) forState:UIControlStateNormal];
            break;
        case WVRSQDownViewStatusPrepare:
            self.downBtn.userInteractionEnabled = YES;
            [self.downBtn setTitle:@"等待" forState:UIControlStateNormal];
            //            [self.downBtn setBackgroundImage:[UIImage imageNamed:@"icon_download_did"] forState:UIControlStateNormal];
            [self.downBtn setBackgroundImageWithColor:Color_RGB(249, 249, 249) forState:UIControlStateNormal];
            break;
        case WVRSQDownViewStatusPause:
            self.downBtn.userInteractionEnabled = YES;
            [self.downBtn setTitle:self.pauseTitle forState:UIControlStateNormal];
//            [self.downBtn setBackgroundImage:[UIImage imageNamed:@"icon_download_default"] forState:UIControlStateNormal];
            [self.downBtn setBackgroundImageWithColor:Color_RGB(249, 249, 249) forState:UIControlStateNormal];
            break;
        case WVRSQDownViewStatusDown:
            self.downBtn.userInteractionEnabled = ![self.downTitle isEqualToString:@"播放"];
            [self.downBtn setTitle:self.downTitle forState:UIControlStateNormal];
//            [self.downBtn setBackgroundImage:[UIImage imageNamed:self.downIcon] forState:UIControlStateNormal];
            break;
        case WVRSQDownViewStatusDownFail:
            self.downBtn.userInteractionEnabled = YES;
            [self.downBtn setTitle:self.downFailTitle forState:UIControlStateNormal];
//            [self.downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [self.downBtn setBackgroundImage:[UIImage imageNamed:@"icon_download_default"] forState:UIControlStateNormal];
            [self.downBtn setBackgroundImageWithColor:Color_RGB(249, 249, 249) forState:UIControlStateNormal];
            self.downBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            break;
        default:
            break;
    }
}

- (void)updateViewWithInfo:(WVRSQDownViewInfo*)viewInfo {
    
    self.viewInfo = viewInfo;
    [self reloadData];
}


- (IBAction)downBtnOnClick:(UIButton *)sender {
    
    if (self.viewInfo.delegate) {
        [self callDelegate];
    } else {
        [self callBlock];
    }
}

- (void)callDelegate {
    
    id<WVRSQDownViewDelegate> delegate = self.viewInfo.delegate;
    switch (self.viewInfo.downStatus) {
        case WVRSQDownViewStatusDefault:
            [delegate startDownOnClick];
            break;
        case WVRSQDownViewStatusDowning:
            [delegate pauseDownOnClick];
            break;
        case WVRSQDownViewStatusDown:
            
            break;
        default:
            break;
    }

}

- (void)callBlock {
    
    switch (self.viewInfo.downStatus) {
        case WVRSQDownViewStatusDefault:
            self.viewInfo.startDownBlock();
            break;
        case WVRSQDownViewStatusPause:
            self.viewInfo.prepareDownBlock();
            break;
        case WVRSQDownViewStatusPrepare:
            self.viewInfo.pauseDownBlock();
            break;
        case WVRSQDownViewStatusDownFail:
            self.viewInfo.restartDownBlock();
            break;
        case WVRSQDownViewStatusDowning:
            self.viewInfo.pauseDownBlock();
            break;
        case WVRSQDownViewStatusDown:
            self.viewInfo.stopDownBlock();
            break;
            
        default:
            break;
    }
}

- (void)updateWithStatus:(WVRSQDownViewStatus)status {
    
    self.viewInfo.downStatus = status;
    [self reloadData];
}

- (void)updateProgress:(float)progress {
    
    NSString * progressTitle = [NSString stringWithFormat:@"%.f%@", progress * 100, @"%"];
    [self.downBtn setTitle:progressTitle forState:UIControlStateNormal];
    self.downingTitle = progressTitle;
}

- (void)updateViewFrame {
    
    self.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end


@implementation WVRSQDownViewInfo

@end

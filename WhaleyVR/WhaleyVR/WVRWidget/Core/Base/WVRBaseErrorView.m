//
//  WVRBaseNullView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseErrorView.h"
#import "SNUtilToolHead.h"

@interface WVRBaseErrorView ()

@property (nonatomic, strong) WVRBaseErrorView * contentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *retryBtn;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) void (^reloadBlock)(void);

- (IBAction)tryOnClick:(id)sender;

@end


@implementation WVRBaseErrorView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self loadView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}


- (WVRBaseErrorView *)contentView {
    
    if (!_contentView) {
        _contentView = (WVRBaseErrorView*)VIEW_WITH_NIB(NSStringFromClass([self class]));
        
    }
    return _contentView;
}

- (void)loadView {
    [self initSubViews];
    [self addSubview:self.contentView];
}

-(void)initSubViews
{
    [self.contentView.retryBtn setTitleColor:[UIColor colorWithHex:0x858585] forState:UIControlStateNormal];
    
    self.contentView.retryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.contentView.retryBtn.backgroundColor = [UIColor colorWithHex:0xfcfcfc];
    
    self.contentView.retryBtn.layer.borderWidth = 1;
    self.contentView.retryBtn.layer.borderColor = [UIColor colorWithHex:0xdcdcdc].CGColor;
    
    self.contentView.retryBtn.layer.cornerRadius = 4;
    self.contentView.retryBtn.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

#pragma mark - WVRErrorView

- (void)setTryBlock:(void (^)(void))reloadBlock {
    
    self.contentView.num = 1000;
    self.contentView.reloadBlock = reloadBlock;
}

- (IBAction)tryOnClick:(id)sender {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}
@end

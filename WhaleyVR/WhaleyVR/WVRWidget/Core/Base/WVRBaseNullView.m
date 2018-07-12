//
//  WVRBaseNullView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseNullView.h"
#import "SNUtilToolHead.h"

@interface WVRBaseNullView ()

@property (nonatomic, strong) WVRBaseNullView * contentView;
@property (nonatomic, copy) void (^reloadBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *textL;

@end


@implementation WVRBaseNullView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self loadView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}


-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = (WVRBaseNullView*)VIEW_WITH_NIB(NSStringFromClass([self class]));
        _contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponse)];
        [_contentView addGestureRecognizer:tapG];
    }
    return _contentView;
}

-(void)tapResponse
{
    if (self.contentView.reloadBlock) {
        self.contentView.reloadBlock();
    }
}

-(void)loadView
{
    self.contentView.frame = self.frame;
    [self addSubview:self.contentView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.bounds = self.bounds;
    self.contentView.center = self.center;
}

#pragma mark - WVRNullView

-(void)setContentText:(NSString *)text
{
    if (text) {
        [self.contentView.textL setText:text];
    }
}

-(void)setIcon:(NSString *)iconStr
{
    if (iconStr) {
        [self.contentView.iconIV setImage:[UIImage imageNamed:iconStr]];
    }
}

- (void)setTryBlock:(void (^)(void))reloadBlock {
    self.contentView.reloadBlock = reloadBlock;
}

@end

//
//  SQNavTitleView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQNavTitleView.h"

#define COLOR_DEFAULT ([UIColor clearColor])
#define COLOR_SELECT (UIColorFromRGB(0x1e9ef4))
#define FONT_DEFAULT ([UIFont systemFontOfSize:16.0f])
#define FONT_SELECT ([UIFont systemFontOfSize:16.0f])
@interface SQNavTitleView ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)leftBtnOnClick:(id)sender;
- (IBAction)rightBtnOnClick:(id)sender;
@end
@implementation SQNavTitleView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.leftBtn.selected = YES;
    self.leftBtn.userInteractionEnabled = NO;
    
    self.rightBtn.selected = NO;
    self.rightBtn.userInteractionEnabled = YES;
    
//    self.leftBtn.backgroundColor = COLOR_SELECT;
//    self.rightBtn.backgroundColor = COLOR_DEFAULT;
    self.leftBtn.titleLabel.font = FONT_SELECT;
    self.rightBtn.titleLabel.font = FONT_DEFAULT;
}

-(void)updateWithTitles:(NSArray*)titles
{
    [self.leftBtn setTitle:[titles firstObject] forState:UIControlStateNormal];
    [self.leftBtn setTitle:[titles firstObject] forState:UIControlStateSelected];
    [self.rightBtn setTitle:[titles lastObject] forState:UIControlStateNormal];
    [self.rightBtn setTitle:[titles lastObject] forState:UIControlStateSelected];
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex == 0) {
        [self leftBtnOnClick:nil];
    }else{
        [self rightBtnOnClick:nil];
    }
    _selectIndex = selectIndex;
    
}

- (IBAction)leftBtnOnClick:(id)sender {
    self.leftBtn.selected = YES;
    self.leftBtn.userInteractionEnabled = NO;
    self.rightBtn.selected = NO;
    self.rightBtn.userInteractionEnabled = YES;
//    self.leftBtn.backgroundColor = COLOR_SELECT;
//    self.rightBtn.backgroundColor = COLOR_DEFAULT;
    self.leftBtn.titleLabel.font = FONT_SELECT;
    self.rightBtn.titleLabel.font = FONT_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(onClick:index:)]) {
        [self.delegate onClick:self index:0];
    }
    _selectIndex = 0;
}

- (IBAction)rightBtnOnClick:(id)sender {
    self.leftBtn.selected = NO;
    self.leftBtn.userInteractionEnabled = YES;
    self.rightBtn.selected = YES;
    self.rightBtn.userInteractionEnabled = NO;
//    self.rightBtn.backgroundColor = COLOR_SELECT;
//    self.leftBtn.backgroundColor = COLOR_DEFAULT;
    self.rightBtn.titleLabel.font = FONT_SELECT;
    self.leftBtn.titleLabel.font = FONT_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(onClick:index:)]) {
        [self.delegate onClick:self index:1];
    }
    _selectIndex = 1;
}
@end

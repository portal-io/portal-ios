//
//  WVRPlayerFullSBottomView2DTV2DTV.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullSBottomView2DTV.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"
#import "WVRPlayBottomCellViewModel.h"

@interface WVRPlayerFullSBottomView2DTV ()

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (IBAction)defiBtnOnClick:(id)sender;

@end


@implementation WVRPlayerFullSBottomView2DTV

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGSize size = [WVRComputeTool sizeOfString:self.defiButton.titleLabel.text Size:CGSizeMake(800, 800) Font:self.defiButton.titleLabel.font];
    [self addLayerToButton:self.defiButton size:size];
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
    [RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), defiTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.defiButton setTitle:((WVRPlayBottomCellViewModel*)self.gViewModel).defiTitle forState:UIControlStateNormal];
    }];
}

- (void)addLayerToButton:(UIButton *)btn size:(CGSize)size {
    
    if (size.width == 0) {
        size = [WVRComputeTool sizeOfString:btn.titleLabel.text Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
    }
    
    CALayer *layer = [[CALayer alloc] init];
    float height = size.height + 6;
    float y = (btn.height - height) / 2.0;
    layer.frame = CGRectMake(0, y, btn.width, height);
    
    layer.cornerRadius = layer.frame.size.height / 2.0;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    [btn.layer insertSublayer:layer atIndex:0];
}

- (IBAction)defiBtnOnClick:(id)sender {
    if ([self.gViewModel.delegate respondsToSelector:@selector(chooseQuality)]) {
        [self.gViewModel.delegate chooseQuality];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self updateLeadingCons];
}
@end
